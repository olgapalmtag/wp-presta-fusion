#!/bin/bash
set -euo pipefail

echo "### Entferne große Datei wp-presta-fusion.zip aus der Git-Historie ###"

# Sicherstellen, dass git installiert ist
if ! command -v git >/dev/null 2>&1; then
  echo "git ist nicht installiert – bitte zuerst installieren."
  exit 1
fi

# Datei zur Sicherheit ignorieren
echo "wp-presta-fusion.zip" >> .gitignore

# Entferne Datei aus dem aktuellen Commit-Bereich
git rm --cached wp-presta-fusion.zip || true
git commit -m "Entferne ZIP-Datei aus Index"
git push || true

# Nutze filter-branch um Datei aus kompletter Historie zu löschen
echo "### Entferne Datei aus gesamter Historie ###"
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch wp-presta-fusion.zip' \
  --prune-empty --tag-name-filter cat -- --all

# Force Push der bereinigten Historie
echo "### Push der bereinigten Historie ###"
git push origin --force

echo "### Bereinigung abgeschlossen. ZIP-Datei wurde entfernt. ###"

