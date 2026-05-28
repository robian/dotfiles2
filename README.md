# Development Environment

This repository contains host-side tooling and guest-side dotfiles for creating
isolated per-project development VMs on macOS with Lima.

The main command is `project-vm`. From any project directory, it creates a
project-specific Lima VM, stores that VM's writable workspace in a
project-specific Lima disk, and exposes the workspace in the guest at
`/home/dev/workspace`. The host project directory is not mounted directly into
the VM.

## Layout

- `bin/project-vm`: user-facing VM management command
- `tools/project-vm/lima.yaml`: Lima instance template
- `tools/project-vm/setup.sh`: root setup script run inside the VM
- `profiles/vm/bootstrap.sh`: guest bootstrap entry point for the `dev` user
- `profiles/vm/chezmoi/`: chezmoi source for guest dotfiles and tool installers
- `lib/repo-config.sh`: shared repository metadata used by setup scripts

## Quick Start

Put `bin/` on your host `PATH`, then run `project-vm` from the project you want
to work on:

```sh
cd /path/to/project
project-vm start
project-vm shell
```

`project-vm start` creates the project workspace disk if needed, creates
the Lima instance if needed, starts the VM, and runs the guest setup when the VM
has not been set up yet.

`project-vm shell` opens a login shell in `/home/dev` inside the VM. The
project workspace remains mounted at `/home/dev/workspace`.
For command mode, pass the command after `--`:

```sh
project-vm shell -- pnpm test
```

## Commands

```sh
project-vm start [--skip-setup]
project-vm setup
project-vm shell [--ssh-agent] [--env-file FILE] [--secret-env-file FILE] [-- COMMAND...]
project-vm secret-env edit FILE
project-vm status
project-vm stop
project-vm delete-vm
project-vm limactl ARGS...
```

`setup` reruns the guest setup script. It installs base packages, installs or
updates chezmoi for `dev`, and applies the VM profile.

`status` shows the host project root, VM instance name, workspace disk,
workspace mount, setup state, and Lima status.

`stop` stops the VM.

`delete-vm` removes only the Lima VM instance. It preserves the project
workspace disk. Manage workspace disks directly with `limactl disk`.

`limactl` passes arguments through to `limactl` after resolving the project VM
context.

## Shell Features

SSH agent forwarding is disabled in the VM by default. Enable it for one shell
session or command with `--ssh-agent`:

```sh
project-vm shell --ssh-agent
project-vm shell --ssh-agent -- git push
```

Plaintext env files can be loaded for one VM shell session or command:

```sh
project-vm shell --env-file .env
project-vm shell --env-file .env -- pnpm test
```

Secret env files are rage-encrypted dotenv-style files. They are decrypted on
the host with the age identity stored in the 1Password document named
`project-vm-age-identity`:

```sh
project-vm shell --secret-env-file .env.age
project-vm shell --env-file .env --secret-env-file .env.age -- pnpm test
```

`--env-file` and `--secret-env-file` may be passed multiple times. Files are
applied in argument order, so later files override earlier values. Supported env
syntax is intentionally conservative: blank lines, comments, `KEY=value`,
`KEY="value"`, `KEY='value'`, and `export KEY=value`.

Create or edit a secret env file with:

```sh
project-vm secret-env edit .env.age
```

If the file exists, it is decrypted to a temporary plaintext file, opened in
`$EDITOR`, validated, and re-encrypted. If the file does not exist, the command
starts from a small template and writes a new encrypted file. Temporary
plaintext files are removed when the command exits.

## Guest Environment

The VM setup creates and configures the `dev` user, installs base development
packages, and applies the chezmoi profile from
`profiles/vm/chezmoi`.

The profile currently manages:

- zsh and Oh My Zsh configuration
- git configuration
- LazyVim-based Neovim configuration
- Rust via rustup
- nvm and the pinned Node.js version
- pyenv
- Neovim
- Tree-sitter CLI
- Codex CLI
- `vm-versions`, a helper for checking pinned and installed tool versions

Pinned VM tool versions live in
`profiles/vm/chezmoi/.chezmoidata/vm_versions.toml`. The installers are
chezmoi `run_onchange` scripts, so changing a pin changes the rendered script
and causes chezmoi to run that installer on the next apply.

Inside the VM, use:

```sh
vm-versions
vm-versions --offline
```

`vm-versions` shows upstream, pinned, installed, and stale status. Use
`--offline` to skip upstream checks.

## Defaults

- one VM instance per host project directory
- project-specific Lima workspace disk named after the VM instance
- workspace mounted in the guest at `/home/dev/workspace`
- no direct mount of the host source directory
- dotfiles checkout inside the guest at `/home/dev/.local/share/dotfiles2`
- SSH agent forwarding disabled unless `--ssh-agent` is passed
- public internet egress allowed
- no networked package installation during VM boot

## Requirements

On the host:

- macOS
- Lima, providing `limactl`
- `ssh`
- 1Password CLI `op`, only for secret env files
- `rage`, only for secret env files

The guest setup installs the Linux-side packages it needs during
`project-vm setup`.
