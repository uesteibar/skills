#!/usr/bin/env bash
# Tests for the brief and log file writes of pr-shepherd. Loads the script (it has no
# .py extension) as a module and works only inside a temporary directory.
set -uo pipefail

REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
readonly SCRIPT=$REPO/skills/pr-shepherd/scripts/pr-shepherd
readonly TEMP_ROOT=${TMPDIR:-/tmp}

WORK=$(mktemp -d "$TEMP_ROOT/pr-shepherd-files-test.XXXXXX")
trap 'rm -rf -- "$WORK"' EXIT

python3 -I - "$SCRIPT" "$WORK" <<'PYEOF'
import importlib.machinery
import importlib.util
import os
import stat
import sys

script, work = sys.argv[1:3]
sys.dont_write_bytecode = True  # keep the repo free of __pycache__
loader = importlib.machinery.SourceFileLoader("pr_shepherd", script)
spec = importlib.util.spec_from_loader("pr_shepherd", loader)
mod = importlib.util.module_from_spec(spec)
loader.exec_module(mod)

fails = 0


def check(description, ok):
    global fails
    print(("PASS " if ok else "FAIL ") + description)
    fails += 0 if ok else 1


def mode(path):
    return stat.S_IMODE(os.stat(path).st_mode)


# 1. A new file is created with mode 0600 and the right content.
path = os.path.join(work, "new.md")
mod.write_private(path, "hello\n")
check("new file has mode 0600", mode(path) == 0o600)
check("new file has the text", open(path).read() == "hello\n")

# 1b. An older file with wider permissions is truncated and tightened.
path = os.path.join(work, "old.md")
with open(path, "w") as f:
    f.write("a much longer previous content\n")
os.chmod(path, 0o644)
mod.write_private(path, "short\n")
check("existing file is tightened to 0600", mode(path) == 0o600)
check("existing file is truncated", open(path).read() == "short\n")

# 2. A symlink planted at the target path is refused and its destination is untouched.
victim = os.path.join(work, "victim.txt")
with open(victim, "w") as f:
    f.write("precious\n")
os.chmod(victim, 0o644)
link = os.path.join(work, "planted.md")
os.symlink(victim, link)
try:
    mod.write_private(link, "overwritten\n")
    refused, message = False, ""
except mod.FileError as e:
    refused, message = True, str(e)
check("planted symlink is refused", refused)
check("error names the path and the symlink", link in message and "symlink" in message)
check("symlink destination content is unchanged", open(victim).read() == "precious\n")
check("symlink destination mode is unchanged", mode(victim) == 0o644)
dangling = os.path.join(work, "dangling.md")
os.symlink(os.path.join(work, "not-created.txt"), dangling)
try:
    mod.write_private(dangling, "x\n")
    refused = False
except mod.FileError:
    refused = True
check("dangling symlink is refused", refused)
check("dangling symlink destination is not created", not os.path.exists(os.path.join(work, "not-created.txt")))

# 3. The output directory is created 0700, and an existing wider one is tightened.
os.environ["TMPDIR"] = os.path.join(work, "tmp")
os.makedirs(os.environ["TMPDIR"])
out = mod.out_dir()
check("out_dir is under $TMPDIR/pr-shepherd", out == os.path.join(os.environ["TMPDIR"], "pr-shepherd"))
check("new out_dir has mode 0700", mode(out) == 0o700)
os.chmod(out, 0o755)
mod.out_dir()
check("existing wider out_dir is tightened to 0700", mode(out) == 0o700)

print("%d failed" % fails)
sys.exit(1 if fails else 0)
PYEOF
