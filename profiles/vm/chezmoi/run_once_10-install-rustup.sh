#!/usr/bin/env sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

if [ -x "$HOME/.cargo/bin/rustup" ]; then
  exit 0
fi

step "Installing rustup"

log="$(mktemp)"
if ! sh -c 'curl --proto '"'"'=https'"'"' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y' >"$log" 2>&1; then
  cat "$log" >&2
  rm -f "$log"
  exit 1
fi
rm -f "$log"
