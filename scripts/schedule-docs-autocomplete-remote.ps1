[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteSkillRoot = "/opt/apps/server-atelion-project/skill_agente"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }

$cronLine = "15 */6 * * * /usr/bin/pwsh -File $RemoteSkillRoot/scripts/docs-autocomplete.ps1 -ProjectId server_diagnostic -OutputDoc $RemoteSkillRoot/docs/estado-operativo-autocompletado.md >> /opt/apps/backups/docs_autocomplete.log 2>&1"

$remote = @"
set -e
tmpf=\$(mktemp)
crontab -l > \$tmpf 2>/dev/null || true
grep -F "$cronLine" \$tmpf >/dev/null || echo "$cronLine" >> \$tmpf
crontab \$tmpf
rm -f \$tmpf
echo "CRON_UPDATED"
"@

& $ssh "$UserName@$HostName" $remote
if ($LASTEXITCODE -ne 0) { throw "Failed to schedule remote docs autocomplete." }
Write-Host "Remote docs-autocomplete schedule installed (every 6h)." -ForegroundColor Green
