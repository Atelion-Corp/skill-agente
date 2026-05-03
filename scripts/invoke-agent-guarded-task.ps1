[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Role,
    [Parameter(Mandatory = $true)]
    [string]$Action,
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,
    [Parameter(Mandatory = $true)]
    [string]$Command,
    [string]$AuditLog = "proyecto_resultado_skill/proyectos/server_diagnostic/agent-permissions-audit.jsonl"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

try {
    $allow = & pwsh -File ".\scripts\authorize-agent-action.ps1" -Role $Role -Action $Action -TargetPath $TargetPath
    $status = "allow"
} catch {
    $allow = $_.Exception.Message
    $status = "deny"
}

$row = [ordered]@{
    ts = (Get-Date).ToString("s")
    role = $Role
    action = $Action
    target_path = $TargetPath
    status = $status
    message = $allow
    command = $Command
}

$auditPath = if ([System.IO.Path]::IsPathRooted($AuditLog)) { $AuditLog } else { Join-Path (Get-Location) $AuditLog }
$auditDir = Split-Path -Parent $auditPath
if (-not (Test-Path $auditDir)) { New-Item -Path $auditDir -ItemType Directory -Force | Out-Null }
($row | ConvertTo-Json -Compress) | Add-Content -Path $auditPath

if ($status -eq "deny") {
    throw $allow
}

Write-Host $allow -ForegroundColor Green
Invoke-Expression $Command
