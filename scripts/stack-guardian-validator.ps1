[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,
    [switch]$AutoFix,
    [string]$ProjectId = "server_project"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Add-Finding {
    param(
        [System.Collections.Generic.List[object]]$List,
        [string]$Severity,
        [string]$Code,
        [string]$Message,
        [string]$Path = ""
    )
    $List.Add([pscustomobject]@{
        severity = $Severity
        code = $Code
        message = $Message
        path = $Path
    }) | Out-Null
}

$findings = New-Object 'System.Collections.Generic.List[object]'
$autofixes = New-Object 'System.Collections.Generic.List[object]'

if (-not (Test-Path $ProjectPath)) {
    throw "Project path not found: $ProjectPath"
}

$expectedPaths = @(
    "apps/backend/manage.py",
    "apps/frontend/package.json",
    "docker-compose.yml",
    "docker-compose.prod.yml",
    "docs/architecture.md",
    "docs/production-server-runbook.md",
    ".env.example"
)

foreach ($rel in $expectedPaths) {
    $abs = Join-Path $ProjectPath $rel
    if (-not (Test-Path $abs)) {
        Add-Finding -List $findings -Severity "high" -Code "missing_path" -Message "Missing expected path: $rel" -Path $abs
    }
}

$composeProd = Join-Path $ProjectPath "docker-compose.prod.yml"
if (Test-Path $composeProd) {
    $prod = Get-Content -Path $composeProd -Raw
    if ($prod -match '(?m)^\s*ports:\s*$') {
        Add-Finding -List $findings -Severity "medium" -Code "prod_ports_exposed" -Message "Review exposed ports in docker-compose.prod.yml (prod should expose only required entrypoints)." -Path $composeProd
    }
    if ($prod -notmatch 'restart:\s*always') {
        Add-Finding -List $findings -Severity "low" -Code "restart_policy" -Message "Prod compose should use restart: always." -Path $composeProd
    }
}

$envExample = Join-Path $ProjectPath ".env.example"
if (Test-Path $envExample) {
    $envContent = Get-Content -Path $envExample -Raw
    foreach ($required in @("DJANGO_SECRET_KEY","POSTGRES_PASSWORD","TENANT_BASE_DOMAIN")) {
        if ($envContent -notmatch "(?m)^$required=") {
            Add-Finding -List $findings -Severity "high" -Code "missing_env_key" -Message "Missing required env key in .env.example: $required" -Path $envExample
        }
    }
}

# Safe autofix: create docs placeholders if missing.
if ($AutoFix) {
    $docTargets = @(
        "docs/architecture.md",
        "docs/production-server-runbook.md",
        "docs/multitenancy.md",
        "docs/rbac.md"
    )
    foreach ($rel in $docTargets) {
        $abs = Join-Path $ProjectPath $rel
        if (-not (Test-Path $abs)) {
            $dir = Split-Path -Parent $abs
            if (-not (Test-Path $dir)) {
                New-Item -Path $dir -ItemType Directory -Force | Out-Null
            }
            @"
# Placeholder

This file was created by `stack-guardian-validator.ps1` autofix mode.
Please complete with project-specific production details.
"@ | Set-Content -Path $abs -Encoding UTF8
            $autofixes.Add([pscustomobject]@{
                type = "create_placeholder_doc"
                path = $abs
            }) | Out-Null
        }
    }
}

$reportDir = Join-Path (Get-Location) "proyecto_resultado_skill/proyectos/$ProjectId"
if (-not (Test-Path $reportDir)) {
    New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
}
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportPath = Join-Path $reportDir "stack-guardian-report-$stamp.json"
$contextLogPath = Join-Path $reportDir "ai-context-log.jsonl"

$report = [ordered]@{
    generated_at = (Get-Date).ToString("s")
    project_path = $ProjectPath
    findings_count = $findings.Count
    autofixes_count = $autofixes.Count
    findings = $findings
    autofixes = $autofixes
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportPath -Encoding UTF8

$contextRow = [ordered]@{
    ts = (Get-Date).ToString("s")
    skill = "stack-guardian"
    project_id = $ProjectId
    project_path = $ProjectPath
    findings_count = $findings.Count
    autofixes_count = $autofixes.Count
    report_file = $reportPath
}
($contextRow | ConvertTo-Json -Compress) | Add-Content -Path $contextLogPath

Write-Host "Validation report: $reportPath" -ForegroundColor Green
Write-Host "Context log updated: $contextLogPath" -ForegroundColor Green
