#!/bin/sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

if [ -s "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  exit 0
fi

step "Installing Oh My Zsh"

log="$(mktemp)"
if ! RUNZSH=no \
  CHSH=no \
  KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc >"$log" 2>&1; then
  cat "$log" >&2
  rm -f "$log"
  exit 1
fi
rm -f "$log"
