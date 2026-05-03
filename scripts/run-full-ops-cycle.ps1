[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$LocalBackupRoot = "$HOME\server_backups\colossus",
    [string]$WorkspaceRoot = "C:\Users\diego\Documents\Propio\skill_agente",
    [switch]$ApplyRemoteChanges
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Set-Location $WorkspaceRoot

Write-Host "Phase 1/8: Pull backup from server..." -ForegroundColor Cyan
& pwsh -File ".\scripts\pull-server-data.ps1" -HostName $HostName -UserName $UserName -LocalOutputDir $LocalBackupRoot
if ($LASTEXITCODE -ne 0) { throw "Backup phase failed." }

$latest = Get-ChildItem -Path $LocalBackupRoot -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $latest) { throw "No backup directory found in $LocalBackupRoot" }
$appsRoot = Join-Path $latest.FullName "opt\apps"
if (-not (Test-Path $appsRoot)) { throw "Apps root not found in backup: $appsRoot" }

Write-Host "Phase 2/8: Validate all apps..." -ForegroundColor Cyan
& pwsh -File ".\scripts\validate-all-apps.ps1" -AppsRoot $appsRoot
if ($LASTEXITCODE -ne 0) { throw "Apps validation failed." }

Write-Host "Phase 3/8: Enforce port policy (local backup copy)..." -ForegroundColor Cyan
& pwsh -File ".\scripts\enforce-port-policy.ps1" -AppsRoot $appsRoot -Apply
if ($LASTEXITCODE -ne 0) { throw "Port policy phase failed." }

Write-Host "Phase 4/8: Build secret inventory metadata..." -ForegroundColor Cyan
& pwsh -File ".\scripts\inventory-secrets-from-env.ps1" -AppsRoot $appsRoot
if ($LASTEXITCODE -ne 0) { throw "Secret inventory phase failed." }

Write-Host "Phase 5/8: Run stack guardian validations..." -ForegroundColor Cyan
$projects = @("nurbit", "servidor-atelion-project", "project", "project-respaldo")
foreach ($p in $projects) {
    $path = Join-Path $appsRoot $p
    if (Test-Path $path) {
        & pwsh -File ".\scripts\stack-guardian-validator.ps1" -ProjectPath $path -ProjectId $p
    }
}

Write-Host "Phase 6/8: Render operations overview..." -ForegroundColor Cyan
$valJson = Join-Path (Get-Location) "proyecto_resultado_skill\proyectos\server_diagnostic\apps-validation-report.json"
& pwsh -File ".\scripts\render-ops-overview-html.ps1" -ValidationJson $valJson
if ($LASTEXITCODE -ne 0) { throw "Ops overview rendering failed." }

Write-Host "Phase 7/10: Archive lifecycle dry-run (remote)..." -ForegroundColor Cyan
& pwsh -File ".\scripts\apply-archive-lifecycle-remote.ps1" -HostName $HostName -UserName $UserName

Write-Host "Phase 8/10: Render admin UX template..." -ForegroundColor Cyan
& pwsh -File ".\scripts\render-admin-ux-template.ps1"

Write-Host "Phase 9/10: Validate plugin consistency..." -ForegroundColor Cyan
& pwsh -File ".\scripts\generate-skill-contracts.ps1"
& pwsh -File ".\scripts\validate-plugin.ps1"
if ($LASTEXITCODE -ne 0) { throw "Plugin validation failed." }

Write-Host "Phase 10/10: Optional remote actions..." -ForegroundColor Cyan
if ($ApplyRemoteChanges) {
    & pwsh -File ".\scripts\rename-projects-remote.ps1" -HostName $HostName -UserName $UserName -Apply
    & pwsh -File ".\scripts\archive-and-stop-devtest-remote.ps1" -HostName $HostName -UserName $UserName
    Write-Host "Remote actions executed (rename + archive/stop dev-test)." -ForegroundColor Green
} else {
    Write-Host "Remote changes skipped. Re-run with -ApplyRemoteChanges to apply server actions." -ForegroundColor Yellow
}

Write-Host "Full ops cycle complete." -ForegroundColor Green
Write-Host "Latest backup analyzed: $($latest.FullName)" -ForegroundColor Green
