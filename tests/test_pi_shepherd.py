"""Tests for skills/pi-shepherd/scripts/pi-shepherd (no Rex, no Pi: both are faked)."""
import argparse
import importlib.machinery
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time
import unittest

sys.dont_write_bytecode = True  # keep __pycache__ out of the skill directory
SCRIPT = Path(__file__).resolve().parents[1] / "skills/pi-shepherd/scripts/pi-shepherd"
_loader = importlib.machinery.SourceFileLoader("pi_shepherd", str(SCRIPT))
_spec = importlib.util.spec_from_loader("pi_shepherd", _loader)
assert _spec is not None
ps = importlib.util.module_from_spec(_spec)
_loader.exec_module(ps)

SESSION, BLOCK = "session:s1", "block:b1"
FOOTER = "░▒▓ 🤖 sonnet-5-5 🧠 high 🌿 feature ⚙️ bash 🪟 ctx 10.6%/1.0m"
SCREEN = f"previous output\n{FOOTER}\n🔌 RTK: on\n"

REAL_ERRORS = {
    "quota": [
        '429 {"type":"error","error":{"type":"rate_limit_error","message":"This request would exceed your '
        'account\'s monthly spend limit. Please try again later."},"request_id":"req_1"}',
        "Codex error: The usage limit has been reached",
        "Claude Code transport: You've hit your 5-hour limit · resets 6:30pm (Europe/Madrid) "
        "(request id req_011Ch8tr1PTXuMeEGzyWY2TU)",
        "The ChatGPT user has reached their Subscription Sharing usage limit. Ask the user to try again "
        "after their usage limit resets or use an API key instead.",
    ],
    "api": [
        "Incomplete native response: Claude Code ended the session before the step completed",
        "WebSocket idle timeout after 300000ms",
        "Operation aborted",
        "The operation was aborted.",
        "OAuth refresh failed for openai: The operation timed out.",
        "Request timed out.",
    ],
}


class LogWriter:
    """Writes a Pi session log the way Pi does: one JSON entry per line."""

    def __init__(self, directory):
        self.path = Path(directory) / "2026-01-01T00-00-00-000Z_abc.jsonl"
        self.count = 0
        self.add({"type": "session", "cwd": "/work"})

    def add(self, entry):
        self.count += 1
        entry = {"id": f"e{self.count:04d}", "timestamp": f"2026-01-01T00:00:{self.count % 60:02d}Z", **entry}
        with open(self.path, "a") as f:
            f.write(json.dumps(entry) + "\n")
        return entry["id"]

    def user(self, text="do it"):
        return self.add({"type": "message", "message": {"role": "user", "content": [{"type": "text", "text": text}]}})

    def assistant(self, text="", stop="stop", error=None, provider="anthropic", model="claude-opus-5-5"):
        content = [{"type": "text", "text": text}] if text else []
        msg = {"role": "assistant", "content": content, "stopReason": stop, "provider": provider, "model": model}
        if error:
            msg["errorMessage"] = error
        return self.add({"type": "message", "message": msg})

    def tool_use(self):
        return self.add({"type": "message", "message": {"role": "assistant", "stopReason": "toolUse",
                                                        "content": [{"type": "toolCall", "name": "bash"}]}})

    def tool_result(self):
        return self.add({"type": "message", "message": {"role": "toolResult", "content": [{"type": "text", "text": "ok"}]}})

    def custom(self):
        return self.add({"type": "custom", "customType": "x", "data": {}})


def record(state, **kw):
    rec = {"state": state, "app": "pi", "updated_at": kw.pop("updated_at", "2026-01-01T00:00:00+00:00"),
           "owner": {"pid": 4242, "name": "node"}}
    rec.update(kw)
    return rec


def step(state="working", log=None, screen=SCREEN, **kw):
    return {"records": [record(state, **kw)], "log": log or [], "screen": screen}


class FakeRex:
    """Each status call pops the next scripted step; the last step repeats."""

    def __init__(self, steps, writer=None):
        self.steps, self.writer, self.current, self.calls = list(steps), writer, {}, 0

    def status(self, session, block):
        self.calls += 1
        if self.steps:
            self.current = self.steps.pop(0)
            for action in self.current.get("log", []):
                action(self.writer)
        if self.current.get("gone"):
            raise ps.RexGone(f'block target "{block}" not found')
        if self.current.get("unreachable"):
            raise ps.RexError("connection refused")
        return self.current.get("records", [])

    def capture(self, session, block):
        return self.current.get("screen", SCREEN)


