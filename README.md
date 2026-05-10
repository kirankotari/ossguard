<p align="center">
  <strong>OSSGuard</strong><br>
  <em>One CLI to guard any OSS project with OpenSSF security best practices</em>
</p>

<p align="center">
  <a href="https://pypi.org/project/ossguard/"><img src="https://img.shields.io/pypi/v/ossguard?cacheSeconds=300" alt="PyPI"></a>
  <a href="https://www.npmjs.com/package/ossguard"><img src="https://img.shields.io/npm/v/ossguard" alt="npm"></a>
  <a href="https://pkg.go.dev/github.com/kirankotari/ossguard-go"><img src="https://img.shields.io/github/v/release/kirankotari/ossguard-go?label=go" alt="Go"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License"></a>
</p>

---

OSSGuard scans any project and tells you exactly what [OpenSSF](https://openssf.org/) security components are missing — then fixes them. It works with **Python, JavaScript, Go, Rust, Java, C/C++**, and more.

> OSSGuard is **not** a replacement for any OpenSSF project. It is a **unifier** that makes it trivially easy to adopt the tools and practices that OpenSSF working groups have built.

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Commands](#commands)
  - [Core](#core)
  - [Security Analysis](#security-analysis)
  - [Dependency Management](#dependency-management)
  - [Compliance & Generation](#compliance--generation)
- [Real-World Results](#real-world-results)
- [JSON Output for CI](#json-output-for-ci)
- [GitHub Action](#github-action)
- [Implementations](#implementations)
- [Documentation](#documentation)
- [How OSSGuard Relates to OpenSSF](#how-ossguard-relates-to-openssf)
- [Contributing](#contributing)
- [License](#license)

## Quick Start

```bash
# Install (pick one)
pip install ossguard                      # Python 3.9+
brew install kirankotari/tap/ossguard     # macOS / Linux
npx ossguard                              # Node.js (zero install)

# Scan any project
ossguard scan .

# Full security audit
ossguard audit .

# Bootstrap all OpenSSF configs
ossguard init .
```

See the [Getting Started](docs/getting-started.md) guide for a full walkthrough.

## Installation

| Method | Command | Docs |
|--------|---------|------|
| **pip** | `pip install ossguard` | [details](docs/installation.md#pip) |
| **Homebrew** | `brew install kirankotari/tap/ossguard` | [details](docs/installation.md#homebrew) |
| **npm / npx** | `npx ossguard` | [details](docs/installation.md#npm--npx) |
| **Go** | `go install github.com/kirankotari/ossguard-go/cmd/ossguard@latest` | [details](docs/installation.md#go) |
| **Binary** | Download from [releases](https://github.com/kirankotari/ossguard-go/releases) | [details](docs/installation.md#binary-download) |
| **Docker** | `docker run ghcr.io/kirankotari/ossguard-go:0.1.3` | [details](docs/installation.md#docker) |

See [docs/installation.md](docs/installation.md) for full instructions, shell completions, and verification steps.

## Commands

OSSGuard ships **27 commands** grouped into four categories. Every command accepts a project path as a positional argument and supports `--json` for machine-readable output.

### Core

| Command | Description |
|---------|-------------|
| [`init`](docs/commands/core.md#init) | Bootstrap SECURITY.md, Scorecard, Dependabot, CodeQL, SBOM, Sigstore configs |
| [`scan`](docs/commands/core.md#scan) | Read-only security posture check |
| [`audit`](docs/commands/core.md#audit) | Comprehensive security audit (config + deps + reachability) |
| [`version`](docs/commands/core.md#version) | Show version |

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

```
$ ossguard audit .
Audit: transformers — Grade: C (1/6 config checks)
  ⚠ Missing Scorecard workflow
  ⚠ Missing Dependabot
  ⚠ Missing CodeQL
  ⚠ Missing SBOM workflow
  ⚠ Missing Sigstore
  → Run `ossguard init` to fix
```
> *Real output from [huggingface/transformers](https://github.com/huggingface/transformers)*

### Security Analysis

| Command | Description |
|---------|-------------|
| [`secrets`](docs/commands/security.md#secrets) | Scan for leaked credentials (24 detection rules) |
| [`baseline`](docs/commands/security.md#baseline) | OSPS Security Baseline compliance (34 controls, Levels 1-3) |
| [`slsa`](docs/commands/security.md#slsa) | SLSA Build Level assessment (Levels 1-4, 12 requirements) |
| [`badge`](docs/commands/security.md#badge) | OpenSSF Best Practices Badge readiness |
| [`maturity`](docs/commands/security.md#maturity) | S2C2F supply chain maturity (22 practices, Levels 1-4) |
| [`container`](docs/commands/security.md#container) | Dockerfile security linting (12 rules) |
| [`fuzz`](docs/commands/security.md#fuzz) | Fuzzing readiness check + starter harness generation |

```
$ ossguard secrets .
Secrets scan: 123 files, 13 findings
  src/requests/adapters.py:284 [medium] generic-secret
  tests/certs/expired/ca/ca-private.key:1 [critical] private-key
  tests/certs/valid/server/server.key:1 [critical] private-key
```
> *Real output from [psf/requests](https://github.com/psf/requests) — test certificates flagged as expected*

```
$ ossguard baseline .
Baseline Level 1 — L1: 100%, L2: 62%, L3: 0%
```
> *Real output from [psf/requests](https://github.com/psf/requests)*

### Dependency Management

| Command | Description |
|---------|-------------|
| [`deps`](docs/commands/dependencies.md#deps) | Dependency health — vulns (OSV), risk scores (deps.dev) |
| [`drift`](docs/commands/dependencies.md#drift) | SBOM diff between releases |
| [`watch`](docs/commands/dependencies.md#watch) | Continuous vulnerability monitoring |
| [`reach`](docs/commands/dependencies.md#reach) | Reachability-filtered vulnerability analysis |
| [`update`](docs/commands/dependencies.md#update) | Security-prioritized dependency updates |
| [`license`](docs/commands/dependencies.md#license) | License compliance and conflict detection |
| [`supply-chain`](docs/commands/dependencies.md#supply-chain) | Malicious package + typosquatting detection |
| [`tpn`](docs/commands/dependencies.md#tpn) | Third-party notice generation |

### Compliance & Generation

| Command | Description |
|---------|-------------|
| [`policy`](docs/commands/compliance.md#policy) | Org-wide security policy enforcement |
| [`ci`](docs/commands/compliance.md#ci) | Generate unified CI security pipeline |
| [`report`](docs/commands/compliance.md#report) | Export HTML or JSON compliance report |
| [`insights`](docs/commands/compliance.md#insights) | Generate or validate SECURITY-INSIGHTS.yml |
| [`pin`](docs/commands/compliance.md#pin) | Pin GitHub Actions to commit SHAs |
| [`fix`](docs/commands/compliance.md#fix) | Auto-remediate common security issues |
| [`sbom-gen`](docs/commands/compliance.md#sbom-gen) | Generate SPDX 2.3 or CycloneDX 1.5 SBOMs |
| [`compare`](docs/commands/compliance.md#compare) | Compare security posture of two projects |

See [docs/commands/](docs/commands/) for detailed usage, flags, and output examples for every command.

## Real-World Results

Scan results from popular open-source projects (May 2025):

| Project | Grade | Config | Baseline | Badge | Secrets |
|---------|-------|--------|----------|-------|---------|
| [psf/requests](https://github.com/psf/requests) | **B** | 3/6 | Level 1 | Silver (80%) | 13 findings |
| [huggingface/transformers](https://github.com/huggingface/transformers) | **C** | 1/6 | Level 0 | In Progress (70%) | 1 finding |
| [scikit-learn/scikit-learn](https://github.com/scikit-learn/scikit-learn) | **B** | 3/6 | Level 0 | In Progress (70%) | — |
| [langchain-ai/langchain](https://github.com/langchain-ai/langchain) | **C** | 1/6 | Level 0 | — | 23 findings |
| [fastapi/fastapi](https://github.com/fastapi/fastapi) | **B** | 2/6 | Level 0 | — | 400+ findings |

## JSON Output for CI

Every command supports `--json` for CI/automation pipelines:

```json
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

See [docs/ci-integration.md](docs/ci-integration.md) for GitHub Actions, GitLab CI, and quality-gate examples.

## GitHub Action

OSSGuard also ships as a **GitHub Action** that automatically reviews every pull request for OpenSSF compliance and posts results directly on the PR.

Add `.github/workflows/ossguard.yml` to any repository:

```yaml
name: OSSGuard

on:
  pull_request:
    branches: [main]

permissions:
  contents: read
  pull-requests: write
  statuses: write

jobs:
  security-review:
    name: Security Review
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: kirankotari/ossguard-app@main
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### What You'll See on Your PR

OSSGuard posts a comment with a security review table and sets a commit status check:

> **OSSGuard Security Review**
>
> | Check | Status | Severity | Details |
> |-------|--------|----------|---------|
> | Dependency Pinning | :warning: Warn | Warning | 2 action(s) not pinned to SHA |
> | Security Policy | :white_check_mark: Pass | Warning | SECURITY.md found |
> | License | :white_check_mark: Pass | Warning | Apache-2.0 license detected |
> | Secrets Scan | :white_check_mark: Pass | Error | No secrets detected in PR diff |
> | CodeQL / SAST | :white_check_mark: Pass | Warning | CodeQL configured |
> | Branch Protection | :white_check_mark: Pass | Info | Branch protection enabled |
> | Dependency Review | :white_check_mark: Pass | Info | Dependabot configured |
>
> **6 passed** | **1 warning**

The status check shows:
- **Green** (success) — all checks passed
- **Yellow** (neutral) — warnings found, not blocking
- **Red** (failure) — critical issues (e.g., leaked secrets)

See [ossguard-app](https://github.com/kirankotari/ossguard-app) for configuration options and the full list of 8 analyzers.

## Implementations

OSSGuard is available in three language implementations with identical command sets:

| | Python | Go | Node.js |
|---|---|---|---|
| **Source** | [ossguard-python](https://github.com/kirankotari/ossguard-python) | [ossguard-go](https://github.com/kirankotari/ossguard-go) | [ossguard-npm](https://github.com/kirankotari/ossguard-npm) |
| **Install** | `pip install ossguard` | `brew install kirankotari/tap/ossguard` | `npx ossguard` |
| **Size** | ~104 KB (wheel) | ~8.6 MB (static binary) | ~128 KB (tarball) |
| **UI** | Rich tables, colored panels | Plain text, CI-friendly | Plain text |
| **Best for** | Developer workstation | CI pipelines, automation | Node.js projects |
| **Commands** | 27 | 27 | 27 |

See [docs/implementations.md](docs/implementations.md) for a detailed comparison.

## Documentation

| Document | Description |
|----------|-------------|
| [Getting Started](docs/getting-started.md) | First-time setup and walkthrough |
| [Installation](docs/installation.md) | All install methods with verification |
| [Command Reference](docs/commands/) | Detailed docs for all 27 commands |
| [Architecture](docs/architecture.md) | How OSSGuard works internally |
| [CI Integration](docs/ci-integration.md) | GitHub Actions, GitLab CI examples |
| [Implementations](docs/implementations.md) | Python vs Go vs Node.js comparison |
| [Releasing](docs/releasing.md) | Coordinated release process |
| [FAQ](docs/faq.md) | Frequently asked questions |

## How OSSGuard Relates to OpenSSF

OSSGuard makes it trivially easy to adopt the tools that [OpenSSF](https://openssf.org/) working groups have built:

| OpenSSF Initiative | OSSGuard Command |
|--------------------|------------------|
| [Scorecard](https://scorecard.dev/) | `scan`, `audit` |
| [SLSA](https://slsa.dev/) | `slsa` |
| [Sigstore](https://sigstore.dev/) | `init` (sigstore workflow) |
| [SBOM Everywhere](https://github.com/ossf/sbom-everywhere) | `sbom-gen`, `drift` |
| [Best Practices Badge](https://www.bestpractices.dev/) | `badge` |
| [OSPS Baseline](https://baseline.openssf.org/) | `baseline` |
| [S2C2F](https://github.com/ossf/s2c2f) | `maturity` |
| [CVD Guide](https://github.com/ossf/oss-vulnerability-guide) | `init` (SECURITY.md) |
| [SCM Best Practices](https://best.openssf.org/SCM-BestPractices/) | `pin`, `init` (branch protection) |

## Contributing

Contributions are welcome! Please see the [Contributing Guide](CONTRIBUTING.md) for general guidelines, or jump directly to a language implementation:

- [ossguard-python](https://github.com/kirankotari/ossguard-python) — Python (reference implementation)
- [ossguard-go](https://github.com/kirankotari/ossguard-go) — Go
- [ossguard-npm](https://github.com/kirankotari/ossguard-npm) — Node.js

For bugs and feature requests, please [open an issue](https://github.com/kirankotari/ossguard/issues).

## License

Apache-2.0 — see [LICENSE](LICENSE) for details.
