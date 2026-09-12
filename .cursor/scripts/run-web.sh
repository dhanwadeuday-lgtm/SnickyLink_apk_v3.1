#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WEB_ROOT="$ROOT/frontend/build/web"

if [[ ! -f "$WEB_ROOT/index.html" ]]; then
  cd "$ROOT/frontend"
  flutter build web --dart-define=API_BASE_URL=http://127.0.0.1:8000
fi

cd "$WEB_ROOT"
exec python3 -m http.server 8080 --bind 0.0.0.0
