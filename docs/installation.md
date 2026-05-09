# Installation

OSSGuard can be installed six different ways. All methods provide the same `ossguard` CLI with 27 commands.

## pip

**Requires**: Python 3.9+

```bash
pip install ossguard
```

Or with [pipx](https://pipx.pypa.io/) for an isolated install:

```bash
pipx install ossguard
```

**Verify**:

```bash
ossguard version
```

**Upgrade**:

```bash
pip install --upgrade ossguard
```

**Source**: [ossguard-python](https://github.com/kirankotari/ossguard-python)

## Homebrew

**Requires**: macOS or Linux with Homebrew

```bash
brew install kirankotari/tap/ossguard
```

This installs a native Go binary — no Python or Node.js required.

**Verify**:

```bash
ossguard version
```

**Upgrade**:

```bash
brew upgrade ossguard
```

**Source**: [ossguard-go](https://github.com/kirankotari/ossguard-go)

## npm / npx

**Requires**: Node.js 18+

### Zero-install (npx)

```bash
npx ossguard scan .
npx ossguard audit .
```

No installation needed — npx downloads and runs the latest version.

### Global install

```bash
npm install -g ossguard
ossguard scan .
```

**Verify**:

```bash
npx ossguard version
```

**Source**: [ossguard-npm](https://github.com/kirankotari/ossguard-npm)

## Go

**Requires**: Go 1.22+

```bash
go install github.com/kirankotari/ossguard-go/cmd/ossguard@latest
```

The binary is placed in `$(go env GOPATH)/bin/`. Ensure this directory is in your `PATH`.

**Verify**:

```bash
ossguard version
```

**Source**: [ossguard-go](https://github.com/kirankotari/ossguard-go)

## Binary Download

Pre-built static binaries for Linux, macOS, and Windows are available on the [releases page](https://github.com/kirankotari/ossguard-go/releases).

### macOS (Apple Silicon)

```bash
curl -fsSL https://github.com/kirankotari/ossguard-go/releases/download/v0.1.2/ossguard-macos-arm64 -o ossguard
chmod +x ossguard
sudo mv ossguard /usr/local/bin/
```

### macOS (Intel)

```bash
curl -fsSL https://github.com/kirankotari/ossguard-go/releases/download/v0.1.2/ossguard-macos-amd64 -o ossguard
chmod +x ossguard
sudo mv ossguard /usr/local/bin/
```

### Linux (x86_64)

```bash
curl -fsSL https://github.com/kirankotari/ossguard-go/releases/download/v0.1.2/ossguard-linux-amd64 -o ossguard
chmod +x ossguard
sudo mv ossguard /usr/local/bin/
```

### Linux (ARM64)

```bash
curl -fsSL https://github.com/kirankotari/ossguard-go/releases/download/v0.1.2/ossguard-linux-arm64 -o ossguard
chmod +x ossguard
sudo mv ossguard /usr/local/bin/
```

**Verify**:

```bash
ossguard version
```

## Docker

```bash
# Scan the current directory
docker run --rm -v "$(pwd):/project" ghcr.io/kirankotari/ossguard-go:0.1.2 scan /project

# Full audit
docker run --rm -v "$(pwd):/project" ghcr.io/kirankotari/ossguard-go:0.1.2 audit /project

# Bootstrap configs
docker run --rm -v "$(pwd):/project" ghcr.io/kirankotari/ossguard-go:0.1.2 init /project
```

**Tip**: Create a shell alias for convenience:

```bash
alias ossguard='docker run --rm -v "$(pwd):/project" ghcr.io/kirankotari/ossguard-go:0.1.2'
ossguard scan /project
```

## Shell Completions

### Bash

```bash
ossguard completion bash > /etc/bash_completion.d/ossguard
```

### Zsh

```bash
ossguard completion zsh > "${fpath[1]}/_ossguard"
```

### Fish

```bash
ossguard completion fish > ~/.config/fish/completions/ossguard.fish
```

> Shell completions are available in the Go and Python implementations.

## Choosing an Implementation

| If you... | Use |
|-----------|-----|
| Want the richest terminal UI | `pip install ossguard` (Python) |
| Need a single binary for CI | `brew install kirankotari/tap/ossguard` (Go) |
| Work primarily with Node.js | `npx ossguard` (npm) |
| Need Docker-based scanning | `docker run ghcr.io/kirankotari/ossguard-go` |

All implementations share the same 27 commands and produce identical results. See [implementations.md](implementations.md) for a detailed comparison.
