#!/usr/bin/env bash
#
# Install the project's git hooks. Git hooks are NOT cloned, so run this once per
# machine after cloning. It points git at the committed .githooks/ directory.

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true

echo "✓ git hooks installed (core.hooksPath = .githooks)"
echo "  commit-msg will strip AI co-author / generated-by trailers."
