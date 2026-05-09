# Dependency Management Commands

## deps

Analyze dependency health — vulnerabilities, risk scores, and outdated packages.

**Usage**:

```bash
ossguard deps <path>
```

**Data sources**:

- [OSV](https://osv.dev/) — vulnerability database
- [deps.dev](https://deps.dev/) — risk scores, version info, license data

**What it reports**:

- Known vulnerabilities per dependency (CVE IDs, severity)
- Risk scores from deps.dev
- Outdated package detection
- License information

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## drift

Detect dependency drift between SBOM snapshots. Useful for tracking what changed between releases.

**Usage**:

```bash
ossguard drift <path>
```

**What it reports**:

- Added dependencies
- Removed dependencies
- Version changes (upgrades and downgrades)
- Risk assessment for each change

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## watch

Continuous vulnerability monitoring from an SBOM. Designed for post-deployment monitoring — checks whether any dependency has gained new vulnerabilities since the last scan.

**Usage**:

```bash
ossguard watch <path>
```

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## reach

Filter vulnerabilities by runtime reachability. Uses static import analysis to determine whether a vulnerable function is actually called in your code.

**Usage**:

```bash
ossguard reach <path>
```

**How it works**:

1. Parses your project's import statements
2. Maps imports to known vulnerable packages
3. Filters out vulnerabilities in packages that are installed but not imported
4. Reports only reachable vulnerabilities

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## update

Show available dependency updates prioritized by security impact.

**Usage**:

```bash
ossguard update <path>
```

**Prioritization**:

1. Dependencies with known vulnerabilities (critical first)
2. Dependencies with security-related updates
3. Major version updates
4. Minor and patch updates

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## license

Check dependency license compliance and detect conflicts.

**Usage**:

```bash
ossguard license <path>
```

**What it checks**:

- License type for each dependency
- Compatibility with your project's license
- Copyleft vs permissive classification
- Unknown or missing licenses

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## supply-chain

Detect supply-chain risks in dependencies — malicious packages and typosquatting.

**Usage**:

```bash
ossguard supply-chain <path>
```

**What it checks**:

- Package name similarity to popular packages (typosquatting)
- Recently published packages with few downloads
- Package ownership changes
- Known malicious package indicators

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## tpn

Generate third-party notices from project dependencies.

**Usage**:

```bash
ossguard tpn <path>
```

**What it generates**:

A consolidated third-party notice file listing all dependencies with their:

- Package name and version
- License type
- Copyright holder

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |
