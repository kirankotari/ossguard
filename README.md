# OSSGuard

**One CLI to guard any OSS project with OpenSSF security best practices — bootstrap, scan, and monitor.**

[![PyPI](https://img.shields.io/pypi/v/ossguard)](https://pypi.org/project/ossguard/)
[![npm](https://img.shields.io/npm/v/ossguard)](https://www.npmjs.com/package/ossguard)
[![Go](https://img.shields.io/github/v/release/kirankotari/ossguard-go)](https://github.com/kirankotari/ossguard-go/releases)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

OSSGuard scans any project and tells you exactly what OpenSSF security components are missing — then fixes them. It works with Python, JavaScript, Go, Rust, Java, and more.

## Quick Start

```bash
# Pick your install method
pip install ossguard        # Python
brew install kirankotari/tap/ossguard  # macOS / Linux
npx ossguard                # Node.js (zero install)

# Scan any project
ossguard scan .

# Full security audit
ossguard audit .

# Fix everything automatically
ossguard init .
```

## Install

### pip (Python 3.9+)

```bash
pip install ossguard
```

### Homebrew (macOS / Linux)

```bash
brew install kirankotari/tap/ossguard
```

### npm / npx (Node.js 18+)

```bash
npx ossguard --help          # zero install
npm install -g ossguard       # global install
```

### Go

```bash
go install github.com/kirankotari/ossguard-go/cmd/ossguard@latest
```

### Binary download

Pre-built binaries for Linux, macOS, and Windows are available on the [releases page](https://github.com/kirankotari/ossguard-go/releases).

```bash
# macOS ARM
curl -fsSL https://github.com/kirankotari/ossguard-go/releases/download/v0.1.1/ossguard-macos-arm64 -o ossguard
chmod +x ossguard
./ossguard scan .
```

### Docker

```bash
docker run --rm -v $(pwd):/project ghcr.io/kirankotari/ossguard-go:0.1.1 scan /project
```

## Commands

OSSGuard ships with **27 commands** grouped into four categories.

### Core

#### `scan` — Quick security posture check

```
$ ossguard scan .
Project: requests
Language: python
  ✓ SECURITY.md
  ✗ Scorecard
  ✓ Dependabot
  ✓ CodeQL
  ✗ SBOM workflow
  ✗ Sigstore
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

#### `audit` — Comprehensive security audit

```
$ ossguard audit .
Audit: transformers — Grade: C (1/6 config checks)
  ⚠ Missing Scorecard workflow
  ⚠ Missing Dependabot
  ⚠ Missing CodeQL
  ⚠ Missing SBOM workflow
  ⚠ Missing Sigstore
  ⚠ No dependencies detected — skipping dependency analysis
  → Run `ossguard init` to add Scorecard CI
  → Run `ossguard init` to add Dependabot config
  → Run `ossguard init` to add CodeQL workflow
  → Run `ossguard init` to add SBOM workflow
  → Run `ossguard init` to add Sigstore signing
```

> *Real output from [huggingface/transformers](https://github.com/huggingface/transformers)*

#### `init` — Bootstrap security configs

Generates SECURITY.md, Scorecard CI, Dependabot, CodeQL, SBOM, and Sigstore configs for your project.

```
$ ossguard init .
  ✓ Created SECURITY.md
  ✓ Created .github/workflows/scorecard.yml
  ✓ Created .github/dependabot.yml
  ✓ Created .github/workflows/codeql.yml
  ✓ Created .github/workflows/sbom.yml
  ✓ Created .github/workflows/sigstore.yml

Applied 6 actions.
```

#### `version` — Show version

```
$ ossguard version
ossguard 0.1.1
```

### Security Analysis

#### `secrets` — Scan for leaked credentials

```
$ ossguard secrets .
Secrets scan: 123 files, 13 findings
  src/requests/adapters.py:284 [medium] generic-secret
  src/requests/auth.py:62 [medium] generic-secret
  tests/certs/expired/ca/ca-private.key:1 [critical] private-key
  tests/certs/valid/server/server.key:1 [critical] private-key
  tests/test_utils.py:445 [medium] generic-secret
```

> *Real output from [psf/requests](https://github.com/psf/requests) — test certificates flagged as expected*

#### `baseline` — OSPS Security Baseline compliance (Levels 1-3)

```
$ ossguard baseline .
Baseline Level 1 — L1: 100%, L2: 62%, L3: 0%
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

#### `slsa` — SLSA build provenance assessment

```
$ ossguard slsa .
SLSA Build Level 1 — 6/12 met
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

#### `badge` — OpenSSF Best Practices Badge readiness

```
$ ossguard badge .
Badge: silver (80% — 8/10)
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

#### `maturity` — S2C2F maturity assessment

```
$ ossguard maturity .
S2C2F Level 0 — L1: 80%, L2: 33%, L3: 17%, L4: 0%
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

#### `container` — Dockerfile security linting

```
$ ossguard container .
Container scan: 0 files, 0 findings (C:0 H:0 M:0 L:0)
```

#### `fuzz` — Fuzzing readiness check

```
$ ossguard fuzz .
Fuzz: python, framework: none, score: 0/100
  No fuzzing detected — see recommendations:
  [setup] No fuzz test directory found
  [setup] No fuzz test files found
```

### Dependency Management

#### `deps` — Dependency health analysis

Queries OSV and deps.dev APIs for vulnerability data, risk scores, and license info.

#### `drift` — SBOM drift detection

Diff two SBOMs and show dependency drift with risk assessment.

#### `watch` — Vulnerability monitoring

Monitor dependencies for new vulnerabilities (post-deployment watch).

#### `reach` — Reachability-filtered vulnerabilities

Filter vulnerabilities by runtime reachability (static import analysis).

#### `update` — Security-prioritized updates

Show available dependency updates prioritized by security impact.

#### `license` — License compliance checking

Check dependency license compliance and detect conflicts.

#### `supply-chain` — Malicious package detection

Check dependencies for supply-chain risks (malicious packages, typosquatting).

#### `tpn` — Third-party notices

Generate third-party notices from project dependencies.

### Compliance & CI

#### `policy` — Organization security policy enforcement

Check project against org-wide security policies.

#### `ci` — Unified security CI pipeline

Generate a single CI workflow with all security checks.

#### `report` — Compliance reports (HTML/JSON)

Export comprehensive security compliance reports.

#### `insights` — SECURITY-INSIGHTS.yml management

Generate or validate a SECURITY-INSIGHTS.yml file.

#### `pin` — Pin GitHub Actions to SHAs

Pin GitHub Actions to commit SHAs for supply-chain safety.

#### `fix` — Auto-remediate security issues

Bump vulnerable deps, add missing configs automatically.

#### `sbom-gen` — Generate SBOMs

Generate SPDX or CycloneDX SBOMs from dependency manifests.

#### `compare` — Compare two projects

Compare security posture of two projects side by side.

## JSON Output

Every command supports `--json` / `-j` for CI/automation:

```
$ ossguard scan --json .
{
  "repo_name": "requests",
  "primary_language": "python",
  "package_managers": ["pip"],
  "has_github_actions": true,
  "has_security_md": true,
  "has_scorecard": false,
  "has_dependabot": true,
  "has_codeql": true,
  "has_sbom_workflow": false,
  "has_sigstore": false
}
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

## Real-World Results

Scan results from popular open-source projects (May 2025):

| Project | Grade | Config | Baseline | Badge | Secrets |
|---------|-------|--------|----------|-------|---------|
| [psf/requests](https://github.com/psf/requests) | **B** | 3/6 | Level 1 | Silver (80%) | 13 findings |
| [huggingface/transformers](https://github.com/huggingface/transformers) | **C** | 1/6 | Level 0 | In Progress (70%) | 1 finding |
| [scikit-learn/scikit-learn](https://github.com/scikit-learn/scikit-learn) | **B** | 3/6 | Level 0 | In Progress (70%) | — |
| [langchain-ai/langchain](https://github.com/langchain-ai/langchain) | **C** | 1/6 | Level 0 | — | 23 findings |
| [fastapi/fastapi](https://github.com/fastapi/fastapi) | **B** | 2/6 | Level 0 | — | 400+ findings |

## Implementations

OSSGuard is available in three implementations with identical command sets:

| | Python | Go | Node.js |
|---|---|---|---|
| **Repo** | [ossguard-python](https://github.com/kirankotari/ossguard-python) | [ossguard-go](https://github.com/kirankotari/ossguard-go) | [ossguard-npm](https://github.com/kirankotari/ossguard-npm) |
| **Install** | `pip install ossguard` | `brew install kirankotari/tap/ossguard` | `npx ossguard` |
| **Binary size** | ~104 KB (wheel) | ~8.6 MB | ~128 KB (tarball) |
| **UI** | Rich tables, colored panels | Plain text, CI-friendly | Plain text |
| **Best for** | Developer workstation | CI pipelines, automation | Node.js projects |
| **Commands** | 27 | 27 | 27 |

## Contributing

Contributions are welcome! Please see the implementation repos for language-specific contribution guides:

- [ossguard-python](https://github.com/kirankotari/ossguard-python) — Python (reference implementation)
- [ossguard-go](https://github.com/kirankotari/ossguard-go) — Go
- [ossguard-npm](https://github.com/kirankotari/ossguard-npm) — Node.js

## License

Apache-2.0 — see [LICENSE](LICENSE) for details.