class FakeHost:
    def __init__(self, log_dir, worktree="/work", alive=True):
        self.log_dir, self.worktree, self.is_alive = log_dir, worktree, alive

    def alive(self, pid):
        return self.is_alive

    def cwd(self, pid):
        return self.worktree

    def session_dir(self, pid):
        return self.log_dir


class Clock:
    def __init__(self):
        self.t = 1000.0

    def __call__(self):
        return self.t

    def sleep(self, s):
        self.t += s


def wait_args(**kw):
    a = dict(session=SESSION, block=BLOCK, timeout=3600, stall=900, poll=20)
    a.update(kw)
    return argparse.Namespace(**a)


class Base(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="pi-shepherd-test.")
        self.root = Path(self.tmp.name)
        self.log_dir = self.root / "sessions"
        self.log_dir.mkdir()
        self.writer = LogWriter(self.log_dir)
        self.host = FakeHost(str(self.log_dir), worktree=str(self.root))
        self._env = {k: os.environ.get(k) for k in ("PI_SHEPHERD_STATE_DIR", "TMPDIR")}
        os.environ["PI_SHEPHERD_STATE_DIR"] = str(self.root / "state")
        os.environ["TMPDIR"] = str(self.root)

    def tearDown(self):
        for k, v in self._env.items():
            if v is None:
                os.environ.pop(k, None)
            else:
                os.environ[k] = v
        self.tmp.cleanup()

    def reset(self):
        """Start from a clean log and state, for table-driven cases."""
        shutil.rmtree(self.root / "state", ignore_errors=True)
        self.writer.path.unlink()
        self.writer = LogWriter(self.log_dir)

    def wait(self, steps, host=None, writer=None, **kw):
        clock, lines = Clock(), []
        rex = FakeRex(steps, writer or self.writer)
        code = ps.run_wait(wait_args(**kw), rex=rex, host=host or self.host, clock=clock,
                           sleep=clock.sleep, out=lines.append)
        return code, "\n".join(lines), clock


def turn(text="All done.", **kw):
    """Log actions for one finished turn: user prompt, tool round trip, final assistant text."""
    def action(w):
        w.user()
        w.tool_use()
        w.tool_result()
        w.assistant(text, **kw)
    return action


def failing_turn(error, **kw):
    def action(w):
        w.user()
        w.assistant("", stop="error", error=error, **kw)
    return action


