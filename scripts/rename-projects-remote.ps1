[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }

$moves = @(
    @{ from = "/opt/apps/servidor-atelion-project"; to = "/opt/apps/server-atelion-project" },
    @{ from = "/opt/apps/nurbit"; to = "/opt/apps/server-nurbit" }
)

if (-not $Apply) {
    Write-Host "Dry run rename plan:" -ForegroundColor Yellow
    $moves | ForEach-Object { Write-Host "$($_.from) -> $($_.to)" }
    Write-Host "Use -Apply to execute on server." -ForegroundColor Yellow
    exit 0
}

$remote = @"
set -e
for pair in "servidor-atelion-project:server-atelion-project" "nurbit:server-nurbit"; do
  src="/opt/apps/\${pair%%:*}"
  dst="/opt/apps/\${pair##*:}"
  if [ -d "\$src" ] && [ ! -e "\$dst" ]; then
    mv "\$src" "\$dst"
  fi
done
echo "RENAME_DONE"
"@

& $ssh "$UserName@$HostName" $remote
if ($LASTEXITCODE -ne 0) {
    throw "Remote rename failed."
}
