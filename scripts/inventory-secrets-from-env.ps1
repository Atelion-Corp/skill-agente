[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AppsRoot,
    [string]$OutputFile = "proyecto_resultado_skill/proyectos/server_diagnostic/secrets-inventory.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$rows = @()
$envFiles = Get-ChildItem -Path $AppsRoot -Recurse -File -Filter ".env"
foreach ($file in $envFiles) {
    $project = Split-Path -Parent $file.FullName | Split-Path -Leaf
    $lines = Get-Content -Path $file.FullName
    foreach ($line in $lines) {
        if ($line -match '^\s*#' -or $line -notmatch '=') { continue }
        $key = ($line -split '=',2)[0].Trim()
        if (-not $key) { continue }
        $rows += [pscustomobject]@{
            project = $project
            env_file = $file.FullName
            secret_key = $key
            owner = "TBD"
            tenant = "TBD"
            rotation_days = "TBD"
            last_rotated_at = "TBD"
        }
    }
}

$outDir = Split-Path -Parent $OutputFile
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}
$rows | Sort-Object project, secret_key -Unique | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
Write-Host "Secret inventory created (keys only): $OutputFile" -ForegroundColor Green