class Classification(Base):
    def test_done_after_working(self):
        code, out, _ = self.wait([step("working"), step("done", log=[turn("Implemented and committed.")])])
        self.assertEqual(code, ps.EXIT["DONE"])
        self.assertIn(f"EVENT DONE {SESSION} {BLOCK}", out)
        self.assertIn("Implemented and committed.", out)
        self.assertIn("sonnet-5-5", out)
        self.assertIn("high", out)

    def test_question_prints_the_full_question(self):
        text = "I found two ways to do this.\n\nA) a new table\nB) a JSON column\n\nWhich one do you prefer?"
        code, out, _ = self.wait([step("working"), step("done", log=[turn(text)])])
        self.assertEqual(code, ps.EXIT["QUESTION"])
        self.assertIn("EVENT QUESTION", out)
        self.assertIn("A) a new table", out)
        self.assertIn("Which one do you prefer?", out)

    def test_quota_errors(self):
        for error in REAL_ERRORS["quota"]:
            with self.subTest(error=error[:40]):
                self.reset()
                code, out, _ = self.wait([step("working"), step("error", message=error[:60],
                                                                log=[failing_turn(error)])])
                self.assertEqual(code, ps.EXIT["QUOTA"], out)
                self.assertIn("EVENT QUOTA", out)
                self.assertIn("anthropic/claude-opus-5-5", out)

    def test_quota_reports_the_reset_time(self):
        error = REAL_ERRORS["quota"][2]
        _, out, _ = self.wait([step("working"), step("error", log=[failing_turn(error)])])
        self.assertIn("reset: 6:30pm (Europe/Madrid)", out)

    def test_quota_without_reset_time_prints_no_reset_line(self):
        _, out, _ = self.wait([step("working"), step("error", log=[failing_turn(REAL_ERRORS["quota"][3])])])
        self.assertNotIn("reset:", out)

    def test_other_provider_errors(self):
        for error in REAL_ERRORS["api"]:
            with self.subTest(error=error[:40]):
                self.reset()
                code, out, _ = self.wait([step("working"), step("error", log=[failing_turn(error)])])
                self.assertEqual(code, ps.EXIT["API_ERROR"], out)
                self.assertIn("EVENT API_ERROR", out)
                self.assertIn(error, out)

    def test_error_state_without_log_error_uses_status_message(self):
        code, out, _ = self.wait([step("working"), step("error", message="Compaction failed",
                                                        log=[turn("partial")])])
        self.assertEqual(code, ps.EXIT["API_ERROR"])
        self.assertIn("Compaction failed", out)

    def test_blocked_reports_kind_and_message_once(self):
        blocked = step("blocked", kind="question", message="Allow rm -rf build?", updated_at="t1")
        code, out, _ = self.wait([step("working"), blocked])
        self.assertEqual(code, ps.EXIT["BLOCKED"])
        self.assertIn("kind: question", out)
        self.assertIn("Allow rm -rf build?", out)
        # Armed again while Pi still shows the same dialog: it is not a new event.
        code, _, _ = self.wait([blocked], timeout=200)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])

    def test_new_blocked_dialog_is_reported_again(self):
        self.wait([step("blocked", kind="auth", message="Login", updated_at="t1")])
        code, _, _ = self.wait([step("blocked", kind="auth", message="Login", updated_at="t2")])
        self.assertEqual(code, ps.EXIT["BLOCKED"])

    def test_aborted_turn(self):
        def aborted(w):
            w.user()
            w.assistant("partial", stop="aborted")
        code, out, _ = self.wait([step("working"), step("idle", log=[aborted])])
        self.assertEqual(code, ps.EXIT["ABORTED"])
        self.assertIn("EVENT ABORTED", out)

    def test_retry_errors_in_the_log_while_working_are_not_reported(self):
        steps = [step("working", log=[failing_turn(REAL_ERRORS["quota"][0])]),
                 step("working"),
                 step("done", log=[lambda w: w.assistant("Recovered after retry.")])]
        code, out, _ = self.wait(steps)
        self.assertEqual(code, ps.EXIT["DONE"], out)


class Stalls(Base):
    def test_working_without_log_or_screen_change_is_stalled(self):
        code, out, clock = self.wait([step("working")], stall=300, poll=20)
        self.assertEqual(code, ps.EXIT["STALLED"])
        self.assertIn("EVENT STALLED", out)
        self.assertGreaterEqual(clock.t - 1000, 300)
        self.assertLess(clock.t - 1000, 400)

    def test_screen_changes_are_progress(self):
        steps = [step("working", screen=f"streaming token {i}\n{FOOTER}") for i in range(40)]
        code, _, _ = self.wait(steps, stall=300, poll=20, timeout=600)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])

    def test_new_log_entries_are_progress(self):
        steps = [step("working", log=[lambda w: w.tool_result()]) for _ in range(40)]
        code, _, _ = self.wait(steps, stall=300, poll=20, timeout=600)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])

    def test_spinner_and_elapsed_timer_are_not_progress(self):
        spinners = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
        steps = [step("working", screen=f"── {spinners[i % 10]} Working ──\nElapsed {i}.{i % 7}s\n{FOOTER}")
                 for i in range(80)]
        code, _, _ = self.wait(steps, stall=300, poll=20, timeout=3600)
        self.assertEqual(code, ps.EXIT["STALLED"])

    def test_idle_pi_that_never_starts_a_turn_is_stalled(self):
        code, out, _ = self.wait([step("idle")], stall=120, poll=20)
        self.assertEqual(code, ps.EXIT["STALLED"])
        self.assertIn("state: idle", out)


