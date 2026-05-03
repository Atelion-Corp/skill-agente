[CmdletBinding()]
param(
    [string]$SourceProjectPath = "C:\Users\diego\Documents\Propio\proyecto_gestion_agile",
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteAppsRoot = "/opt/apps",
    [string]$TargetProjectName = "server-atelion-project",
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }
if (-not (Test-Path $scp)) { throw "scp.exe not found." }

$composeLocal = Join-Path $SourceProjectPath "docker-compose.yml"
$envLocal = Join-Path $SourceProjectPath ".env"
if (-not (Test-Path $composeLocal)) { throw "Local source compose not found: $composeLocal" }
if (-not (Test-Path $envLocal)) { throw "Local source .env not found: $envLocal" }

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$tmpDir = Join-Path $env:TEMP "agile_overwrite_$stamp"
New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null
$localDump = Join-Path $tmpDir "gestion_agile_source.dump"
$remoteDump = "/tmp/gestion_agile_source_$stamp.dump"

$targetCandidates = @(
    "$RemoteAppsRoot/$TargetProjectName",
    "$RemoteAppsRoot/servidor-atelion-project"
)

Write-Host "Planned source: $SourceProjectPath" -ForegroundColor Cyan
Write-Host "Planned target host: $UserName@$HostName" -ForegroundColor Cyan
Write-Host "Planned target project candidates: $($targetCandidates -join ', ')" -ForegroundColor Cyan

if (-not $Apply) {
    Write-Host "Dry-run mode. Re-run with -Apply to execute overwrite." -ForegroundColor Yellow
    exit 0
}

Write-Host "Step 1/8: Ensure local source DB container is running..." -ForegroundColor Cyan
docker compose -f $composeLocal up -d db | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Failed to start local source db container." }

Write-Host "Step 2/8: Create source dump from proyecto_gestion_agile..." -ForegroundColor Cyan
docker compose -f $composeLocal exec -T db sh -lc 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc -f /tmp/gestion_agile_source.dump'
if ($LASTEXITCODE -ne 0) { throw "Failed to create local source dump inside container." }

Write-Host "Step 3/8: Copy source dump to local filesystem..." -ForegroundColor Cyan
$dbContainer = (docker compose -f $composeLocal ps -q db).Trim()
if (-not $dbContainer) { throw "Could not detect source db container id." }
docker cp "${dbContainer}:/tmp/gestion_agile_source.dump" "$localDump"
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $localDump)) { throw "Failed to copy dump from local db container." }

Write-Host "Step 4/8: Upload source dump to server..." -ForegroundColor Cyan
& $scp "$localDump" "$UserName@$HostName`:$remoteDump"
if ($LASTEXITCODE -ne 0) { throw "Failed to upload dump to remote server." }

Write-Host "Step 5/8: Detect target project path on server..." -ForegroundColor Cyan
$detectCmd = @"
set -e
for p in $($targetCandidates -join ' '); do
  if [ -d "`$p" ]; then
    echo "`$p"
    exit 0
  fi
done
exit 1
"@
$targetPath = (& $ssh "$UserName@$HostName" $detectCmd | Select-Object -First 1).Trim()
if (-not $targetPath) { throw "Target project path not found on server." }
Write-Host "Target resolved: $targetPath" -ForegroundColor Green

Write-Host "Step 6/8: Backup current target DB on server (pre-overwrite)..." -ForegroundColor Cyan
$backupRemoteCmd = @'
set -e
cd "__TARGET_PATH__"
ts=$(date +%Y%m%d_%H%M%S)
docker compose exec -T db sh -lc 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc -f /tmp/pre_overwrite_'"\$ts"'.dump'
echo "/tmp/pre_overwrite_\$ts.dump"
'@
$backupRemoteCmd = $backupRemoteCmd.Replace("__TARGET_PATH__", $targetPath)
$preBackupPath = (& $ssh "$UserName@$HostName" $backupRemoteCmd | Select-Object -Last 1).Trim()
if (-not $preBackupPath) { throw "Failed to create pre-overwrite backup on server." }
Write-Host "Remote pre-backup created: $preBackupPath" -ForegroundColor Green

Write-Host "Step 7/8: Restore source data into target DB..." -ForegroundColor Cyan
$restoreCmd = @'
set -e
cd "__TARGET_PATH__"
docker cp "$remoteDump" "$(docker compose ps -q db):/tmp/gestion_agile_source.dump"
docker compose exec -T db sh -lc 'dropdb -U "$POSTGRES_USER" --if-exists "$POSTGRES_DB"'
docker compose exec -T db sh -lc 'createdb -U "$POSTGRES_USER" "$POSTGRES_DB"'
docker compose exec -T db sh -lc 'pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists /tmp/gestion_agile_source.dump'
docker compose exec -T db sh -lc 'rm -f /tmp/gestion_agile_source.dump'
echo "RESTORE_OK"
'@
$restoreCmd = $restoreCmd.Replace("__TARGET_PATH__", $targetPath).Replace('$remoteDump', $remoteDump)
& $ssh "$UserName@$HostName" $restoreCmd
if ($LASTEXITCODE -ne 0) { throw "Restore failed. Use remote pre-backup to rollback: $preBackupPath" }

Write-Host "Step 8/8: Cleanup remote temp dump..." -ForegroundColor Cyan
& $ssh "$UserName@$HostName" "rm -f $remoteDump"

Write-Host "Overwrite complete." -ForegroundColor Green
Write-Host "Rollback backup kept on server: $preBackupPath" -ForegroundColor Yellow
Write-Host "Local source dump kept at: $localDump" -ForegroundColor Yellow
