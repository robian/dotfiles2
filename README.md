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

The VM setup command clones this repository into the checkout path derived from
`lib/repo-config.sh` and runs `profiles/vm/bootstrap.sh`.
