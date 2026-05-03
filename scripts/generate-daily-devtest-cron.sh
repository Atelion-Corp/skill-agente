#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
# Add this line on the server (crontab -e) to archive + stop dev/test daily at 03:00 UTC
0 3 * * * /usr/bin/bash -lc 'cd /opt/apps && for d in */; do n=${d%/}; if [ "$n" = "server-atelion-project" ] || [ "$n" = "server-nurbit" ] || [ "$n" = "backups" ]; then continue; fi; if [ -f "$n/docker-compose.yml" ]; then ts=$(date +\%Y\%m\%d_\%H\%M\%S); mkdir -p /opt/apps/backups/devtest_archives/$n; docker compose -f "$n/docker-compose.yml" logs --no-color > /opt/apps/backups/devtest_archives/$n/logs_$ts.txt || true; tar -czf /opt/apps/backups/devtest_archives/$n/project_$ts.tgz -C /opt/apps "$n" || true; docker compose -f "$n/docker-compose.yml" down || true; fi; done'
EOF
