#!/usr/bin/env bash
# Tests for the context brief, state directory and pid file writes of pi-shepherd. Loads the
# script (it has no .py extension) as a module and works only inside a temporary directory.
set -uo pipefail

REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
readonly SCRIPT=$REPO/skills/pi-shepherd/scripts/pi-shepherd
readonly TEMP_ROOT=${TMPDIR:-/tmp}

WORK=$(mktemp -d "$TEMP_ROOT/pi-shepherd-files-test.XXXXXX")
trap 'rm -rf -- "$WORK"' EXIT

python3 -I - "$SCRIPT" "$WORK" <<'PYEOF'
import argparse
import contextlib
import importlib.machinery
import importlib.util
import io
import os
import stat
import sys

script, work = sys.argv[1:3]
sys.dont_write_bytecode = True  # keep the repo free of __pycache__
loader = importlib.machinery.SourceFileLoader("pi_shepherd", script)
spec = importlib.util.spec_from_loader("pi_shepherd", loader)
mod = importlib.util.module_from_spec(spec)
loader.exec_module(mod)

fails = 0


def check(description, ok):
    global fails
    print(("PASS " if ok else "FAIL ") + description)
    fails += 0 if ok else 1


def mode(path):
    return stat.S_IMODE(os.stat(path).st_mode)


def read(path):
    with open(path) as f:
        return f.read()


class FakeRex:
    def status(self, session, block):
        return [{"state": "done", "owner": {"pid": 1}}]

    def capture(self, session, block):
        return ""


class FakeHost:
    def cwd(self, pid):
        raise OSError("no cwd in tests")


def run_context():
    """Run cmd_context with fakes; returns (exit code, stdout, stderr)."""
    out, err = io.StringIO(), io.StringIO()
    args = argparse.Namespace(session="s1", block="b1")
    with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
        code = mod.cmd_context(args, rex=FakeRex(), host=FakeHost(), out=print)
    return code, out.getvalue(), err.getvalue()


def context_files(directory):
    return sorted(os.path.join(directory, n) for n in os.listdir(directory) if n.startswith("context-"))


# 1. The context brief is 0600 in a 0700 directory.
tmp = os.path.join(work, "tmp")
os.makedirs(tmp)
os.environ["TMPDIR"] = tmp
code, stdout, stderr = run_context()
out = os.path.join(tmp, "pi-shepherd")
files = context_files(out)
check("context exits 0", code == 0)
check("context wrote one brief under $TMPDIR/pi-shepherd", len(files) == 1)
check("context directory has mode 0700", mode(out) == 0o700)
check("context file has mode 0600", bool(files) and mode(files[0]) == 0o600)
check("context file has the brief", bool(files) and read(files[0]).startswith("# Pi context s1 b1"))
check("context prints the saved path", bool(files) and f"saved: {files[0]}" in stdout)

# 1b. An existing wider directory is tightened.
os.chmod(out, 0o755)
mod.out_dir()
check("existing wider out_dir is tightened to 0700", mode(out) == 0o700)

# 2. A symlink planted at the brief path is refused; the destination is untouched.
victim = os.path.join(work, "victim.txt")
with open(victim, "w") as f:
    f.write("precious\n")
os.chmod(victim, 0o644)
real_time = mod.time.time
mod.time.time = lambda: 1700000000
try:
    link = os.path.join(out, "context-%s-1700000000.md" % mod.block_key("s1", "b1"))
    os.symlink(victim, link)
    code, stdout, stderr = run_context()
finally:
    mod.time.time = real_time
check("context through a planted symlink exits with ERROR", code == mod.EXIT["ERROR"])
check("context reports the symlink on stderr",
      stderr.strip() == f"pi-shepherd: cannot write {link}: it is a symlink")
check("context symlink destination content is unchanged", read(victim) == "precious\n")
check("context symlink destination mode is unchanged", mode(victim) == 0o644)
check("context prints nothing on stdout when refused", stdout == "")

# 3. The pid file is 0600; a planted symlink at the pid path is refused.
state = os.path.join(work, "state")
os.environ["PI_SHEPHERD_STATE_DIR"] = state
messages = []
pidfile = mod.replace_previous_wait("s1", "b1", messages.append)
check("pid file is in the state dir", pidfile == os.path.join(state, mod.block_key("s1", "b1") + ".pid"))
check("pid file has mode 0600", mode(pidfile) == 0o600)
check("pid file holds our pid", read(pidfile) == str(os.getpid()))
check("new state dir has mode 0700", mode(state) == 0o700)
os.remove(pidfile)
os.symlink(victim, pidfile)
try:
    mod.replace_previous_wait("s1", "b1", messages.append)
    refused, message = False, ""
except mod.FileError as e:
    refused, message = True, str(e)
check("planted pid symlink is refused", refused)
check("pid error names the path and the symlink", pidfile in message and "symlink" in message)
check("pid symlink destination content is unchanged", read(victim) == "precious\n")
err = io.StringIO()
with contextlib.redirect_stderr(err), contextlib.redirect_stdout(io.StringIO()):
    code = mod.cmd_wait(argparse.Namespace(session="s1", block="b1", timeout=1, stall=0, poll=1))
check("wait with a planted pid symlink exits with ERROR, no traceback",
      code == mod.EXIT["ERROR"] and "symlink" in err.getvalue() and "Traceback" not in err.getvalue())
check("pid symlink destination is still unchanged after wait", read(victim) == "precious\n")

# 4. An existing 0755 state directory is tightened to 0700.
os.chmod(state, 0o755)
check("state dir starts at 0755", mode(state) == 0o755)
check("state_dir returns the configured path", mod.state_dir() == state)
check("existing 0755 state dir is tightened to 0700", mode(state) == 0o700)

print("%d failed" % fails)
sys.exit(1 if fails else 0)
PYEOF
