#!/usr/bin/env bash
set -euo pipefail

# Apply the Webbiecorn project template to a target repo folder.
# Usage:
#   ops/apply_template.sh /path/to/repo

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.webbiecorn-template"
TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "Gebruik: $0 /pad/naar/jouw/repo"
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "❌ Target bestaat niet: $TARGET"
  exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "❌ Template map ontbreekt: $TEMPLATE_DIR"
  exit 1
fi

ts="$(date +%Y%m%d-%H%M%S)"
backup_dir="$TARGET/.webbiecorn_template_backup/$ts"
mkdir -p "$backup_dir"

copy_with_backup () {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" ]]; then
    if [[ -d "$dest" ]]; then
      cp -a "$dest" "$backup_dir/" 2>/dev/null || true
    else
      mkdir -p "$backup_dir/$(dirname "${dest#$TARGET/}")" 2>/dev/null || true
      cp -a "$dest" "$backup_dir/$(dirname "${dest#$TARGET/}")/" 2>/dev/null || true
    fi
    echo "🧯 Backup: $dest -> $backup_dir/"
  fi

  mkdir -p "$(dirname "$dest")"
  if [[ -d "$src" ]]; then
    rm -rf "$dest"
    cp -a "$src" "$dest"
  else
    cp -a "$src" "$dest"
  fi

  echo "✅ Copied: ${dest#$TARGET/}"
}

copy_with_backup "$TEMPLATE_DIR/.editorconfig"     "$TARGET/.editorconfig"
copy_with_backup "$TEMPLATE_DIR/.prettierrc.json"  "$TARGET/.prettierrc.json"
copy_with_backup "$TEMPLATE_DIR/.prettierignore"   "$TARGET/.prettierignore"
copy_with_backup "$TEMPLATE_DIR/.vscode"           "$TARGET/.vscode"

echo ""
echo "🎉 Template applied to: $TARGET"
echo "Backups (if any): $backup_dir"
