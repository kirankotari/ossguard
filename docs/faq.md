# FAQ

## General

### What is OSSGuard?

OSSGuard is a CLI tool that scans any open-source project and tells you what [OpenSSF](https://openssf.org/) security best practices are missing — then helps you fix them. It covers Scorecard, Sigstore, SLSA, SBOM, CodeQL, Dependabot, and more, all in one tool.

### Is OSSGuard an official OpenSSF project?

No. OSSGuard is an independent project that implements and unifies OpenSSF best practices. It is intended for future contribution to the OpenSSF community.

### What languages does OSSGuard support?

OSSGuard auto-detects and supports:

- Python, JavaScript/TypeScript, Go, Rust, Java, C/C++, Ruby, PHP, C#
- Package managers: npm, yarn, pnpm, pip, poetry, cargo, go modules, maven, gradle
- Frameworks: React, Vue, Angular, Next.js, Django, Flask, FastAPI, Express

### Does OSSGuard work with private repositories?

Yes. OSSGuard operates entirely on the local file system. It does not require GitHub API access or any authentication for its core commands. The `deps`, `watch`, `reach`, and `update` commands make API calls to OSV and deps.dev for vulnerability data, but these APIs are public.

### Does OSSGuard send any data externally?

Only the `deps`, `watch`, `reach`, and `update` commands make network calls to:

- [OSV API](https://osv.dev/) — to check for known vulnerabilities
- [deps.dev API](https://deps.dev/) — to get dependency risk scores

No project source code is ever transmitted. Only package names and versions are sent to these public APIs. All other commands run entirely offline.

## Installation

### Which implementation should I use?

- **Developer workstation**: `pip install ossguard` (Python) — richest UI
- **CI pipelines**: `brew install kirankotari/tap/ossguard` (Go) — single binary, fastest
- **Node.js projects**: `npx ossguard` (npm) — zero install
- **Docker/containers**: `ghcr.io/kirankotari/ossguard-go` — no host dependencies

### Can I use multiple implementations?

Yes. All implementations produce identical results. You might use the Python version locally for its rich UI and the Go binary in CI for speed.

### Does OSSGuard require internet access?

No, for most commands. Only dependency analysis commands (`deps`, `watch`, `reach`, `update`) require internet access to query vulnerability databases. All other commands work fully offline.

## Commands

### What does `ossguard init` create?

It generates up to 7 files:

| File | Purpose |
|------|---------|
| `SECURITY.md` | Vulnerability disclosure policy |
| `.github/workflows/scorecard.yml` | Automated security scoring |
| `.github/dependabot.yml` | Dependency update automation |
| `.github/workflows/codeql.yml` | Code scanning |
| `.github/workflows/sbom.yml` | SBOM generation |
| `.github/workflows/sigstore.yml` | Release signing |
| `.github/BRANCH_PROTECTION.md` | Branch protection guide |

It **never overwrites** existing files.

### What is the grading scale for `ossguard audit`?

| Grade | Meaning |
|-------|---------|
| **A** | 6/6 security configs present |
| **B** | 4–5/6 |
| **C** | 2–3/6 |
| **D** | 1/6 |
| **F** | 0/6 |

### Can I use OSSGuard in CI to fail builds?

Yes. Use `--json` output and parse the results. See [CI Integration](ci-integration.md) for examples with GitHub Actions and GitLab CI.

### What secret patterns does OSSGuard detect?

24 regex-based rules covering: AWS keys, GitHub tokens, Google Cloud keys, private keys (RSA/EC/PGP), Slack tokens, Stripe keys, Twilio credentials, generic passwords, database connection strings, and more.

## Frameworks & Standards

### What is the OSPS Baseline?

The [OSPS Security Baseline](https://baseline.openssf.org/) is the OpenSSF standard for minimum security practices in open-source projects. It defines 34 controls across three maturity levels. `ossguard baseline` checks your project against all of them.

### What is SLSA?

[SLSA](https://slsa.dev/) (Supply-chain Levels for Software Artifacts) is a framework for ensuring the integrity of software artifacts. `ossguard slsa` checks 12 requirements across four build levels.

### What is S2C2F?

The [Secure Supply Chain Consumption Framework](https://github.com/ossf/s2c2f) (S2C2F) helps organizations evaluate how they consume open-source software. `ossguard maturity` assesses 22 practices across four levels.

### What is the OpenSSF Best Practices Badge?

The [Best Practices Badge](https://www.bestpractices.dev/) is a self-certification program for open-source projects. `ossguard badge` checks your project's readiness for the Passing, Silver, and Gold badge levels.

## Troubleshooting

### OSSGuard says "No dependencies detected"

This means OSSGuard could not find a recognized dependency manifest file (e.g., `requirements.txt`, `package.json`, `go.mod`). Ensure your project has a standard dependency file in the root directory.

### Secret scan has false positives

This is expected for test certificates, example configurations, and documentation. Review the findings and consider adding a `.ossguardignore` file (planned feature) or filtering by severity in CI.

### Commands work differently between implementations

All implementations should produce identical results. If you find a discrepancy, please [open an issue](https://github.com/kirankotari/ossguard/issues) with the command, project path, and outputs from both implementations.
