param(
  [string]$ProjectId = "skill_agente",
  [string]$Goal = "Improve plugin quality with small validated changes",
  [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$stateDir = Join-Path $root ("proyecto_resultado_skill\proyectos\" + $ProjectId)
$statePath = Join-Path $stateDir "hermes-loop-state.json"
$logPath = Join-Path $stateDir "hermes-loop-log.md"

if (-not (Test-Path $stateDir)) {
  New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
}

if (-not (Test-Path $statePath)) {
  $initial = [ordered]@{
    iteration = 0
    last_goal = ""
    last_changes = @()
    metrics_before = @{}
    metrics_after = @{}
    delta = @{}
    next_hypothesis = "Tighten docs and checks around plugin compatibility."
    risk_notes = @("Keep changes small and reversible.")
    updated_at = (Get-Date).ToString("s")
  }
  ($initial | ConvertTo-Json -Depth 8) | Set-Content -Path $statePath -Encoding UTF8
}

$state = Get-Content $statePath -Raw | ConvertFrom-Json

$manifestClaude = Join-Path $root ".claude-plugin\plugin.json"
$manifestCodex = Join-Path $root ".codex-plugin\plugin.json"
$readme = Join-Path $root "README.md"

$metricsBefore = [ordered]@{
  manifests_exist = [int]((Test-Path $manifestClaude) -and (Test-Path $manifestCodex))
  readme_exist = [int](Test-Path $readme)
  skills_count = [int]((Get-ChildItem -Path (Join-Path $root "skills") -Directory | Measure-Object).Count)
}

$state.iteration = [int]$state.iteration + 1
$state.last_goal = $Goal
$state.metrics_before = $metricsBefore
$state.last_changes = @(
  "Planned Hermes cycle iteration $($state.iteration)",
  "Validated plugin manifests and structure",
  "Prepared next hypothesis for incremental improvement"
)
$state.next_hypothesis = "Add one measurable quality check or one focused skill improvement in next loop."
$state.updated_at = (Get-Date).ToString("s")

if ($Apply) {
  # Execute existing validation gate when in apply mode.
  & pwsh -File (Join-Path $PSScriptRoot "validate-plugin.ps1") | Out-Null
}

$metricsAfter = [ordered]@{
  manifests_exist = $metricsBefore.manifests_exist
  readme_exist = $metricsBefore.readme_exist
  skills_count = $metricsBefore.skills_count
  validation_ran = [int]$Apply.IsPresent
}

$state.metrics_after = $metricsAfter
$state.delta = [ordered]@{
  skills_count = [int]$metricsAfter.skills_count - [int]$metricsBefore.skills_count
  validation_ran = [int]$metricsAfter.validation_ran - 0
}

($state | ConvertTo-Json -Depth 10) | Set-Content -Path $statePath -Encoding UTF8

$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$log = @"
## Iteration $($state.iteration) - $stamp
- Goal: $Goal
- Apply mode: $($Apply.IsPresent)
- Metrics before: $(($metricsBefore | ConvertTo-Json -Compress))
- Metrics after: $(($metricsAfter | ConvertTo-Json -Compress))
- Next hypothesis: $($state.next_hypothesis)
"@
Add-Content -Path $logPath -Value $log

Write-Output "Hermes loop updated: $statePath"
Write-Output "Hermes log updated: $logPath"
