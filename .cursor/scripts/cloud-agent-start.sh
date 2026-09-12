#!/usr/bin/env bash
set -euo pipefail

sudo service postgresql start || true
sudo service redis-server start || true

for _ in $(seq 1 30); do
  if redis-cli ping >/dev/null 2>&1 && sudo -u postgres psql -tc 'SELECT 1' >/dev/null 2>&1; then
    exit 0
  fi
  sleep 1
done

echo "PostgreSQL or Redis did not become ready in time" >&2
exit 1
