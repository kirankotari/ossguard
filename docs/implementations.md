# Implementations

OSSGuard is available in three language implementations. All share the same 27 commands and produce identical analysis results.

## Comparison

| Feature | Python | Go | Node.js |
|---------|--------|----|---------|
| **Source** | [ossguard-python](https://github.com/kirankotari/ossguard-python) | [ossguard-go](https://github.com/kirankotari/ossguard-go) | [ossguard-npm](https://github.com/kirankotari/ossguard-npm) |
| **Install** | `pip install ossguard` | `brew install kirankotari/tap/ossguard` | `npx ossguard` |
| **Runtime** | Python 3.9+ | None (static binary) | Node.js 18+ |
| **Package size** | ~104 KB (wheel) | ~8.6 MB (static binary) | ~128 KB (tarball) |
| **UI** | Rich tables, colored panels, progress bars | Plain text, CI-friendly | Plain text |
| **Commands** | 27 | 27 | 27 |
| **JSON output** | All commands | All commands (`--json`) | All commands |
| **Shell completions** | Yes (Typer) | Yes (Cobra) | No |
| **Tests** | 147 | — | — |
| **Status** | Reference implementation | Production ready | Production ready |

## When to Use Each

### Python (`pip install ossguard`)

**Best for**: Developer workstations, interactive use, rich terminal output.

- Richest terminal UI with Rich library (tables, panels, progress indicators)
- Interactive prompts (via questionary)
- Largest test suite (147 tests)
- Ideal for developers who want detailed, colorful output

### Go (`brew install kirankotari/tap/ossguard`)

**Best for**: CI pipelines, automation, Docker, air-gapped environments.

- Single static binary — no runtime dependencies
- Fastest startup time
- Smallest attack surface (no package manager runtime)
- Pre-built for Linux, macOS (Intel + ARM), and Windows
- Docker image available at `ghcr.io/kirankotari/ossguard-go`
- Available via Homebrew, Go install, or direct binary download

### Node.js (`npx ossguard`)

**Best for**: Node.js/JavaScript projects, zero-install scanning.

- Zero install via `npx` — just run `npx ossguard scan .`
- Native for teams already using Node.js tooling
- Published on npm with provenance
- Smallest download for existing Node.js environments

## Source Code

Each implementation is a fully independent repository with its own:

- CI/CD pipeline
- Release process
- Issue tracker
- Contributing guide

| Repository | Language | Key Files |
|-----------|----------|-----------|
| [ossguard-python](https://github.com/kirankotari/ossguard-python) | Python | `src/ossguard/cli.py`, `src/ossguard/analyzers/`, `src/ossguard/generators/` |
| [ossguard-go](https://github.com/kirankotari/ossguard-go) | Go | `cmd/ossguard/main.go` |
| [ossguard-npm](https://github.com/kirankotari/ossguard-npm) | TypeScript | `src/cli.ts`, `src/analyzers/`, `src/generators/` |

## Distribution Channels

| Channel | Implementation | Package |
|---------|---------------|---------|
| [PyPI](https://pypi.org/project/ossguard/) | Python | `ossguard` |
| [npm](https://www.npmjs.com/package/ossguard) | Node.js | `ossguard` |
| [Homebrew](https://github.com/kirankotari/homebrew-tap) | Go | `kirankotari/tap/ossguard` |
| [GitHub Releases](https://github.com/kirankotari/ossguard-go/releases) | Go | Binaries (Linux, macOS, Windows) |
| [GHCR](https://github.com/kirankotari/ossguard-go/pkgs/container/ossguard-go) | Go | `ghcr.io/kirankotari/ossguard-go` |
| [pkg.go.dev](https://pkg.go.dev/github.com/kirankotari/ossguard-go) | Go | `github.com/kirankotari/ossguard-go` |

## Versioning

All implementations follow [Semantic Versioning](https://semver.org/) and are released in coordination:

- Each implementation repo tags its own releases (e.g., `v0.1.1`)
- The main [ossguard](https://github.com/kirankotari/ossguard) repo tracks coordinated releases
- Patch versions may differ temporarily between implementations
- Minor and major versions are always aligned
