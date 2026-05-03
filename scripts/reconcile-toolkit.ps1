[CmdletBinding()]
param(
    [string]$Root = ".",
    [switch]$PruneGenerated
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Set-Location $Root

Write-Host "Reconciling toolkit structure..." -ForegroundColor Cyan

# Ensure expected directories exist
$dirs = @(
    "docs",
    "scripts",
    "skills",
    "contracts",
    "ops",
    "proyecto_resultado_skill/proyectos/server_diagnostic"
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -Path $d -ItemType Directory -Force | Out-Null
    }
}

# Remove stale guardian report names if requested
if ($PruneGenerated) {
    $stalePatterns = @(
        "proyecto_resultado_skill/proyectos/*/nurbit-guardian-report-*.json",
        "proyecto_resultado_skill/proyectos/*/abaddon-guardian-report-*.json"
    )
    foreach ($p in $stalePatterns) {
        Get-ChildItem -Path $p -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}

# Regenerate contracts and validate consistency
& pwsh -File ".\scripts\generate-skill-contracts.ps1"
& pwsh -File ".\scripts\validate-plugin.ps1"

Write-Host "Toolkit reconciled successfully." -ForegroundColor Green
