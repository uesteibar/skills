#!/usr/bin/env bash
# Tests for ./install. Each case gets a fresh HOME in a temp dir and a copy of
# the installer in a fixture repo, so the real HOME and skills/ are never touched.
set -uo pipefail

REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
readonly TEMP_ROOT=${TMPDIR:-/tmp}

# Fixture helpers --------------------------------------------------------------

make_fixture() {
  FIXREPO=$HOME/repo
  AG=$HOME/.agents/skills
  CL=$HOME/.claude/skills
  ELSEWHERE=$HOME/elsewhere
  mkdir -p "$FIXREPO/skills/alpha" "$FIXREPO/skills/beta" "$ELSEWHERE"
  cp -- "$REPO/install" "$FIXREPO/install"
  chmod +x "$FIXREPO/install"
  printf '# alpha\n' > "$FIXREPO/skills/alpha/SKILL.md"
  printf '# beta\n' > "$FIXREPO/skills/beta/SKILL.md"
}

# run [args...]: runs the fixture installer, sets OUT and RC.
run() {
  OUT=$("$FIXREPO/install" "$@" 2>&1)
  RC=$?
}

# Assertions -------------------------------------------------------------------

FAILS=0

# expect <description> <command...>: records a failure when the command fails.
expect() {
  if ! "${@:2}" >/dev/null 2>&1; then
    FAILS=$((FAILS + 1))
    printf '  - expected: %s\n' "$1"
    printf '    rc=%s, output:\n%s\n' "${RC:-n/a}" "${OUT:-}" | sed 's/^/      /'
  fi
}

is_link_to() { # is_link_to <path> <expected target>
  [[ -L $1 && $(readlink -- "$1") == "$(readlink -f -- "$2")" ]]
}

is_copy() { # is_copy <path>: a real folder with a real SKILL.md
  [[ -d $1 && ! -L $1 && -f $1/SKILL.md && ! -L $1/SKILL.md ]]
}

absent() { [[ ! -e $1 && ! -L $1 ]]; }

reported() { # reported <verb> <name> <path>: output has this report line
  grep -qF -- "$(printf '%-7s %s -> %s' "$1" "$2" "$3")" <<<"$OUT"
}

has() { grep -qF -- "$2" <<<"$1"; }

notes() { grep -c '^note: ' <<<"$OUT"; } # number of note lines

unchanged_output() { ! grep -qE '^(link|copy|remove|skip) ' <<<"$OUT"; }

# Cases ------------------------------------------------------------------------

case_default_install() {
  run
  expect "exit 0" [ "$RC" -eq 0 ]
  expect "claude alpha links to repo" is_link_to "$CL/alpha" "$FIXREPO/skills/alpha"
  expect "claude beta links to repo" is_link_to "$CL/beta" "$FIXREPO/skills/beta"
  expect "agents alpha links to repo" is_link_to "$AG/alpha" "$FIXREPO/skills/alpha"
  expect "agents beta links to repo" is_link_to "$AG/beta" "$FIXREPO/skills/beta"
  expect "SKILL.md readable through the link" grep -qx '# alpha' "$CL/alpha/SKILL.md"
  expect "link reported" reported link alpha "$CL/alpha"
}

case_second_run_idempotent() {
  run
  run
  expect "second run exits 0" [ "$RC" -eq 0 ]
  expect "claude alpha reported ok" reported ok alpha "$CL/alpha"
  expect "agents beta reported ok" reported ok beta "$AG/beta"
  expect "second run changes nothing" unchanged_output
}

case_named_skill_and_unknown_name() {
  run nope
  expect "unknown name exits 2" [ "$RC" -eq 2 ]
  expect "unknown name creates no claude dir" absent "$HOME/.claude"
  expect "unknown name creates no agents dir" absent "$HOME/.agents"

  run alpha
  expect "named install exits 0" [ "$RC" -eq 0 ]
  expect "alpha linked in claude" is_link_to "$CL/alpha" "$FIXREPO/skills/alpha"
  expect "alpha linked in agents" is_link_to "$AG/alpha" "$FIXREPO/skills/alpha"
  expect "beta not installed" absent "$CL/beta"
}

case_real_folder_left_alone() {
  mkdir -p "$CL/alpha"
  printf 'mine\n' > "$CL/alpha/SKILL.md"
  run
  expect "exit 1 on conflict" [ "$RC" -eq 1 ]
  expect "alpha reported as skip" reported skip alpha "$CL/alpha"
  expect "user's folder untouched" grep -qx mine "$CL/alpha/SKILL.md"
  expect "beta still linked in claude" is_link_to "$CL/beta" "$FIXREPO/skills/beta"
}

case_symlinked_target_refused() {
  mkdir -p "$HOME/.claude"
  ln -s "$ELSEWHERE" "$CL"
  run
  expect "exit 3" [ "$RC" -eq 3 ]
  expect "error names the resolved path" has "$OUT" "$(readlink -f -- "$ELSEWHERE")"
  expect "other directory stays empty" [ -z "$(ls -A "$ELSEWHERE")" ]
  expect "agents target not created" absent "$AG"
  run --force
  expect "--force does not override (exit 3)" [ "$RC" -eq 3 ]
  expect "other directory still empty after --force" [ -z "$(ls -A "$ELSEWHERE")" ]
}

case_copy_and_uninstall() {
  run --copy
  expect "copy exits 0" [ "$RC" -eq 0 ]
  expect "claude alpha is a real folder" is_copy "$CL/alpha"
  expect "copy reported" reported copy alpha "$CL/alpha"

  run --uninstall
  expect "uninstall of identical copies exits 0" [ "$RC" -eq 0 ]
  expect "identical copy removed" absent "$CL/alpha"
  expect "identical agents copy removed" absent "$AG/beta"

  run --copy
  printf 'local edit\n' >> "$CL/alpha/SKILL.md"
  run --uninstall
  expect "modified copy makes uninstall exit 1" [ "$RC" -eq 1 ]
  expect "modified copy kept with its edit" grep -qx 'local edit' "$CL/alpha/SKILL.md"
  expect "modified copy reported as skip" reported skip alpha "$CL/alpha"
  expect "identical copy still removed" absent "$CL/beta"
}

case_uninstall_keeps_foreign_links() {
  run
  ln -s "$ELSEWHERE" "$CL/foreign-tool"
  run --uninstall
  expect "uninstall exits 0" [ "$RC" -eq 0 ]
  expect "claude alpha link removed" absent "$CL/alpha"
  expect "agents beta link removed" absent "$AG/beta"
  expect "foreign link left in place" is_link_to "$CL/foreign-tool" "$ELSEWHERE"

  ln -s "$ELSEWHERE" "$CL/beta"
  run --uninstall
  expect "foreign link named like a skill is skipped (exit 1)" [ "$RC" -eq 1 ]
  expect "that foreign link is kept" is_link_to "$CL/beta" "$ELSEWHERE"
}

case_dry_run_changes_nothing() {
  run --dry-run
  expect "dry run exits 0" [ "$RC" -eq 0 ]
  expect "dry run reports a link" reported link alpha "$CL/alpha"
  expect "no claude dir created" absent "$HOME/.claude"
  expect "no agents dir created" absent "$HOME/.agents"

  run --dry-run --dir "$HOME/custom"
  expect "dry run with --dir exits 0" [ "$RC" -eq 0 ]
  expect "custom dir not created" absent "$HOME/custom"
}

case_force_replaces_only_managed() {
  mkdir -p "$CL" "$AG"
  ln -s "$FIXREPO/skills/beta" "$CL/alpha"  # our link, pointing at the wrong skill
  ln -s "$ELSEWHERE" "$AG/beta"             # foreign link
  mkdir "$AG/alpha"                         # real folder with different content
  printf 'mine\n' > "$AG/alpha/SKILL.md"

  run
  expect "without --force the managed link is skipped" reported skip alpha "$CL/alpha"
  expect "without --force the link is unchanged" is_link_to "$CL/alpha" "$FIXREPO/skills/beta"

  run --force
  expect "exit 1 because of the two skips" [ "$RC" -eq 1 ]
  expect "managed link replaced by --force" is_link_to "$CL/alpha" "$FIXREPO/skills/alpha"
  expect "foreign link kept under --force" is_link_to "$AG/beta" "$ELSEWHERE"
  expect "different folder kept under --force" grep -qx mine "$AG/alpha/SKILL.md"
  expect "other links still created" is_link_to "$CL/beta" "$FIXREPO/skills/beta"
}

case_agent_filter() {
  run --agent claude
  expect "exit 0" [ "$RC" -eq 0 ]
  expect "claude linked" is_link_to "$CL/alpha" "$FIXREPO/skills/alpha"
  expect "agents untouched" absent "$AG"
  run --agent bogus
  expect "unknown agent exits 2" [ "$RC" -eq 2 ]
}

case_invalid_skill_names_refused() {
  local bad
  for bad in "alpha beta" "alpha " " alpha" "a/b" "../skills/alpha" ".." "alpha/" ""; do
    run "$bad"
    expect "name '$bad' exits 2" [ "$RC" -eq 2 ]
    run --copy "$bad"
    expect "name '$bad' with --copy exits 2" [ "$RC" -eq 2 ]
    run "$bad" --dir "$HOME/custom"
    expect "name '$bad' with --dir exits 2" [ "$RC" -eq 2 ]
  done
  expect "no claude dir created" absent "$HOME/.claude"
  expect "no agents dir created" absent "$HOME/.agents"
  expect "no custom dir created" absent "$HOME/custom"
  run "alpha beta"
  expect "message names the bad argument" has "$OUT" "alpha beta"
  run alpha beta
  expect "two separate valid names still install" [ "$RC" -eq 0 ]
  expect "alpha linked" is_link_to "$CL/alpha" "$FIXREPO/skills/alpha"
  expect "beta linked" is_link_to "$CL/beta" "$FIXREPO/skills/beta"
}

case_dir_inside_repo_refused() {
  local bad
  ln -s "$FIXREPO" "$HOME/repo-link"
  for bad in "$FIXREPO" "$FIXREPO/" "$FIXREPO/skills" "$FIXREPO/skills/alpha" "$FIXREPO/new/sub" \
             "$HOME/repo-link" "$HOME/repo-link/new" "$ELSEWHERE/../repo/new"; do
    run --dir "$bad"
    expect "--dir $bad exits 3" [ "$RC" -eq 3 ]
    run --copy --dir "$bad"
    expect "--copy --dir $bad exits 3" [ "$RC" -eq 3 ]
    run --uninstall --dir "$bad"
    expect "--uninstall --dir $bad exits 3" [ "$RC" -eq 3 ]
  done
  expect "error says the repo" has "$OUT" "inside this repo"
  expect "no folder made in the repo" absent "$FIXREPO/new"
  expect "alpha folder holds only its SKILL.md" [ "$(ls -A "$FIXREPO/skills/alpha")" == SKILL.md ]
  expect "skills/ holds only the two skills" [ "$(ls -A "$FIXREPO/skills" | wc -l)" -eq 2 ]

  mkdir -p "$HOME/repo-sibling"
  run --dir "$HOME/repo-sibling"
  expect "a sibling with the same prefix is allowed" [ "$RC" -eq 0 ]
  expect "alpha linked in the sibling" is_link_to "$HOME/repo-sibling/alpha" "$FIXREPO/skills/alpha"
}

case_uninstall_only_exact_links() {
  run
  rm "$CL/alpha"
  ln -s "$FIXREPO/skills/beta" "$CL/alpha"   # link to a different skill of this repo
  ln -s "$FIXREPO/skills/beta" "$ELSEWHERE/chain"
  rm "$AG/beta"
  ln -s "$ELSEWHERE/chain" "$AG/beta"        # link that only reaches the skill through another link
  run --uninstall
  expect "uninstall exits 1" [ "$RC" -eq 1 ]
  expect "link to another skill is kept" is_link_to "$CL/alpha" "$FIXREPO/skills/beta"
  expect "link to another skill reported as skip" reported skip alpha "$CL/alpha"
  expect "indirect link is kept" [ -L "$AG/beta" ]
  expect "indirect link reported as skip" reported skip beta "$AG/beta"
  expect "exact link in agents removed" absent "$AG/alpha"
  expect "exact link in claude removed" absent "$CL/beta"
  expect "the repo skills are intact" grep -qx '# beta' "$FIXREPO/skills/beta/SKILL.md"

  run --uninstall --dry-run
  expect "dry run keeps the skipped links" is_link_to "$CL/alpha" "$FIXREPO/skills/beta"
}

