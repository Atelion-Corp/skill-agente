[CmdletBinding()]
param(
    [string]$LocalRoot = "C:\Users\diego\Documents\Propio\skill_agente",
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteBase = "/opt/colossus",
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }
if (-not (Test-Path $scp)) { throw "scp.exe not found." }
if (-not (Test-Path $LocalRoot)) { throw "Local root not found: $LocalRoot" }

Set-Location $LocalRoot
& pwsh -File ".\scripts\reconcile-toolkit.ps1" -Root "." -PruneGenerated

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$pkg = Join-Path $env:TEMP "skill_agente_colossus_$stamp.tgz"
tar -czf "$pkg" -C (Split-Path -Parent $LocalRoot) (Split-Path -Leaf $LocalRoot)
if (-not (Test-Path $pkg)) { throw "Package creation failed." }

Write-Host "Package ready: $pkg" -ForegroundColor Green
if (-not $Apply) {
    Write-Host "Dry-run mode. Re-run with -Apply to upload and install." -ForegroundColor Yellow
    exit 0
}

$remotePkg = "/tmp/skill_agente_colossus_$stamp.tgz"
& $scp "$pkg" "$UserName@$HostName`:$remotePkg"
if ($LASTEXITCODE -ne 0) { throw "Upload failed." }

$remoteInstall = @"
set -e
sudo mkdir -p "$RemoteBase"
sudo tar -xzf "$remotePkg" -C "$RemoteBase"
if [ -d "$RemoteBase/skill_agente" ]; then
  sudo chown -R ${UserName}:${UserName} "$RemoteBase/skill_agente"
fi
rm -f "$remotePkg"
echo "UPLOAD_INSTALL_OK"
"@
& $ssh "$UserName@$HostName" $remoteInstall
if ($LASTEXITCODE -ne 0) { throw "Remote install failed." }

Write-Host "Toolkit uploaded and installed in $RemoteBase/skill_agente" -ForegroundColor Green
