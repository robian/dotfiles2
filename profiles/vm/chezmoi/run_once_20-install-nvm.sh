#!/usr/bin/env sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

nvm_dir="${NVM_DIR:-$HOME/.nvm}"
nvm_version="v0.40.4"

if [ -s "$nvm_dir/nvm.sh" ]; then
  exit 0
fi

step "Installing nvm $nvm_version"

log="$(mktemp)"
if ! git -c advice.detachedHead=false clone \
  --quiet \
  --branch "$nvm_version" \
  --depth 1 \
  https://github.com/nvm-sh/nvm.git \
  "$nvm_dir" >"$log" 2>&1; then
  cat "$log" >&2
  rm -f "$log"
  exit 1
fi
rm -f "$log"