class OncePerTurn(Base):
    def test_old_done_turn_does_not_fire_until_a_new_turn_settles(self):
        self.writer.user()
        self.writer.assistant("Old report.")
        # Armed right after a send: Pi still shows the previous turn as done.
        steps = [step("done")] * 3 + [step("working", log=[lambda w: w.user("next")]), step("working"),
                                      step("done", log=[lambda w: w.assistant("New report.")])]
        code, out, clock = self.wait(steps)
        self.assertEqual(code, ps.EXIT["DONE"])
        self.assertIn("New report.", out)
        self.assertNotIn("Old report.", out)
        self.assertGreater(clock.t - 1000, 60)

    def test_old_done_turn_alone_never_fires(self):
        self.writer.assistant("Old report.")
        code, _, _ = self.wait([step("done")], timeout=300, stall=0)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])

    def test_each_settled_turn_is_reported_once(self):
        code, _, _ = self.wait([step("working"), step("done", log=[turn("First.")])])
        self.assertEqual(code, ps.EXIT["DONE"])
        code, _, _ = self.wait([step("done")], timeout=300, stall=0)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])
        code, out, _ = self.wait([step("working"), step("done", log=[turn("Second.")])])
        self.assertEqual(code, ps.EXIT["DONE"])
        self.assertIn("Second.", out)

    def test_turn_that_finished_before_the_wait_was_armed_is_reported(self):
        self.wait([step("working"), step("done", log=[turn("First.")])])
        turn("Fast second.")(self.writer)  # finished between send and arm
        code, out, clock = self.wait([step("done")])
        self.assertEqual(code, ps.EXIT["DONE"])
        self.assertIn("Fast second.", out)
        self.assertLess(clock.t - 1000, 30)

    def test_entries_that_are_not_messages_do_not_start_a_new_turn(self):
        self.wait([step("working"), step("done", log=[turn("First.")])])
        self.writer.custom()
        code, _, _ = self.wait([step("done")], timeout=300, stall=0)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])

    def test_done_is_held_while_the_last_message_is_not_from_the_assistant(self):
        # Pi appended the next prompt to the log but status still shows the old turn.
        self.writer.assistant("Old.")
        steps = [step("done", log=[lambda w: w.user("next")]), step("done"),
                 step("working"), step("done", log=[lambda w: w.assistant("New.")])]
        code, out, _ = self.wait(steps)
        self.assertEqual(code, ps.EXIT["DONE"])
        self.assertIn("New.", out)

    def test_without_a_session_log_status_timestamps_key_the_turns(self):
        empty = FakeHost(str(self.root / "missing"))
        code, _, _ = self.wait([step("done", updated_at="t1")], host=empty, timeout=300, stall=0)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])
        code, _, _ = self.wait([step("done", updated_at="t1"), step("working", updated_at="t2"),
                                step("done", updated_at="t3")], host=empty)
        self.assertEqual(code, ps.EXIT["DONE"])


class Liveness(Base):
    def test_missing_block_is_gone(self):
        code, out, _ = self.wait([{"gone": True}])
        self.assertEqual(code, ps.EXIT["GONE"])
        self.assertIn("EVENT GONE", out)

    def test_no_status_records_is_gone_after_confirmation(self):
        code, out, clock = self.wait([{"records": []}])
        self.assertEqual(code, ps.EXIT["GONE"])
        self.assertIn("no status records", out)
        self.assertGreater(clock.t, 1000)

    def test_one_empty_poll_is_not_gone(self):
        code, _, _ = self.wait([{"records": []}, step("working"), step("done", log=[turn("ok")])])
        self.assertEqual(code, ps.EXIT["DONE"])

    def test_pi_process_exit_is_gone(self):
        code, out, _ = self.wait([step("working")], host=FakeHost(str(self.log_dir), alive=False))
        self.assertEqual(code, ps.EXIT["GONE"])
        self.assertIn("exited", out)

    def test_unreachable_rex_ends_with_error(self):
        code, out, _ = self.wait([{"unreachable": True}])
        self.assertEqual(code, ps.EXIT["ERROR"])
        self.assertIn("EVENT ERROR", out)
        self.assertIn("connection refused", out)

    def test_transient_rex_failure_is_retried(self):
        steps = [{"unreachable": True}] * 3 + [step("working"), step("done", log=[turn("ok")])]
        code, _, _ = self.wait(steps)
        self.assertEqual(code, ps.EXIT["DONE"])

    def test_timeout(self):
        code, out, clock = self.wait([step("working", screen=f"x{i}") for i in range(500)],
                                     timeout=100, poll=20)
        self.assertEqual(code, ps.EXIT["TIMEOUT"])
        self.assertIn("EVENT TIMEOUT", out)
        self.assertGreaterEqual(clock.t - 1000, 100)


