# Core Commands

## init

Bootstrap all OpenSSF security configurations for a project.

**Usage**:

```bash
ossguard init <path>
ossguard init .
```

**What it generates**:

| File | Purpose | OpenSSF Reference |
|------|---------|-------------------|
| `SECURITY.md` | Vulnerability disclosure policy | [CVD Guide](https://github.com/ossf/oss-vulnerability-guide) |
| `.github/workflows/scorecard.yml` | Automated security scoring | [Scorecard](https://scorecard.dev/) |
| `.github/dependabot.yml` | Dependency update automation | [Best Practices](https://best.openssf.org/) |
| `.github/workflows/codeql.yml` | Code scanning for vulnerabilities | [Security Tooling WG](https://github.com/ossf/wg-security-tooling) |
| `.github/workflows/sbom.yml` | Software Bill of Materials generation | [SBOM Everywhere](https://github.com/ossf/sbom-everywhere) |
| `.github/workflows/sigstore.yml` | Cryptographic signing of releases | [Sigstore](https://sigstore.dev/) |
| `.github/BRANCH_PROTECTION.md` | Branch protection setup guide | [SCM Best Practices](https://best.openssf.org/SCM-BestPractices/) |

**Behavior**:

- Auto-detects the project language and package manager
- **Never overwrites** existing configurations
- Only creates files that are missing
- Tailors workflow configurations to the detected language

**Example**:

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

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## scan

Read-only security posture check. Detects what OpenSSF security components are present or missing.

**Usage**:

```bash
ossguard scan <path>
ossguard scan .
ossguard scan /path/to/project
```

**What it checks**:

- SECURITY.md presence
- Scorecard workflow
- Dependabot configuration
- CodeQL workflow
- SBOM workflow
- Sigstore signing workflow

**Example**:

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

**JSON output**:

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

**Flags**:

| Flag | Description |
|------|-------------|
| `--json`, `-j` | Output results as JSON |
| `--path`, `-p` | Path to project (alternative to positional arg) |

---

## audit

Comprehensive security audit combining config checks, dependency analysis, and reachability filtering. Produces a letter grade (A–F).

**Usage**:

```bash
ossguard audit <path>
ossguard audit .
```

**Example**:

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

**Grading scale**:

| Grade | Config Score |
|-------|-------------|
| **A** | 6/6 |
| **B** | 4–5/6 |
| **C** | 2–3/6 |
| **D** | 1/6 |
| **F** | 0/6 |

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## version

Show the installed OSSGuard version.

**Usage**:

```bash
ossguard version
```

**Example**:

```
$ ossguard version
ossguard 0.1.1
```
