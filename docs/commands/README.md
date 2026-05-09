# Command Reference

OSSGuard provides 27 commands grouped into four categories.

Every command:

- Accepts a **project path** as a positional argument (`ossguard scan .`)
- Supports **`--json`** for machine-readable output
- Works identically across all three implementations (Python, Go, Node.js)

## Command Index

### Core

| Command | Description | Docs |
|---------|-------------|------|
| `init` | Bootstrap OpenSSF security configs | [core.md#init](core.md#init) |
| `scan` | Read-only security posture check | [core.md#scan](core.md#scan) |
| `audit` | Comprehensive security audit | [core.md#audit](core.md#audit) |
| `version` | Show version | [core.md#version](core.md#version) |

### Security Analysis

| Command | Description | Docs |
|---------|-------------|------|
| `secrets` | Scan for leaked credentials | [security.md#secrets](security.md#secrets) |
| `baseline` | OSPS Baseline compliance | [security.md#baseline](security.md#baseline) |
| `slsa` | SLSA Build Level assessment | [security.md#slsa](security.md#slsa) |
| `badge` | Best Practices Badge readiness | [security.md#badge](security.md#badge) |
| `maturity` | S2C2F maturity assessment | [security.md#maturity](security.md#maturity) |
| `container` | Dockerfile security linting | [security.md#container](security.md#container) |
| `fuzz` | Fuzzing readiness check | [security.md#fuzz](security.md#fuzz) |

### Dependency Management

| Command | Description | Docs |
|---------|-------------|------|
| `deps` | Dependency health analysis | [dependencies.md#deps](dependencies.md#deps) |
| `drift` | SBOM drift detection | [dependencies.md#drift](dependencies.md#drift) |
| `watch` | Vulnerability monitoring | [dependencies.md#watch](dependencies.md#watch) |
| `reach` | Reachability filtering | [dependencies.md#reach](dependencies.md#reach) |
| `update` | Security-prioritized updates | [dependencies.md#update](dependencies.md#update) |
| `license` | License compliance | [dependencies.md#license](dependencies.md#license) |
| `supply-chain` | Malicious package detection | [dependencies.md#supply-chain](dependencies.md#supply-chain) |
| `tpn` | Third-party notices | [dependencies.md#tpn](dependencies.md#tpn) |

### Compliance & Generation

| Command | Description | Docs |
|---------|-------------|------|
| `policy` | Org-wide policy enforcement | [compliance.md#policy](compliance.md#policy) |
| `ci` | Generate CI security pipeline | [compliance.md#ci](compliance.md#ci) |
| `report` | Compliance reports | [compliance.md#report](compliance.md#report) |
| `insights` | SECURITY-INSIGHTS.yml | [compliance.md#insights](compliance.md#insights) |
| `pin` | Pin Actions to SHAs | [compliance.md#pin](compliance.md#pin) |
| `fix` | Auto-remediate issues | [compliance.md#fix](compliance.md#fix) |
| `sbom-gen` | Generate SBOMs | [compliance.md#sbom-gen](compliance.md#sbom-gen) |
| `compare` | Compare two projects | [compliance.md#compare](compliance.md#compare) |