case_symlinked_parent_noted() {
  local real=$ELSEWHERE/dotfiles/claude
  mkdir -p "$real"
  ln -s "$real" "$HOME/.claude"
  run --agent claude
  expect "exit 0, not refused" [ "$RC" -eq 0 ]
  expect "one note line" [ "$(notes)" -eq 1 ]
  expect "note names the resolved destination" has "$OUT" "$(readlink -f -- "$real")/skills"
  expect "skill installed in the real directory" is_link_to "$real/skills/alpha" "$FIXREPO/skills/alpha"

  run --agent claude --dry-run
  expect "dry run notes too" [ "$(notes)" -eq 1 ]
  run --agent agents
  expect "a plain target prints no note" [ "$(notes)" -eq 0 ]

  ln -s "$ELSEWHERE" "$HOME/linked-parent"
  run --dir "$HOME/linked-parent/new/skills"
  expect "--dir through a symlinked parent exits 0" [ "$RC" -eq 0 ]
  expect "--dir note names the resolved destination" has "$OUT" "$(readlink -f -- "$ELSEWHERE")/new/skills"
  expect "--dir installed through the link" is_link_to "$ELSEWHERE/new/skills/beta" "$FIXREPO/skills/beta"
}

case_usage_and_empty_dir() {
  run --help
  expect "--help exits 0" [ "$RC" -eq 0 ]
  expect "usage lists exit 0" has "$OUT" "0 success"
  expect "usage lists exit 1" has "$OUT" "1 a skip caused by a conflict"
  expect "usage lists exit 2" has "$OUT" "2 usage error"
  expect "usage lists exit 3" has "$OUT" "3 safety refusal"

  run --dir ""
  expect "empty --dir exits 2" [ "$RC" -eq 2 ]
  expect "empty --dir does not install in claude" absent "$HOME/.claude"
  expect "empty --dir does not install in agents" absent "$HOME/.agents"
  run --dir "" --dry-run
  expect "empty --dir with --dry-run exits 2" [ "$RC" -eq 2 ]
  run alpha --dir ""
  expect "empty --dir after a name exits 2" [ "$RC" -eq 2 ]
  run --dir
  expect "--dir without a value exits 2" [ "$RC" -eq 2 ]
}

# Runner -----------------------------------------------------------------------

# run_sandboxed <case>: runs one case in a subshell with its own HOME.
run_sandboxed() {
  (
    HOME=$(mktemp -d "$TEMP_ROOT/install-test.XXXXXX")
    trap 'rm -rf -- "$HOME"' EXIT
    export HOME
    FAILS=0
    make_fixture
    "$1"
    ((FAILS == 0))
  )
}

CASES=(
  case_default_install
  case_second_run_idempotent
  case_named_skill_and_unknown_name
  case_real_folder_left_alone
  case_symlinked_target_refused
  case_copy_and_uninstall
  case_uninstall_keeps_foreign_links
  case_dry_run_changes_nothing
  case_force_replaces_only_managed
  case_agent_filter
  case_invalid_skill_names_refused
  case_dir_inside_repo_refused
  case_uninstall_only_exact_links
  case_symlinked_parent_noted
  case_usage_and_empty_dir
)

passed=0
failed=0
number=0
for case_fn in "${CASES[@]}"; do
  number=$((number + 1))
  description=${case_fn#case_}
  description=${description//_/ }
  if out=$(run_sandboxed "$case_fn" 2>&1); then
    passed=$((passed + 1))
    printf 'PASS %2d %s\n' "$number" "$description"
  else
    failed=$((failed + 1))
    printf 'FAIL %2d %s\n%s\n' "$number" "$description" "$out"
  fi
done

printf '%d passed, %d failed\n' "$passed" "$failed"
((failed == 0))
