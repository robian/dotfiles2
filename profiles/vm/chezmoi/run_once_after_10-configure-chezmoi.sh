#!/usr/bin/env sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

source_dir=${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}
repo="$(git -C "$source_dir" rev-parse --show-toplevel)"
remote="origin"
push_url=${REPO_SSH_URL:-$(git -C "$repo" remote get-url --push "$remote")}

step "Configuring chezmoi"

git -C "$repo" remote set-url --push "$remote" "$push_url"

mkdir -p "$HOME/.local/share/zsh/site-functions"
chezmoi completion zsh >"$HOME/.local/share/zsh/site-functions/_chezmoi"
