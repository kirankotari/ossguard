# Compliance & Generation Commands

## policy

Enforce organization-wide security policies across projects.

**Usage**:

```bash
ossguard policy <path>
```

**How it works**:

Define a JSON policy file specifying required security configurations, minimum scores, and mandatory controls. OSSGuard evaluates the project against the policy and reports violations.

**Example policy**:

```json
{
  "require_security_md": true,
  "require_scorecard": true,
  "min_baseline_level": 1,
  "require_signed_releases": true,
  "max_critical_vulns": 0
}
```

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## ci

Generate a unified CI security pipeline that runs all relevant OSSGuard checks as a single GitHub Actions workflow.

**Usage**:

```bash
ossguard ci <path>
```

**What it generates**:

A `.github/workflows/ossguard.yml` file that:

- Runs on pull requests and pushes to main
- Executes `scan`, `secrets`, `deps`, and `baseline` checks
- Reports results as PR comments or check annotations
- Fails the pipeline on critical findings

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## report

Export comprehensive security compliance reports in HTML or JSON format.

**Usage**:

```bash
ossguard report <path>
```

**Report contents**:

- Executive summary with overall grade
- Detailed findings by category
- Dependency vulnerability listing
- Compliance status (Baseline, SLSA, Badge)
- Remediation recommendations
- Timestamp and project metadata

**Output formats**: HTML, JSON

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## insights

Generate or validate a [SECURITY-INSIGHTS.yml](https://github.com/ossf/security-insights-spec) file.

**Usage**:

```bash
ossguard insights <path>
```

**What it does**:

- Generates a SECURITY-INSIGHTS.yml file based on detected project configuration
- Validates an existing file against the OpenSSF Security Insights specification
- Reports missing or incorrect fields

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## pin

Pin GitHub Actions to commit SHAs for supply-chain safety.

**Usage**:

```bash
ossguard pin <path>
ossguard pin --apply <path>
```

**How it works**:

1. Scans all `.github/workflows/*.yml` files
2. Finds Actions referenced by tag (e.g., `actions/checkout@v4`)
3. Resolves each tag to its full commit SHA
4. With `--apply`, rewrites the files in place

**Example**:

```
$ ossguard pin .
.github/workflows/ci.yml:
  actions/checkout@v4 → actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11
  actions/setup-python@v5 → actions/setup-python@82c7e631bb3cdc910f68e0081d67478d79c6982d
```

**Flags**:

| Flag | Description |
|------|-------------|
| `--apply` | Write changes to files (default: dry run) |
| `--json` | Output results as JSON |

---

## fix

Auto-remediate common security issues.

**Usage**:

```bash
ossguard fix <path>
```

**What it fixes**:

- Adds missing security configurations (like `init`)
- Bumps vulnerable dependencies to patched versions
- Pins GitHub Actions to commit SHAs
- Adds missing `.gitignore` entries for secrets

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## sbom-gen

Generate a Software Bill of Materials from project dependency manifests.

**Usage**:

```bash
ossguard sbom-gen <path>
```

**Output formats**:

- **SPDX 2.3** (default)
- **CycloneDX 1.5**

**What it includes**:

- All direct dependencies with versions
- License information per package
- Package URLs (purls) for identification
- Tool metadata (ossguard version)
- Document creation timestamp

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## compare

Compare security posture of two projects side by side.

**Usage**:

```bash
ossguard compare <path1> <path2>
```

**What it compares**:

- Security configuration presence (SECURITY.md, Scorecard, etc.)
- Audit grade
- Baseline compliance level
- Dependency vulnerability counts
- Secret scan findings

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |
