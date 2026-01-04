#!/usr/bin/env bash
set -euo pipefail

# Runs available quality gates for the current repo (or given path):
# - build / lint / test / typecheck (if scripts exist)

TARGET="${1:-.}"
cd "$TARGET"

echo "== Repo sanity check =="
echo "Dir: $(pwd)"
echo "Node: $(node -v 2>/dev/null || echo 'not found')"
echo "npm:  $(npm -v 2>/dev/null || echo 'not found')"
echo ""

if [[ ! -f package.json ]]; then
  echo "❌ Geen package.json gevonden."
  exit 1
fi

echo "== Scripts =="
npm -s pkg get scripts || true
echo ""

run_if_exists () {
  local script="$1"
  if npm -s pkg get "scripts.$script" | grep -vq null; then
    echo "== Running: npm run $script =="
    npm run "$script"
    echo ""
  else
    echo "== Skipping: $script (niet aanwezig) =="
    echo ""
  fi
}

run_if_exists "build"
run_if_exists "lint"
run_if_exists "test"
run_if_exists "typecheck"

echo "✅ Done."
