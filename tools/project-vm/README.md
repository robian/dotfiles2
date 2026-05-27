# project-vm

Bootstrap tooling for the Lima-based isolated development environment described
in [PLAN.md](PLAN.md).

This is early scaffolding. It uses Lima's default instance directory, creates
one VM per project, and mounts a project-local DMG workspace at
`/home/dev/workspace`.

## Usage

```sh
cd /path/to/project
project-vm start
project-vm shell
```

Useful commands:

```sh
project-vm status
project-vm stop
project-vm delete-vm
project-vm limactl list
project-vm shell --ssh-agent
project-vm shell --ssh-agent -- git push
project-vm shell --env-file .env
project-vm shell --env-file .env --secret-env-file .env.age
project-vm secret-env edit .env.age
```

`start` creates and starts the VM if needed. It runs setup once unless
`--skip-setup` is passed. `setup` runs
[setup.sh](setup.sh) with root
privileges inside the VM. The script installs base packages, installs chezmoi
for `dev`, and applies the VM dotfiles as `dev`.

`shell --ssh-agent` enables host SSH agent forwarding for that shell session
only. The VM configuration keeps agent forwarding disabled by default.

`shell --env-file FILE` loads plaintext dotenv-style variables for that shell
session. `shell --secret-env-file FILE` decrypts a rage-encrypted env file with
the age identity stored in the 1Password document named
`project-vm-age-identity`. Both flags may be passed multiple times; later files
override earlier values.

`secret-env edit FILE` creates or edits a rage-encrypted env file. It decrypts
existing files to a temporary plaintext file, opens `$EDITOR`, validates the env
syntax, re-encrypts the result, and removes the temporary plaintext file.

`delete-vm` removes only the Lima VM instance. It leaves
`project-vm-workspace.dmg` intact.

## Tool versions

VM tool pins live in
`profiles/vm/chezmoi/.chezmoidata/vm_versions.toml`. The versioned chezmoi
installers are `run_onchange` templates, so changing one of those pins changes
the rendered script and causes chezmoi to run that installer again on the next
apply.

Inside the VM, use:

```sh
vm-versions
vm-versions --offline
```

`vm-versions` shows upstream, pinned, installed, and stale status in one table.
Use `--offline` for the fast view without upstream checks.

## Defaults

- no host source directory mount
- dotfiles checkout inside the guest at `/home/dev/.local/share/dotfiles2`
- SSH agent forwarding disabled
- public internet egress allowed
- no networked package installation during VM boot
