[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )
    if (-not $Condition) {
        throw $Message
    }
}

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$claude = Get-Content .claude-plugin/plugin.json -Raw | ConvertFrom-Json
$codex = Get-Content .codex-plugin/plugin.json -Raw | ConvertFrom-Json

Assert-True ($claude.name -eq $codex.name) "Plugin name mismatch between Claude and Codex manifests."
Assert-True ($claude.version -eq $codex.version) "Plugin version mismatch between Claude and Codex manifests."

$claudeSkills = @($claude.skills)
$codexSkills = @($codex.skills)

foreach ($s in $claudeSkills) {
    Assert-True (Test-Path $s) "Missing skill path declared in Claude manifest: $s"
}
foreach ($s in $codexSkills) {
    Assert-True (Test-Path $s) "Missing skill path declared in Codex manifest: $s"
}

$missingInCodex = $claudeSkills | Where-Object { $_ -notin $codexSkills }
$missingInClaude = $codexSkills | Where-Object { $_ -notin $claudeSkills }

Assert-True ($missingInCodex.Count -eq 0) "Skills missing in Codex manifest: $($missingInCodex -join ', ')"
Assert-True ($missingInClaude.Count -eq 0) "Skills missing in Claude manifest: $($missingInClaude -join ', ')"

Write-Host "Validation OK: manifests synchronized and skill paths exist." -ForegroundColor Green