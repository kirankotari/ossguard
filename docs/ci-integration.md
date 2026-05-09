# CI Integration

OSSGuard is designed to run in CI pipelines. Every command supports `--json` for machine-readable output, and the exit code reflects the result.

## GitHub Actions

### Basic security gate

```yaml
name: Security Check

on:
  pull_request:
  push:
    branches: [main]

jobs:
  ossguard:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install OSSGuard
        run: pip install ossguard

      - name: Security Scan
        run: ossguard scan --json . > scan-results.json

      - name: Security Audit
        run: ossguard audit --json . > audit-results.json

      - name: Secret Scan
        run: ossguard secrets --json . > secrets-results.json

      - name: Upload Results
        uses: actions/upload-artifact@v4
        with:
          name: ossguard-results
          path: "*-results.json"
```

### Using the Go binary (faster)

```yaml
name: Security Check

on:
  pull_request:
  push:
    branches: [main]

jobs:
  ossguard:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install OSSGuard
        run: |
          curl -fsSL https://github.com/kirankotari/ossguard-go/releases/download/v0.1.1/ossguard-linux-amd64 -o ossguard
          chmod +x ossguard
          sudo mv ossguard /usr/local/bin/

      - name: Run Audit
        run: ossguard audit --json . > audit.json

      - name: Check Baseline
        run: ossguard baseline --json .

      - name: Check Secrets
        run: ossguard secrets --json .
```

### Using npx (Node.js projects)

```yaml
name: Security Check

on:
  pull_request:

jobs:
  ossguard:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: "20"

      - name: Security Scan
        run: npx ossguard scan --json .

      - name: Secret Scan
        run: npx ossguard secrets --json .
```

### Using Docker

```yaml
name: Security Check

on:
  pull_request:

jobs:
  ossguard:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/kirankotari/ossguard-go:0.1.1
    steps:
      - uses: actions/checkout@v4

      - name: Scan
        run: ossguard scan --json .

      - name: Audit
        run: ossguard audit --json .
```

## GitLab CI

```yaml
ossguard:
  image: ghcr.io/kirankotari/ossguard-go:0.1.1
  stage: test
  script:
    - ossguard scan --json . > scan.json
    - ossguard audit --json . > audit.json
    - ossguard secrets --json . > secrets.json
  artifacts:
    paths:
      - "*.json"
    expire_in: 30 days
```

## Quality Gates

### Fail on critical secrets

```bash
#!/bin/bash
RESULT=$(ossguard secrets --json .)
CRITICAL=$(echo "$RESULT" | jq '[.findings[] | select(.severity == "critical")] | length')

if [ "$CRITICAL" -gt 0 ]; then
  echo "FAIL: $CRITICAL critical secrets found"
  exit 1
fi
```

### Enforce minimum baseline level

```bash
#!/bin/bash
RESULT=$(ossguard baseline --json .)
LEVEL=$(echo "$RESULT" | jq -r '.level')

if [ "$LEVEL" -lt 1 ]; then
  echo "FAIL: Baseline Level $LEVEL < required Level 1"
  exit 1
fi
```

### Audit grade threshold

```bash
#!/bin/bash
RESULT=$(ossguard audit --json .)
GRADE=$(echo "$RESULT" | jq -r '.grade')

case $GRADE in
  A|B) echo "PASS: Grade $GRADE" ;;
  *)   echo "FAIL: Grade $GRADE — minimum B required"; exit 1 ;;
esac
```

## JSON Output Schema

All commands produce consistent JSON. Key fields:

### `scan --json`

```json
{
  "repo_name": "my-project",
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

### `audit --json`

```json
{
  "project": "my-project",
  "grade": "B",
  "config_score": "4/6",
  "missing": ["sbom_workflow", "sigstore"],
  "recommendations": [
    "Run `ossguard init` to add SBOM workflow",
    "Run `ossguard init` to add Sigstore signing"
  ]
}
```

### `secrets --json`

```json
{
  "files_scanned": 123,
  "total_findings": 5,
  "findings": [
    {
      "file": "src/config.py",
      "line": 42,
      "severity": "critical",
      "rule": "private-key",
      "match": "-----BEGIN RSA PRIVATE KEY-----"
    }
  ]
}
```
