[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$ArchiveRoot = "/opt/apps/backups",
    [string]$TierRoot = "/opt/archive_tiers",
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }

$mode = if ($Apply) { "apply" } else { "dry-run" }

$remoteScript = @"
set -euo pipefail
MODE="$mode"
ARCHIVE_ROOT="$ArchiveRoot"
TIER_ROOT="$TierRoot"
ENCRYPT_PW="\${ARCHIVE_ENCRYPTION_PASSPHRASE:-}"
mkdir -p "\$TIER_ROOT/tier_30d" "\$TIER_ROOT/tier_180d"

process_file() {
  local f="\$1"
  local age_days="\$2"
  local base
  base=\$(basename "\$f")
  if [ "\$age_days" -ge 180 ]; then
    target="\$TIER_ROOT/tier_180d/\${base}.tar.xz"
    if [ "\$MODE" = "apply" ]; then
      tar -cJf "\$target" -C "$(dirname "\$f")" "\$base"
      if [ -n "\$ENCRYPT_PW" ]; then
        openssl enc -aes-256-cbc -pbkdf2 -salt -in "\$target" -out "\$target.enc" -pass env:ARCHIVE_ENCRYPTION_PASSPHRASE
        rm -f "\$target"
        target="\$target.enc"
      fi
      rm -f "\$f"
    fi
    echo "tier_180d|\$f|\$target"
  elif [ "\$age_days" -ge 30 ]; then
    target="\$TIER_ROOT/tier_30d/\${base}.tar.zst"
    if [ "\$MODE" = "apply" ]; then
      tar --zstd -cf "\$target" -C "$(dirname "\$f")" "\$base" || tar -czf "\$TIER_ROOT/tier_30d/\${base}.tar.gz" -C "$(dirname "\$f")" "\$base"
      if [ -n "\$ENCRYPT_PW" ]; then
        openssl enc -aes-256-cbc -pbkdf2 -salt -in "\$target" -out "\$target.enc" -pass env:ARCHIVE_ENCRYPTION_PASSPHRASE
        rm -f "\$target"
        target="\$target.enc"
      fi
      rm -f "\$f"
    fi
    echo "tier_30d|\$f|\$target"
  fi
}

now=\$(date +%s)
while IFS= read -r -d '' file; do
  mtime=\$(stat -c %Y "\$file")
  age=\$(( (now - mtime) / 86400 ))
  process_file "\$file" "\$age"
done < <(find "\$ARCHIVE_ROOT" -type f \( -name "*.sql" -o -name "*.csv" -o -name "*.log" -o -name "*.tgz" -o -name "*.tar.gz" \) -print0)
"@

Write-Host "Running archive lifecycle on remote in $mode mode..." -ForegroundColor Cyan
$output = & $ssh "$UserName@$HostName" $remoteScript
if ($LASTEXITCODE -ne 0) { throw "Remote lifecycle execution failed." }

$outDir = "proyecto_resultado_skill/proyectos/server_diagnostic"
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory -Force | Out-Null }
$outPath = Join-Path $outDir "archive-lifecycle-$((Get-Date).ToString('yyyyMMdd-HHmmss')).log"
$output | Set-Content -Path $outPath -Encoding UTF8
Write-Host "Lifecycle report: $outPath" -ForegroundColor Green
