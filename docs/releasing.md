# Releasing

OSSGuard uses a coordinated release model. A single tag on the `ossguard` umbrella repo triggers releases across all three implementations.

## How It Works

```
Tag v0.2.0 on ossguard
        │
        ▼
┌───────────────────────┐
│  release.yml          │
│  (ossguard repo)      │
├───────────────────────┤
│ 1. Validate semver    │
│ 2. Tag all impl repos │
│ 3. Create GH Release  │
└──────┬────────────────┘
       │ Creates tags:
       ├──▶ ossguard-python v0.2.0  ──▶ release.yml  ──▶ PyPI publish
       ├──▶ ossguard-go v0.2.0      ──▶ release.yml  ──▶ Binary + Docker + Homebrew
       └──▶ ossguard-npm v0.2.0     ──▶ publish.yml  ──▶ npm publish
```

## Release Checklist

### 1. Update Versions in Each Repo

Before tagging, update the version constants:

**ossguard-python**:
- `src/ossguard/__init__.py` → `__version__ = "X.Y.Z"`
- `pyproject.toml` → `version = "X.Y.Z"`

**ossguard-go**:
- `cmd/ossguard/main.go` → `const version = "X.Y.Z"`

**ossguard-npm**:
- `package.json` → `"version": "X.Y.Z"`
- `src/index.ts` → `VERSION = "X.Y.Z"`

Or use the helper script:

```bash
./scripts/bump-version.sh 0.2.0
```

### 2. Update Changelogs

Add a release entry in each repo's `CHANGELOG.md`:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- ...

### Fixed
- ...
```

### 3. Commit and Push Version Bumps

```bash
# In each implementation repo
git add -A
git commit -m "chore: bump version to X.Y.Z"
git push origin main
```

### 4. Tag the Umbrella Repo

```bash
cd ossguard
git tag -a vX.Y.Z -m "Release X.Y.Z"
git push origin vX.Y.Z
```

This triggers the coordinated release workflow, which:

1. Validates the semver tag
2. Creates `vX.Y.Z` tags on `ossguard-python`, `ossguard-go`, and `ossguard-npm`
3. Creates a GitHub Release on `ossguard` with install instructions and links
4. Each implementation's tag-triggered workflow publishes to its package registry

### 5. Verify

After a few minutes, confirm all packages are published:

```bash
# Python
pip install ossguard==X.Y.Z

# Go
brew upgrade ossguard

# npm
npx ossguard@X.Y.Z version
```

Check the release pages:
- https://github.com/kirankotari/ossguard/releases
- https://github.com/kirankotari/ossguard-python/releases
- https://github.com/kirankotari/ossguard-go/releases
- https://github.com/kirankotari/ossguard-npm/releases

## Prerequisites

### RELEASE_TOKEN Secret

The coordinated release workflow requires a GitHub Personal Access Token (PAT) with `repo` scope stored as a repository secret named `RELEASE_TOKEN` in the `ossguard` repo.

To create it:

1. Go to https://github.com/settings/tokens
2. Generate a **fine-grained** token with:
   - **Repositories**: `ossguard-python`, `ossguard-go`, `ossguard-npm`
   - **Permissions**: Contents (read and write)
3. Go to https://github.com/kirankotari/ossguard/settings/secrets/actions
4. Add secret: `RELEASE_TOKEN` = your token

### PyPI Trusted Publisher

The `ossguard-python` release workflow uses PyPI trusted publishing. Ensure the publisher is configured:

- **Repository**: `kirankotari/ossguard-python`
- **Workflow**: `release.yml`
- **Environment**: `pypi`

Configure at: https://pypi.org/manage/project/ossguard/settings/publishing/

### npm Token

The `ossguard-npm` publish workflow needs an `NPM_TOKEN` secret in the `ossguard-npm` repo.

## Individual Releases

If you need to release a single implementation independently (e.g., a hotfix):

```bash
# Tag directly in the implementation repo
cd ossguard-python
git tag -a v0.1.2 -m "Release 0.1.2"
git push origin v0.1.2
```

This triggers only that repo's release workflow without affecting the others.
