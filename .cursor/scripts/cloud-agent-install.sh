#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKEND="$ROOT/backend"

if [[ ! -f "$BACKEND/.env" ]]; then
  cp "$BACKEND/.env.example" "$BACKEND/.env"
  sed -i \
    -e 's/replace-with-a-strong-32-plus-character-secret/dev-secret-key-for-local-testing-only/' \
    -e 's/replace-with-a-strong-database-password/snickylink_dev/' \
    -e 's/replace-with-a-strong-32-plus-character-media-signing-key/dev-media-signing-key-for-local-testing/' \
    "$BACKEND/.env"
fi

python3 -m venv "$BACKEND/.venv"
# shellcheck disable=SC1091
source "$BACKEND/.venv/bin/activate"
pip install --upgrade pip
pip install -r "$BACKEND/requirements.txt" pytest

cd "$ROOT/frontend"
flutter pub get

cd "$ROOT"
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi

bash "$ROOT/.cursor/scripts/cloud-agent-init-db.sh"
