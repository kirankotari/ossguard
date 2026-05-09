# Security Analysis Commands

## secrets

Scan for leaked credentials, API keys, private keys, and tokens.

**Usage**:

```bash
ossguard secrets <path>
```

**Detection rules**: 24 regex-based patterns covering:

- AWS access keys and secret keys
- GitHub tokens (classic and fine-grained)
- Google Cloud service account keys
- Private keys (RSA, EC, PGP)
- Generic secrets, passwords, and API tokens
- Slack tokens, Stripe keys, Twilio credentials
- Database connection strings

**Example**:

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

**Severity levels**: `critical`, `high`, `medium`, `low`

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## baseline

Check project compliance against the [OSPS Security Baseline](https://baseline.openssf.org/) — the OpenSSF's standard for minimum security practices.

**Usage**:

```bash
ossguard baseline <path>
```

**What it checks**: 34 controls across three maturity levels:

- **Level 1** — Essential: version control, license, vulnerability reporting
- **Level 2** — Standard: CI/CD, dependency management, code review
- **Level 3** — Advanced: signed releases, SBOM, provenance

**Example**:

```
$ ossguard baseline .
Baseline Level 1 — L1: 100%, L2: 62%, L3: 0%
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## slsa

Assess project alignment with [SLSA](https://slsa.dev/) (Supply-chain Levels for Software Artifacts) build provenance requirements.

**Usage**:

```bash
ossguard slsa <path>
```

**What it checks**: 12 requirements across four SLSA Build Levels:

- **Level 1** — Provenance exists
- **Level 2** — Hosted build platform
- **Level 3** — Hardened builds
- **Level 4** — Full provenance and isolation

**Example**:

```
$ ossguard slsa .
SLSA Build Level 1 — 6/12 met
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## badge

Assess readiness for the [OpenSSF Best Practices Badge](https://www.bestpractices.dev/).

**Usage**:

```bash
ossguard badge <path>
```

**Badge levels**: Passing → Silver → Gold

**Example**:

```
$ ossguard badge .
Badge: silver (80% — 8/10)
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## maturity

Assess project maturity against the [S2C2F](https://github.com/ossf/s2c2f) (Secure Supply Chain Consumption Framework).

**Usage**:

```bash
ossguard maturity <path>
```

**What it checks**: 22 practices across four maturity levels:

- **Level 1** — Ingest: basic dependency management
- **Level 2** — Scan: vulnerability scanning
- **Level 3** — Enforce: policy enforcement
- **Level 4** — Rebuild: reproducible builds

**Example**:

```
$ ossguard maturity .
S2C2F Level 0 — L1: 80%, L2: 33%, L3: 17%, L4: 0%
```

> *Real output from [psf/requests](https://github.com/psf/requests)*

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## container

Lint Dockerfiles for security best practices.

**Usage**:

```bash
ossguard container <path>
```

**Detection rules** (12 rules):

- Running as root
- Using `latest` tag
- Missing `HEALTHCHECK`
- `ADD` instead of `COPY`
- Unpinned base images
- Secrets in build args
- Missing `.dockerignore`
- And more

**Example**:

```
$ ossguard container .
Container scan: 0 files, 0 findings (C:0 H:0 M:0 L:0)
```

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |

---

## fuzz

Check fuzzing readiness and generate starter harness files.

**Usage**:

```bash
ossguard fuzz <path>
```

**Supported languages** (7): Python, Go, Rust, C/C++, Java, JavaScript, Ruby

**Example**:

```
$ ossguard fuzz .
Fuzz: python, framework: none, score: 0/100
  No fuzzing detected — see recommendations:
  [setup] No fuzz test directory found
  [setup] No fuzz test files found
```

**Flags**:

| Flag | Description |
|------|-------------|
| `--json` | Output results as JSON |
