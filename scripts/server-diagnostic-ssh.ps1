[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HostName,
    [string]$UserName = "diego-admin",
    [string]$OutputDir = "proyecto_resultado_skill/proyectos/server_diagnostic"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) {
    throw "OpenSSH client not found at $ssh"
}

if (-not (Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$rawPath = Join-Path $OutputDir "server-diagnostic-$timestamp.txt"
$jsonPath = Join-Path $OutputDir "server-diagnostic-$timestamp.json"

$remoteScript = @'
set -e
echo "## identity"
whoami
hostname
echo
echo "## system"
uname -a
cat /etc/os-release
lscpu
free -h
df -hT
echo
echo "## docker"
docker --version || true
docker compose version || true
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" || true
echo
echo "## ports"
ss -tulpen || true
echo
echo "## deploy_dirs"
ls -la /opt || true
ls -la /opt/apps || true
ls -la /opt/ai-agent || true
ls -la /srv || true
echo
echo "## deployed_projects"
find /opt /srv -maxdepth 3 -type f \( -name docker-compose.yml -o -name compose.yml -o -name Dockerfile -o -name .env.example \) 2>/dev/null || true
'@

Write-Host "Connecting to $UserName@$HostName (password prompt may appear, not stored)..." -ForegroundColor Cyan
$result = & $ssh "$UserName@$HostName" $remoteScript 2>&1
$result | Set-Content -Path $rawPath -Encoding UTF8

$payload = [ordered]@{
    generated_at = (Get-Date).ToString("s")
    host = $HostName
    user = $UserName
    raw_output_file = $rawPath
    output_preview = ($result | Select-Object -First 50)
}
$payload | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath -Encoding UTF8

Write-Host "Diagnostic raw output: $rawPath" -ForegroundColor Green
Write-Host "Diagnostic metadata: $jsonPath" -ForegroundColor Green