class Heuristics(unittest.TestCase):
    def test_questions(self):
        for text in [
            "Which one do you prefer?",
            "Done with the schema.\n\nShould I use SQLite or Postgres?",
            "**Do you want me to proceed?**",
            "Two options:\n1. Rewrite it\n2. Patch it\n\nPlease choose one.",
            "I can do either.\nOption A: fast\nOption B: safe",
            "Before I proceed I need a decision on the API shape.",
            "Waiting for your call on the naming.",
        ]:
            with self.subTest(text=text):
                self.assertTrue(ps.asks_question(text))

    def test_statements(self):
        for text in [
            "All tests pass. Committed abc123 on branch x.",
            "Is the cache warm? I checked early on.\n\nFixed the bug.\nAdded a test.\nRan the suite: green.\nPushed.",
            "Result:\n```\nx = a ? b : c?\n```\nDone.",
            "Done:\n1. Fixed the parser\n2. Added a test",
            "",
        ]:
            with self.subTest(text=text):
                self.assertFalse(ps.asks_question(text))

    def test_classify_error(self):
        for error in REAL_ERRORS["quota"]:
            self.assertEqual(ps.classify_error(error), "QUOTA", error)
        for error in REAL_ERRORS["api"]:
            self.assertEqual(ps.classify_error(error), "API_ERROR", error)

    def test_reset_time(self):
        self.assertEqual(ps.reset_time(REAL_ERRORS["quota"][2]), "6:30pm (Europe/Madrid)")
        self.assertEqual(ps.reset_time(REAL_ERRORS["quota"][3]), "")

    def test_footer(self):
        self.assertEqual(ps.parse_footer(SCREEN), ("sonnet-5-5", "high"))
        self.assertEqual(ps.parse_footer("░▒▓ 🤖 gpt-6 🌿 x\n"), ("gpt-6", ""))
        self.assertEqual(ps.parse_footer("no footer"), ("", ""))
        self.assertEqual(ps.parse_footer("░▒▓ 🤖 gpt 6-luna 🧠 low 📁 x 🌿 main"), ("gpt 6-luna", "low"))

    def test_session_dir_naming_and_environ(self):
        self.assertEqual(ps.encode_cwd("/home/u/code/x"), "--home-u-code-x--")
        raw = b"A=1\0PI_CODING_AGENT_DIR=/agent/dir\0B=2\0"
        self.assertEqual(ps.environ_value(raw, "PI_CODING_AGENT_DIR"), "/agent/dir")
        self.assertEqual(ps.environ_value(raw, "MISSING"), "")


class LogReading(Base):
    def test_reads_the_end_of_a_long_log_with_a_huge_entry_in_the_middle(self):
        self.writer.assistant("Earlier answer.")
        self.writer.add({"type": "message", "message": {"role": "toolResult",
                                                        "content": [{"type": "text", "text": "x" * 600_000}]}})
        self.writer.assistant("Final answer.")
        log = ps.read_log(str(self.log_dir))
        self.assertEqual(log.settled["text"], "Final answer.")
        self.assertEqual(log.last_role, "assistant")

    def test_newest_session_file_wins(self):
        other = LogWriter(self.log_dir)
        other.path = self.log_dir / "2026-02-01T00-00-00-000Z_new.jsonl"
        other.add({"type": "message", "message": {"role": "assistant", "stopReason": "stop",
                                                  "content": [{"type": "text", "text": "newer"}]}})
        os.utime(other.path, (time.time() + 10, time.time() + 10))
        self.assertEqual(ps.read_log(str(self.log_dir)).settled["text"], "newer")


class Replacement(Base):
    def test_a_newer_wait_stops_the_older_one(self):
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        fake_rex = bin_dir / "rex"
        fake_rex.write_text("#!/bin/sh\n" + 'echo \'{"records":[{"state":"working","app":"pi","owner":{"pid":%d}}]}\'\n'
                            % os.getpid())
        fake_rex.chmod(0o755)
        env = {**os.environ, "PATH": f"{bin_dir}:{os.environ['PATH']}"}
        cmd = [sys.executable, "-I", str(SCRIPT), "wait", SESSION, BLOCK, "--timeout", "60s", "--poll", "1s"]
        first = subprocess.Popen(cmd, env=env, stdout=subprocess.PIPE, text=True)
        try:
            self.assertIn("watching", first.stdout.readline())
            second = subprocess.Popen(cmd, env=env, stdout=subprocess.PIPE, text=True)
            try:
                self.assertEqual(first.wait(timeout=20), ps.EXIT["STOPPED"])
                self.assertIn("EVENT STOPPED", first.stdout.read())
                self.assertIn("replaced previous wait", second.stdout.readline())
            finally:
                second.terminate()
                second.wait(timeout=10)
                second.stdout.close()
        finally:
            first.kill()
            first.wait()
            first.stdout.close()


