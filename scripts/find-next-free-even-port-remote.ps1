[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [int]$StartPort = 4000,
    [int]$MaxPort = 4998
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }

$remote = @"
for p in \$(seq $StartPort 2 $MaxPort); do
  if ! ss -tuln | awk '{print \$5}' | grep -Eq "(:|\.)\${p}$"; then
    echo \$p
    exit 0
  fi
done
exit 1
"@

$port = & $ssh "$UserName@$HostName" $remote
if ($LASTEXITCODE -ne 0 -or -not $port) {
    throw "No free even port found in range $StartPort-$MaxPort"
}
Write-Output ($port | Select-Object -First 1)
