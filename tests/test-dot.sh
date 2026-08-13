#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

assert_fails() {
  if "$@" >/dev/null 2>&1; then
    printf 'Expected command to fail:' >&2
    printf ' %q' "$@" >&2
    printf '\n' >&2
    return 1
  fi
}

bash -n "$ROOT/dot"
"$ROOT/dot" list >/dev/null
"$ROOT/dot" requirements install --dry-run >/dev/null
"$ROOT/dot" tools install opencode --dry-run >/dev/null
"$ROOT/dot" dev install --all --dry-run >/dev/null
"$ROOT/dot" bootstrap dev --email test@example.com --dry-run >/dev/null

apt_output="$(DOT_OS=linux DOT_PACKAGE_MANAGER=apt-get "$ROOT/dot" requirements install --dry-run)"
grep -q 'apt-get update' <<< "$apt_output"
grep -q 'apt-get install -y stow ripgrep' <<< "$apt_output"

mac_output="$(DOT_OS=macos PATH=/usr/bin:/bin "$ROOT/dot" requirements install --dry-run)"
grep -q 'Homebrew/install' <<< "$mac_output"
grep -q 'brew install' <<< "$mac_output"

grep -q '\.opencode/bin' "$ROOT/zsh/.zshrc"

github_output="$(HOME="$TEST_ROOT/github-home" "$ROOT/dot" tools install github --email test@example.com --dry-run)"
grep -q 'Configure .*id_ed25519_github' <<< "$github_output"

assert_fails "$ROOT/dot" dev install unknown --dry-run
assert_fails "$ROOT/dot" project enable unknown --dry-run

mkdir -p "$TEST_ROOT/home" "$TEST_ROOT/project/bin"
HOME="$TEST_ROOT/home" "$ROOT/dot" install --profile minimal opencode
test -L "$TEST_ROOT/home/.zshrc"
test -e "$TEST_ROOT/home/.config/nvim/init.lua"
test -e "$TEST_ROOT/home/.config/opencode/opencode.json"
test ! -L "$TEST_ROOT/home/.config/opencode"
HOME="$TEST_ROOT/home" "$ROOT/dot" uninstall --profile minimal opencode
test ! -e "$TEST_ROOT/home/.zshrc"
test ! -e "$TEST_ROOT/home/.config/nvim/init.lua"
test ! -e "$TEST_ROOT/home/.config/opencode/opencode.json"

printf '#!/usr/bin/env sh\nexit 0\n' > "$TEST_ROOT/project/bin/gograph"
chmod +x "$TEST_ROOT/project/bin/gograph"
git init -q "$TEST_ROOT/project/repo"
(
  cd "$TEST_ROOT/project/repo"
  PATH="$TEST_ROOT/project/bin:$PATH" "$ROOT/dot" project enable gograph
  test -f opencode.json
  grep -q '"gograph"' opencode.json
)

mkdir -p "$TEST_ROOT/project/failing"
git init -q "$TEST_ROOT/project/failing"
printf '#!/usr/bin/env sh\nexit 1\n' > "$TEST_ROOT/project/bin/gograph"
assert_fails env PATH="$TEST_ROOT/project/bin:$PATH" bash -c "cd '$TEST_ROOT/project/failing' && '$ROOT/dot' project enable gograph"
test ! -e "$TEST_ROOT/project/failing/opencode.json"

printf 'All dot tests passed\n'
