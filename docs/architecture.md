# Architecture

This document describes how OSSGuard works internally. The architecture is shared across all three implementations (Python, Go, Node.js) with language-idiomatic differences.

## High-Level Design

```
┌─────────────────────────────────────────────────────┐
│                    CLI Layer                         │
│  (typer/cobra/commander — parses commands & flags)   │
├─────────────────────────────────────────────────────┤
│                  Detector Layer                      │
│  (auto-detects language, package manager, framework) │
├─────────────────────────────────────────────────────┤
│                 Analyzer Layer                       │
│  (24 independent analyzers — one per command)        │
├──────────────┬──────────────┬───────────────────────┤
│  Generators  │   Parsers    │     API Clients       │
│  (config     │   (deps,     │   (OSV, deps.dev)     │
│   files)     │    SBOMs)    │                       │
└──────────────┴──────────────┴───────────────────────┘
```

## Components

### CLI Layer

The entry point parses commands and flags, resolves the project path, and dispatches to the appropriate analyzer.

| Implementation | Framework | Source |
|---------------|-----------|--------|
| Python | [Typer](https://typer.tiangolo.com/) + [Rich](https://rich.readthedocs.io/) | [ossguard-python/src/ossguard/cli.py](https://github.com/kirankotari/ossguard-python/blob/main/src/ossguard/cli.py) |
| Go | [Cobra](https://cobra.dev/) | [ossguard-go/cmd/ossguard/main.go](https://github.com/kirankotari/ossguard-go/blob/main/cmd/ossguard/main.go) |
| Node.js | [Commander.js](https://github.com/tj/commander.js/) | [ossguard-npm/src/cli.ts](https://github.com/kirankotari/ossguard-npm/blob/main/src/cli.ts) |

### Detector

Automatically identifies:

- **Primary language**: Python, JavaScript/TypeScript, Go, Rust, Java, C/C++, Ruby, PHP, C#
- **Package managers**: npm, yarn, pnpm, pip, poetry, cargo, go modules, maven, gradle
- **Frameworks**: React, Vue, Angular, Next.js, Django, Flask, FastAPI, Express
- **Existing security setup**: SECURITY.md, Scorecard, Dependabot, CodeQL, SBOM, Sigstore

Detection is purely file-based — OSSGuard reads the file tree to identify manifest files, configuration files, and workflow files.

### Analyzers

Each of the 24 analyzers is an independent module that:

1. Receives a project path
2. Reads relevant files from the project
3. Performs its analysis (file inspection, pattern matching, or API calls)
4. Returns a structured report

Analyzers are stateless and can run independently or in combination (e.g., `audit` runs multiple analyzers).

| Category | Analyzers |
|----------|-----------|
| **Security config** | scan, audit |
| **Secrets** | secrets (24 regex rules) |
| **Compliance** | baseline (34 controls), slsa (12 requirements), badge, maturity (22 practices) |
| **Dependencies** | deps, drift, watch, reach, update, license, supply-chain, tpn |
| **Container** | container (12 Dockerfile rules) |
| **Generation** | init, ci, report, insights, pin, fix, sbom-gen, fuzz |
| **Comparison** | compare |

### Generators

Generators produce configuration files from templates:

| Generator | Output |
|-----------|--------|
| security-md | `SECURITY.md` |
| scorecard | `.github/workflows/scorecard.yml` |
| dependabot | `.github/dependabot.yml` |
| codeql | `.github/workflows/codeql.yml` |
| sbom | `.github/workflows/sbom.yml` |
| sigstore | `.github/workflows/sigstore.yml` |
| branch-protection | `.github/BRANCH_PROTECTION.md` |

Templates are language-aware — for example, the CodeQL workflow configures the correct language matrix.

### Parsers

Parse dependency manifests and SBOMs:

- **Dependency parsers**: `requirements.txt`, `setup.py`, `pyproject.toml`, `package.json`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`
- **SBOM parsers**: SPDX 2.3, CycloneDX 1.5

### API Clients

External API integrations (used by `deps`, `watch`, `reach`, `update`):

| API | Purpose |
|-----|---------|
| [OSV](https://osv.dev/) | Vulnerability data for open source packages |
| [deps.dev](https://deps.dev/) | Dependency metadata, risk scores, version info |

API calls are optional — commands that require network access degrade gracefully when offline.

## Data Flow

```
User runs: ossguard audit .
                │
                ▼
         ┌──────────┐
         │ CLI Layer │  Parse command, resolve path
         └────┬─────┘
              │
              ▼
         ┌──────────┐
         │ Detector  │  Identify: python, pip, flask
         └────┬─────┘
              │
              ▼
    ┌─────────────────────┐
    │   Audit Analyzer    │
    │  ┌───────────────┐  │
    │  │ Scan Analyzer  │  │  Check configs
    │  ├───────────────┤  │
    │  │ Deps Analyzer  │  │  Check vulnerabilities
    │  ├───────────────┤  │
    │  │ Reach Analyzer │  │  Filter by reachability
    │  └───────────────┘  │
    └─────────┬───────────┘
              │
              ▼
         ┌──────────┐
         │  Output   │  Rich tables (Python) or plain text (Go/Node)
         └──────────┘
```

## Project Structure

### Python (reference implementation)

```
ossguard-python/
├── src/ossguard/
│   ├── cli.py              # Typer CLI entry point
│   ├── detector.py         # Project detection
│   ├── analyzers/          # 24 analyzer modules
│   │   ├── audit.py
│   │   ├── baseline.py
│   │   ├── secrets.py
│   │   └── ...
│   ├── generators/         # Config file generators
│   │   ├── security_md.py
│   │   ├── scorecard.py
│   │   └── ...
│   ├── parsers/            # Dependency and SBOM parsers
│   │   ├── dependencies.py
│   │   └── sbom.py
│   └── apis/               # External API clients
│       ├── osv.py
│       └── deps_dev.py
└── tests/                  # 147 tests
```

### Go

```
ossguard-go/
├── cmd/ossguard/
│   └── main.go             # Cobra CLI (all commands in one file)
├── go.mod
└── go.sum
```

### Node.js

```
ossguard-npm/
├── src/
│   ├── cli.ts              # Commander.js CLI
│   ├── index.ts            # Public API exports
│   ├── detector.ts         # Project detection
│   ├── analyzers/          # 24 analyzer modules
│   ├── generators/         # Config file generators
│   ├── parsers/            # Dependency and SBOM parsers
│   ├── apis/               # External API clients
│   └── ui.ts               # Terminal output helpers
└── dist/                   # Compiled output
```

## Design Principles

1. **Zero configuration** — OSSGuard auto-detects everything about the project
2. **Read-only by default** — only `init`, `fix`, and `pin --apply` write files
3. **Offline-capable** — all commands work offline except dependency analysis (`deps`, `watch`, `reach`, `update`)
4. **No overwrites** — generators never replace existing files
5. **Consistent output** — all three implementations produce the same analysis results
6. **JSON-first for CI** — every command supports `--json` for machine consumption
