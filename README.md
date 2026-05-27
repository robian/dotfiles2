# Development Environment

Host and VM development environment configuration.

## Layout

- `bin/`: user-facing commands to put on `PATH`
- `tools/project-vm/`: Lima-based per-project VM tooling
- `profiles/vm/`: VM bootstrap and chezmoi source

## Project VM

```sh
bin/project-vm start
```

The VM setup command clones this repository inside the guest at
`/home/dev/.local/share/dotfiles2` by default and runs
`profiles/vm/bootstrap.sh`.
