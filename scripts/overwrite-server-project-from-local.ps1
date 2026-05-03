[CmdletBinding()]
param(
    [string]$LocalProjectPath = "C:\Users\diego\Documents\Propio\proyecto_gestion_agile",
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteTargetPath = "/opt/apps/server-atelion-project",
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }
if (-not (Test-Path $scp)) { throw "scp.exe not found." }
if (-not (Test-Path $LocalProjectPath)) { throw "Local project path not found: $LocalProjectPath" }

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$projectName = Split-Path -Leaf $LocalProjectPath
$tmpTgz = Join-Path $env:TEMP "${projectName}_overwrite_$stamp.tgz"
$remoteTgz = "/tmp/${projectName}_overwrite_$stamp.tgz"
$remoteBackupTgz = "/tmp/server-atelion-project_backup_$stamp.tgz"

Write-Host "Source local: $LocalProjectPath"
Write-Host "Target remote: ${UserName}@${HostName}:$RemoteTargetPath"
if (-not $Apply) {
    Write-Host "Dry-run mode. Re-run with -Apply to execute overwrite." -ForegroundColor Yellow
    exit 0
}

tar -czf "$tmpTgz" -C (Split-Path -Parent $LocalProjectPath) $projectName
if (-not (Test-Path $tmpTgz)) { throw "Failed to create local tarball." }

& $scp "$tmpTgz" "$UserName@$HostName`:$remoteTgz"
if ($LASTEXITCODE -ne 0) { throw "Failed to upload tarball." }

$remoteCmd = @"
set -e
if [ ! -d "$RemoteTargetPath" ]; then
  echo "Target path not found: $RemoteTargetPath"
  exit 1
fi
mkdir -p /opt/apps/backups/overwrite_snapshots
tar -czf "$remoteBackupTgz" -C "$(dirname "$RemoteTargetPath")" "$(basename "$RemoteTargetPath")"
cp "$remoteBackupTgz" "/opt/apps/backups/overwrite_snapshots/server-atelion-project_backup_$stamp.tgz"
find "$RemoteTargetPath" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
tar -xzf "$remoteTgz" -C "$(dirname "$RemoteTargetPath")"
tmpExtractPath="$(dirname "$RemoteTargetPath")/$projectName"
if [ "$tmpExtractPath" != "$RemoteTargetPath" ]; then
  shopt -s dotglob
  mv "$tmpExtractPath"/* "$RemoteTargetPath"/
  rmdir "$tmpExtractPath"
fi
cd "$RemoteTargetPath"
docker compose down || true
docker compose up -d --build
docker compose ps
echo "OVERWRITE_DEPLOY_OK"
"@

& $ssh "$UserName@$HostName" $remoteCmd
if ($LASTEXITCODE -ne 0) { throw "Remote overwrite deploy failed." }

Write-Host "Overwrite deployment completed successfully." -ForegroundColor Green
Write-Host "Remote backup: /opt/apps/backups/overwrite_snapshots/server-atelion-project_backup_$stamp.tgz" -ForegroundColor Yellow
