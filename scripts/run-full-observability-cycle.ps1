[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HostName,
    [string]$UserName = "diego-admin",
    [string]$AppsRoot = "/opt/apps",
    [string]$OutputDir = "proyecto_resultado_skill/proyectos/server_diagnostic"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$base = Split-Path -Parent $PSCommandPath

Write-Host "1) Snapshot de servidor..." -ForegroundColor Cyan
& (Join-Path $base "collect-ops-snapshot-ssh.ps1") `
    -HostName $HostName `
    -UserName $UserName `
    -OutputDir $OutputDir `
    -OutputFileName "ops-snapshot.json"

Write-Host "2) Validacion de apps..." -ForegroundColor Cyan
& (Join-Path $base "validate-all-apps.ps1") `
    -AppsRoot $AppsRoot `
    -OutputDir $OutputDir

Write-Host "3) Render dashboard..." -ForegroundColor Cyan
& (Join-Path $base "render-ops-overview-html.ps1") `
    -ValidationJson (Join-Path $OutputDir "apps-validation-report.json") `
    -SnapshotJson (Join-Path $OutputDir "ops-snapshot.json") `
    -OutputHtml (Join-Path $OutputDir "ops-overview.html")

Write-Host "Done. Artefacts:" -ForegroundColor Green
Write-Host "  - $(Join-Path $OutputDir "ops-snapshot.json")"
Write-Host "  - $(Join-Path $OutputDir "apps-validation-report.json")"
Write-Host "  - $(Join-Path $OutputDir "ops-overview.html")"