class ContextAndStatus(Base):
    def make_repo(self):
        git = ["git", "-C", str(self.root), "-c", "user.name=t", "-c", "user.email=t@t"]
        subprocess.run(git + ["init", "-q", "-b", "feature"], check=True)
        subprocess.run(git + ["commit", "-q", "--allow-empty", "-m", "first commit"], check=True)
        (self.root / "dirty.txt").write_text("x")

    def context(self, rex):
        lines = []
        code = ps.cmd_context(argparse.Namespace(session=SESSION, block=BLOCK), rex=rex, host=self.host,
                              out=lines.append)
        output = "\n".join(lines)
        self.assertEqual(code, 0)
        saved = output.rsplit("saved: ", 1)[1].strip()
        return saved, Path(saved).read_text()

    def test_context_saves_the_brief(self):
        self.make_repo()
        turn("Implemented the feature.\n" + "line\n" * 50 + "Should I also update the docs?")(self.writer)
        rex = FakeRex([step("done", log=[failing_turn(REAL_ERRORS["quota"][2])])], self.writer)
        saved, body = self.context(rex)
        self.assertTrue(saved.startswith(str(self.root)))
        self.assertIn("Should I also update the docs?", body)
        self.assertIn("5-hour limit", body)
        self.assertIn("sonnet-5-5", body)
        self.assertIn(str(self.root), body)
        self.assertIn("first commit", body)
        self.assertIn("?? dirty.txt", body)

    def test_context_includes_the_full_last_assistant_message(self):
        turn("Full report.\nSecond line.\nShould I continue?")(self.writer)
        _, body = self.context(FakeRex([step("done")], self.writer))
        self.assertIn("Full report.\nSecond line.\nShould I continue?", body)

    def test_status_lists_pi_blocks_read_only(self):
        turn("ok")(self.writer)

        class Listing(FakeRex):
            def sessions(self):
                return [("session:s1", "proj")]

            def blocks(self, session):
                return [{"block_id": "block:b1", "label": "shell", "window_id": "window:w1"},
                        {"block_id": "block:b2", "label": "shell", "window_id": "window:w2"}]

            def windows(self, session):
                return {"window:w1": "my-worktree", "window:w2": "plain"}

            def status(self, session, block):
                return [record("done")] if block == "block:b1" else []

        ps.save_state(ps.block_key("session:s1", "block:b1"),
                      {"last_event": {"name": "QUESTION", "at": "2026-01-01T00:00:00Z"}})
        lines = []
        code = ps.cmd_status(argparse.Namespace(session=None), rex=Listing([step("done")], self.writer),
                             host=self.host, out=lines.append)
        output = "\n".join(lines)
        self.assertEqual(code, 0)
        self.assertEqual(len(lines), 1)
        self.assertIn("my-worktree", output)
        self.assertIn("block:b1", output)
        self.assertIn("state=done", output)
        self.assertIn("sonnet-5-5", output)
        self.assertIn("last=QUESTION", output)
        self.assertIn("wait=none", output)
        self.assertNotIn("plain", output)


class Cli(unittest.TestCase):
    def test_bad_arguments_exit_64(self):
        for argv in ([], ["wait"], ["wait", "s"], ["wait", "s", "b", "--timeout", "soon"], ["bogus"]):
            with self.subTest(argv=argv):
                r = subprocess.run([sys.executable, "-I", str(SCRIPT), *argv], capture_output=True, text=True)
                self.assertEqual(r.returncode, 64, r.stderr)

    def test_durations(self):
        self.assertEqual([ps.parse_duration(x) for x in ("90", "90s", "15m", "2h", "1d")], [90, 90, 900, 7200, 86400])


if __name__ == "__main__":
    unittest.main()
