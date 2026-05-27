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
```

`start` creates and starts the VM if needed. It runs setup once unless
`--skip-setup` is passed. `setup` runs
[setup.sh](setup.sh) with root
privileges inside the VM. The script installs base packages, installs chezmoi
for `dev`, and applies the VM dotfiles as `dev`.

`delete-vm` removes only the Lima VM instance. It leaves
`project-vm-workspace.dmg` intact.

## Defaults

- no host source directory mount
- SSH agent forwarding disabled
- public internet egress allowed
- no networked package installation during VM boot
