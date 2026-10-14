#!/usr/bin/env bash
# Link each skill in skills/ into the agent skill folders. Safe to run again.
# --check: change nothing, report missing or wrong links, exit 1 if any.
# --uninstall: remove the links that point into this repo.
set -euo pipefail

MODE="${1:-install}"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=("$HOME/.claude/skills" "$HOME/.agents/skills")
broken=0

for dir in "$REPO"/skills/*/; do
  name="$(basename "$dir")"
  src="$REPO/skills/$name"
  for target in "${TARGETS[@]}"; do
    dst="$target/$name"
    case "$MODE" in
      --check)
        if [[ ! -L "$dst" || "$(readlink "$dst")" != "$src" ]]; then
          echo "  bad  $dst"; broken=1
        fi ;;
      --uninstall)
        if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
          rm "$dst"; echo "  removed  $dst"
        fi ;;
      install)
        if [[ -e "$dst" && ! -L "$dst" ]]; then
          echo "  skip  $dst is a real folder, not a link. Move it first."; broken=1; continue
        fi
        mkdir -p "$target"
        ln -sfn "$src" "$dst"
        echo "  linked  $dst" ;;
      *) echo "Usage: $0 [--check|--uninstall]"; exit 2 ;;
    esac
  done
done

if [[ "$MODE" == "--check" ]]; then
  (( broken )) && { echo "✗ Links missing or wrong. Run ./install.sh."; exit 1; }
  echo "✓ All links OK"
fi
exit "$broken"
