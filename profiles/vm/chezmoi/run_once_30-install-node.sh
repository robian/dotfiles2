#!/usr/bin/env sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
node_version="v24.15.0"

. "$NVM_DIR/nvm.sh"

step "Installing Node $node_version"

log="$(mktemp)"
if ! {
  nvm install "$node_version" --no-progress
  nvm alias default "$node_version"
  command -v corepack
  corepack enable
} >"$log" 2>&1; then
  cat "$log" >&2
  rm -f "$log"
  exit 1
fi
rm -f "$log"
