[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$LocalProjectPath,
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteBaseDir = "/opt/apps",
    [switch]$Deploy
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }
if (-not (Test-Path $scp)) { throw "scp.exe not found." }

if (-not (Test-Path $LocalProjectPath)) { throw "Local project not found: $LocalProjectPath" }
$projectName = Split-Path -Leaf $LocalProjectPath
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$tmpTgz = Join-Path $env:TEMP "$projectName-$stamp.tgz"

tar -czf "$tmpTgz" -C (Split-Path -Parent $LocalProjectPath) $projectName
if (-not (Test-Path $tmpTgz)) { throw "Failed to package local project." }

$remoteTgz = "/tmp/$projectName-$stamp.tgz"
& $scp "$tmpTgz" "$UserName@$HostName`:$remoteTgz"
if ($LASTEXITCODE -ne 0) { throw "Upload failed." }

$deployFlag = if ($Deploy) { "1" } else { "0" }
$remoteCmd = @"
set -e
mkdir -p "$RemoteBaseDir/$projectName"
tar -xzf "$remoteTgz" -C "$RemoteBaseDir"
cd "$RemoteBaseDir/$projectName"
docker compose config >/tmp/${projectName}_compose_check.txt
if [ "$deployFlag" = "1" ]; then
  docker compose up -d --build
fi
echo "REMOTE_VALIDATE_OK"
"@
& $ssh "$UserName@$HostName" $remoteCmd
if ($LASTEXITCODE -ne 0) { throw "Remote validation/deploy failed." }

Write-Host "Project uploaded and validated: $projectName" -ForegroundColor Green
if ($Deploy) { Write-Host "Deployment executed." -ForegroundColor Green } else { Write-Host "Deploy skipped (validation only)." -ForegroundColor Yellow }
