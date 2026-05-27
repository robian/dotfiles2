#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
. "$REPO_ROOT/lib/repo-config.sh"

DOTFILES_SOURCE=${DOTFILES_SOURCE:-$SCRIPT_DIR/chezmoi}
export REPO_OWNER REPO_NAME REPO_SLUG REPO_HTTPS_URL REPO_SSH_URL REPO_CHECKOUT

if [ "$(id -u)" -eq 0 ]; then
  echo "bootstrap.sh must not run as root" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

chezmoi \
  --source "$DOTFILES_SOURCE" \
  --override-data "{\"repo\":{\"name\":\"$REPO_NAME\"}}" \
  apply
