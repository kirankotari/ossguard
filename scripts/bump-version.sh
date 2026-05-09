#!/usr/bin/env bash
set -euo pipefail

# Bump version across all OSSGuard implementation repos.
# Usage: ./scripts/bump-version.sh <version>
# Example: ./scripts/bump-version.sh 0.2.0

VERSION="${1:?Usage: $0 <version>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARENT="$(dirname "$ROOT")"

# macOS-compatible in-place sed
sedi() {
  sed -i.bak "$@" && rm -f "${@: -1}.bak"
}

echo "Bumping all OSSGuard repos to version $VERSION"
echo "================================================"

# --- ossguard-python ---
PYTHON_DIR="$PARENT/ossguard-python"
if [ -d "$PYTHON_DIR" ]; then
  echo ""
  echo "=== ossguard-python ==="

  # pyproject.toml
  sedi "s/^version = \".*\"/version = \"$VERSION\"/" "$PYTHON_DIR/pyproject.toml"
  echo "  Updated pyproject.toml"

  # __init__.py
  sedi "s/__version__ = \".*\"/__version__ = \"$VERSION\"/" "$PYTHON_DIR/src/ossguard/__init__.py"
  echo "  Updated __init__.py"

  # sbom_gen.py embedded version
  sedi "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" "$PYTHON_DIR/src/ossguard/analyzers/sbom_gen.py"
  echo "  Updated sbom_gen.py"
else
  echo "SKIP: $PYTHON_DIR not found"
fi

# --- ossguard-go ---
GO_DIR="$PARENT/ossguard-go"
if [ -d "$GO_DIR" ]; then
  echo ""
  echo "=== ossguard-go ==="

  sedi "s/const version = \".*\"/const version = \"$VERSION\"/" "$GO_DIR/cmd/ossguard/main.go"
  echo "  Updated main.go"
else
  echo "SKIP: $GO_DIR not found"
fi

# --- ossguard-npm ---
NPM_DIR="$PARENT/ossguard-npm"
if [ -d "$NPM_DIR" ]; then
  echo ""
  echo "=== ossguard-npm ==="

  # package.json — update the top-level "version" field
  sedi "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" "$NPM_DIR/package.json"
  echo "  Updated package.json"

  # src/index.ts
  sedi "s/VERSION = \".*\"/VERSION = \"$VERSION\"/" "$NPM_DIR/src/index.ts"
  echo "  Updated src/index.ts"
else
  echo "SKIP: $NPM_DIR not found"
fi

# --- ossguard (docs repo) ---
echo ""
echo "=== ossguard (docs) ==="

# Update version references in install docs
sedi "s|ossguard-go:0\.[0-9]*\.[0-9]*|ossguard-go:$VERSION|g" "$ROOT/README.md"
sedi "s|ossguard-go:0\.[0-9]*\.[0-9]*|ossguard-go:$VERSION|g" "$ROOT/docs/installation.md"
sedi "s|ossguard-go:0\.[0-9]*\.[0-9]*|ossguard-go:$VERSION|g" "$ROOT/docs/ci-integration.md"
sedi "s|download/v0\.[0-9]*\.[0-9]*|download/v$VERSION|g" "$ROOT/README.md"
sedi "s|download/v0\.[0-9]*\.[0-9]*|download/v$VERSION|g" "$ROOT/docs/installation.md"
sedi "s|ossguard 0\.[0-9]*\.[0-9]*|ossguard $VERSION|g" "$ROOT/docs/getting-started.md"
echo "  Updated docs version references"

echo ""
echo "Done. Review changes with:"
echo "  git -C $PYTHON_DIR diff"
echo "  git -C $GO_DIR diff"
echo "  git -C $NPM_DIR diff"
echo "  git -C $ROOT diff"
echo ""
echo "Then commit each repo and tag ossguard:"
echo "  git -C $ROOT tag -a v$VERSION -m 'Release $VERSION'"
echo "  git -C $ROOT push origin v$VERSION"
