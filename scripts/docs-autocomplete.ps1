[CmdletBinding()]
param(
    [string]$ProjectId = "server_diagnostic",
    [string]$OutputDoc = "docs/estado-operativo-autocompletado.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$base = Join-Path (Get-Location) "proyecto_resultado_skill/proyectos/$ProjectId"
$valJson = Join-Path $base "apps-validation-report.json"
$portJson = Join-Path $base "port-policy-report.json"
$opsHtml = Join-Path $base "ops-overview.html"
$lines = @()

$lines += "# Estado Operativo Autocompletado"
$lines += ""
$lines += "Generado: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += ""

if (Test-Path $valJson) {
    $data = Get-Content $valJson -Raw | ConvertFrom-Json
    $total = @($data).Count
    $warn = @($data | Where-Object { $_.status -ne "pass" }).Count
    $lines += "## Validación de apps"
    $lines += "- Total apps evaluadas: $total"
    $lines += "- Apps con alertas: $warn"
    $lines += ""
}

if (Test-Path $portJson) {
    $ports = Get-Content $portJson -Raw | ConvertFrom-Json
    $prod = @($ports | Where-Object { $_.mode -eq "prod" }).Count
    $dev = @($ports | Where-Object { $_.mode -eq "dev_test" }).Count
    $lines += "## Política de puertos"
    $lines += "- Entradas prod: $prod"
    $lines += "- Entradas dev/test: $dev"
    $lines += ""
}

$lines += "## Artefactos relacionados"
$lines += ('- Validacion apps: ' + $valJson)
$lines += ('- Politica puertos: ' + $portJson)
$lines += ('- Vista visual ops: ' + $opsHtml)
$lines += ""
$lines += "## Próximas mejoras sugeridas"
$lines += "- Añadir healthchecks obligatorios por servicio."
$lines += "- Integrar alertas Grafana por restart loops."
$lines += "- Consolidar naming final de apps en servidor."

$outPath = if ([System.IO.Path]::IsPathRooted($OutputDoc)) { $OutputDoc } else { Join-Path (Get-Location) $OutputDoc }
$outDir = Split-Path -Parent $outPath
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory -Force | Out-Null }
$lines -join "`r`n" | Set-Content -Path $outPath -Encoding UTF8
Write-Host "Autocompleted doc: $outPath" -ForegroundColor Green
