#!/bin/sh
set -eu

DEV_USER=${DEV_USER:-dev}
: "${REPO_HTTPS_URL:?REPO_HTTPS_URL is required}"
: "${REPO_NAME:?REPO_NAME is required}"
REPO_CHECKOUT=${REPO_CHECKOUT:-/home/$DEV_USER/.local/share/$REPO_NAME}

log() {
  printf '[setup] %s\n' "$*"
}

if [ "$(id -u)" -ne 0 ]; then
  printf 'setup.sh must run as root\n' >&2
  exit 1
fi

if ! id "$DEV_USER" >/dev/null 2>&1; then
  printf 'development user does not exist: %s\n' "$DEV_USER" >&2
  exit 1
fi

PACKAGES="
curl
ca-certificates
git
fzf
zsh
ncurses-bin
build-essential
python3-venv
postgresql-client
ripgrep
unzip
fd-find
"

export DEBIAN_FRONTEND=noninteractive
apt-get update
# shellcheck disable=SC2086
apt-get install -y --no-install-recommends $PACKAGES

ZSH_PATH=$(command -v zsh)
if [ "$(getent passwd "$DEV_USER" | cut -d: -f7)" != "$ZSH_PATH" ]; then
  log "setting $DEV_USER shell to $ZSH_PATH"
  chsh -s "$ZSH_PATH" "$DEV_USER"
fi

log "running VM profile bootstrap as $DEV_USER"
exec su - "$DEV_USER" -c "
	set -eu
	if [ -d '$REPO_CHECKOUT/.git' ]; then
		git -C '$REPO_CHECKOUT' pull --ff-only
	else
		mkdir -p \"\$(dirname -- '$REPO_CHECKOUT')\"
		git clone '$REPO_HTTPS_URL' '$REPO_CHECKOUT'
	fi
	export REPO_NAME='$REPO_NAME'
	export REPO_HTTPS_URL='$REPO_HTTPS_URL'
	export REPO_SSH_URL='${REPO_SSH_URL:-}'
	export REPO_CHECKOUT='$REPO_CHECKOUT'
	exec '$REPO_CHECKOUT/profiles/vm/bootstrap.sh'
"
