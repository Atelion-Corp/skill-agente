[CmdletBinding()]
param(
    [string]$SkillsRoot = "skills",
    [string]$OutputPath = "contracts/skills-contracts.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-SkillDescription {
    param([string]$FilePath)
    $line = Get-Content -Path $FilePath | Where-Object { $_ -match "^description:\s*" } | Select-Object -First 1
    if (-not $line) { return "No description found" }
    return ($line -replace "^description:\s*", "").Trim()
}

function New-Contract {
    param(
        [string]$SkillName,
        [string]$Description
    )

    $network = $false
    $ssh = $false
    $docker = $false
    $filesystem = "read"

    if ($SkillName -match "docker|deploy|ops|pipeline|orquestador") {
        $docker = $true
    }
    if ($SkillName -match "deploy|ops|hermes|orquestador") {
        $filesystem = "write"
    }
    if ($SkillName -match "deploy|ops|ssh|orquestador") {
        $ssh = $true
    }
    if ($SkillName -match "mkt|seo|curator|firecrawl") {
        $network = $true
    }

    return [ordered]@{
        name = $SkillName
        version = "1.0.0"
        description = $Description
        input_schema = @{
            type = "object"
            additionalProperties = $true
        }
        output_schema = @{
            type = "object"
            additionalProperties = $true
        }
        permissions = @{
            filesystem = $filesystem
            network = $network
            ssh = $ssh
            docker = $docker
        }
        error_handling = @{
            retriable = $true
            max_retries = 2
        }
        telemetry = @{
            emit_duration_ms = $true
            emit_status = $true
            emit_warnings = $true
        }
    }
}

$skillDirs = Get-ChildItem -Path $SkillsRoot -Directory | Sort-Object Name
$contracts = @()

foreach ($dir in $skillDirs) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skillFile)) { continue }
    $description = Get-SkillDescription -FilePath $skillFile
    $contracts += New-Contract -SkillName $dir.Name -Description $description
}

$outDir = Split-Path -Parent $OutputPath
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}

$doc = [ordered]@{
    generated_at = (Get-Date).ToString("s")
    runtime = "openclaw"
    skills_count = $contracts.Count
    contracts = $contracts
}

$doc | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "Generated $OutputPath with $($contracts.Count) skill contracts." -ForegroundColor Green
