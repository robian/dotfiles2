#!/usr/bin/env sh
set -eu

step() {
  printf '\033[1;36m==> %s\033[0m\n' "$*" >&2
}

nvim_version="v0.12.2"

case "$(uname -m)" in
  aarch64) arch=arm64 ;;
  x86_64) arch=x86_64 ;;
  *)
    echo "unsupported Neovim architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

if [ -x "$HOME/.local/opt/nvim/bin/nvim" ]; then
  exit 0
fi

step "Installing Neovim $nvim_version"

archive="$(mktemp)"
log="$(mktemp)"
if ! {
  curl -fsSL "https://github.com/neovim/neovim/releases/download/${nvim_version}/nvim-linux-${arch}.tar.gz" -o "$archive"

  rm -rf "$HOME/.local/opt/nvim"
  mkdir -p "$HOME/.local/opt/nvim" "$HOME/.local/bin"
  tar -C "$HOME/.local/opt/nvim" --strip-components=1 -xzf "$archive"
  ln -sf "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
} >"$log" 2>&1; then
  cat "$log" >&2
  rm -f "$archive" "$log"
  exit 1
fi

rm -f "$archive" "$log"
