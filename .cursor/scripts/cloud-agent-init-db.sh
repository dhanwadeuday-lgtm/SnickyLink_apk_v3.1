#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKEND="$ROOT/backend"

if ! sudo service postgresql status >/dev/null 2>&1; then
  sudo service postgresql start
fi

sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='snickylink'" | grep -q 1 \
  || sudo -u postgres psql -c "CREATE USER snickylink WITH PASSWORD 'snickylink_dev';"

sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='snickylink'" | grep -q 1 \
  || sudo -u postgres psql -c "CREATE DATABASE snickylink OWNER snickylink;"

sudo -u postgres psql -d snickylink -tc "SELECT to_regclass('public.users')" | grep -q users || {
  cd "$BACKEND"
  # shellcheck disable=SC1091
  source .venv/bin/activate
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
  python - <<'PY'
from app.db.session import engine
from app.models.base import Base
from app.models import user, couple, invite, snick, chat, chat_keys, media, memory, calendar, community, notification, analytics, events, device, sticker, gamification, password_reset
Base.metadata.create_all(bind=engine)
print("Created base schema")
PY
  sudo -u postgres psql -d snickylink -f "$BACKEND/migrations/001_architecture_hardening.sql" -q
  sudo -u postgres psql -d snickylink -f "$BACKEND/migrations/002_production_hardening.sql" -q || true
  sudo -u postgres psql -d snickylink -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO snickylink; GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO snickylink;"
}
