#!/usr/bin/env sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

pyenv_root="${PYENV_ROOT:-$HOME/.pyenv}"
pyenv_version="v2.6.31"

if [ -x "$pyenv_root/bin/pyenv" ]; then
  exit 0
fi

step "Installing pyenv $pyenv_version"

log="$(mktemp)"
if ! git -c advice.detachedHead=false clone \
  --quiet \
  --branch "$pyenv_version" \
  --depth 1 \
  https://github.com/pyenv/pyenv.git \
  "$pyenv_root" >"$log" 2>&1; then
  cat "$log" >&2
  rm -f "$log"
  exit 1
fi
rm -f "$log"
