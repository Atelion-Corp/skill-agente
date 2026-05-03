[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AppsRoot,
    [string]$PolicyFile = "ops/port-policy.json",
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-NextEvenPort {
    param([int]$Start, [int]$Step, [int]$Index)
    return $Start + ($Step * $Index)
}

function Replace-FirstPortInCompose {
    param(
        [string]$FilePath,
        [int]$Port
    )
    $content = Get-Content -Path $FilePath -Raw
    $pattern = '(?m)^(\s*-\s*")(\d+):(\d+)(".*)$'
    if ($content -notmatch $pattern) {
        return $null
    }
    $updated = [System.Text.RegularExpressions.Regex]::Replace(
        $content,
        $pattern,
        ('$1' + $Port + ':$3$4'),
        1
    )
    return $updated
}

$policyPath = if ([System.IO.Path]::IsPathRooted($PolicyFile)) { $PolicyFile } else { Join-Path (Get-Location) $PolicyFile }
$policy = Get-Content -Path $policyPath -Raw | ConvertFrom-Json

$prodProjects = @($policy.prod.projects)
$prodStart = [int]$policy.prod.start_port
$prodStep = [int]$policy.prod.step
$devStart = [int]$policy.dev_test.start_port
$devStep = [int]$policy.dev_test.step

$report = @()

for ($i = 0; $i -lt $prodProjects.Count; $i++) {
    $project = $prodProjects[$i]
    $port = Get-NextEvenPort -Start $prodStart -Step $prodStep -Index $i
    $composePath = Join-Path (Join-Path $AppsRoot $project) "docker-compose.prod.yml"
    if (-not (Test-Path $composePath)) {
        $report += [pscustomobject]@{
            project = $project
            mode = "prod"
            status = "missing_compose"
            expected_port = $port
            file = $composePath
        }
        continue
    }
    $updated = Replace-FirstPortInCompose -FilePath $composePath -Port $port
    if ($null -eq $updated) {
        $report += [pscustomobject]@{
            project = $project
            mode = "prod"
            status = "no_port_line_found"
            expected_port = $port
            file = $composePath
        }
        continue
    }
    if ($Apply) {
        Set-Content -Path $composePath -Value $updated -Encoding UTF8
    }
    $report += [pscustomobject]@{
        project = $project
        mode = "prod"
        status = $(if ($Apply) { "updated" } else { "planned" })
        expected_port = $port
        file = $composePath
    }
}

$devCandidates = Get-ChildItem -Path $AppsRoot -Directory | Where-Object { $_.Name -notin $prodProjects } | Sort-Object Name
for ($j = 0; $j -lt $devCandidates.Count; $j++) {
    $project = $devCandidates[$j].Name
    $port = Get-NextEvenPort -Start $devStart -Step $devStep -Index $j
    $composePath = Join-Path $devCandidates[$j].FullName "docker-compose.yml"
    if (-not (Test-Path $composePath)) { continue }
    $report += [pscustomobject]@{
        project = $project
        mode = "dev_test"
        status = "reserved"
        expected_port = $port
        file = $composePath
    }
}

$outDir = Join-Path (Get-Location) "proyecto_resultado_skill/proyectos/server_diagnostic"
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}
$outPath = Join-Path $outDir "port-policy-report.json"
$report | ConvertTo-Json -Depth 6 | Set-Content -Path $outPath -Encoding UTF8
Write-Host "Port policy report: $outPath" -ForegroundColor Green
if (-not $Apply) {
    Write-Host "Dry run completed. Use -Apply to write prod port changes." -ForegroundColor Yellow
}
