[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AppsRoot,
    [string]$OutputDir = "proyecto_resultado_skill/proyectos/server_diagnostic"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-Exists($path) { return Test-Path $path }

$apps = Get-ChildItem -Path $AppsRoot -Directory | Sort-Object Name
$rows = @()

foreach ($app in $apps) {
    if ($app.Name -eq "backups") { continue }
    $base = $app.FullName
    $compose = Join-Path $base "docker-compose.yml"
    $composeProd = Join-Path $base "docker-compose.prod.yml"
    $envExample = Join-Path $base ".env.example"
    $backendA = Join-Path $base "apps/backend/manage.py"
    $backendB = Join-Path $base "backend/manage.py"
    $frontendA = Join-Path $base "apps/frontend/package.json"
    $frontendB = Join-Path $base "frontend/package.json"

    $findings = @()
    if (-not (Test-Exists $compose)) { $findings += "missing docker-compose.yml" }
    if (-not (Test-Exists $composeProd)) { $findings += "missing docker-compose.prod.yml" }
    if (-not (Test-Exists $envExample)) { $findings += "missing .env.example" }
    if (-not ((Test-Exists $backendA) -or (Test-Exists $backendB))) { $findings += "backend not detected" }
    if (-not ((Test-Exists $frontendA) -or (Test-Exists $frontendB))) { $findings += "frontend not detected" }

    $status = if ($findings.Count -eq 0) { "pass" } else { "warn" }
    $rows += [pscustomobject]@{
        app = $app.Name
        status = $status
        findings_count = $findings.Count
        findings = ($findings -join "; ")
    }
}

if (-not (Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
}
$json = Join-Path $OutputDir "apps-validation-report.json"
$csv = Join-Path $OutputDir "apps-validation-report.csv"
$rows | ConvertTo-Json -Depth 5 | Set-Content -Path $json -Encoding UTF8
$rows | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8
Write-Host "Validation JSON: $json" -ForegroundColor Green
Write-Host "Validation CSV:  $csv" -ForegroundColor Green
