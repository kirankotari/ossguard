# Getting Started

This guide walks you through installing OSSGuard and running your first security scan in under two minutes.

## Prerequisites

You need one of the following:

- **Python 3.9+** — for `pip install`
- **macOS or Linux** — for Homebrew
- **Node.js 18+** — for `npx`
- **Go 1.22+** — for `go install`

No other dependencies are required.

## Step 1: Install

Pick whichever method matches your environment:

```bash
# Python
pip install ossguard

# macOS / Linux
brew install kirankotari/tap/ossguard

# Node.js (zero install)
npx ossguard --help
```

Verify the installation:

```bash
ossguard version
# ossguard 0.1.1
```

See [installation.md](installation.md) for all six install methods and shell completions.

## Step 2: Scan a Project

Navigate to any project directory and run:

```bash
ossguard scan .
```

Example output:

```
Project: my-project
Language: python
  ✓ SECURITY.md
  ✗ Scorecard
  ✗ Dependabot
  ✓ CodeQL
  ✗ SBOM workflow
  ✗ Sigstore
```

OSSGuard automatically detects the project language, package manager, and existing security configurations.

## Step 3: Run a Full Audit

```bash
ossguard audit .
```

The audit combines config checks, dependency analysis, and reachability filtering into a single grade (A–F) with actionable recommendations.

## Step 4: Fix Everything

```bash
ossguard init .
```

This bootstraps all missing OpenSSF security configurations:

| File Generated | Purpose |
|----------------|---------|
| `SECURITY.md` | Vulnerability disclosure policy |
| `.github/workflows/scorecard.yml` | Automated security scoring |
| `.github/dependabot.yml` | Dependency update automation |
| `.github/workflows/codeql.yml` | Code scanning |
| `.github/workflows/sbom.yml` | Software Bill of Materials |
| `.github/workflows/sigstore.yml` | Cryptographic signing |
| `.github/BRANCH_PROTECTION.md` | Branch protection guide |

OSSGuard **never overwrites** existing configurations — it only creates what is missing.

## Step 5: Go Deeper

Now that your project has the basics, explore the full command set:

```bash
# Check OSPS Baseline compliance
ossguard baseline .

# Scan for leaked secrets
ossguard secrets .

# Assess SLSA Build Level
ossguard slsa .

# Check OpenSSF Best Practices Badge readiness
ossguard badge .

# Analyze dependency health
ossguard deps .

# Generate an SBOM
ossguard sbom-gen .
```

## What's Next

- [Command Reference](commands/) — detailed docs for all 27 commands
- [CI Integration](ci-integration.md) — add OSSGuard to your CI pipeline
- [Architecture](architecture.md) — understand how OSSGuard works
- [FAQ](faq.md) — common questions
