[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Role,
    [Parameter(Mandatory = $true)]
    [string]$Action,
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,
    [string]$PolicyFile = "config/agent-permissions-policy.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Match-Pattern {
    param([string]$Path,[string]$Pattern)
    $escaped = [Regex]::Escape($Pattern).Replace('\*','.*')
    return $Path -match "^$escaped$"
}

$policyPath = if ([System.IO.Path]::IsPathRooted($PolicyFile)) { $PolicyFile } else { Join-Path (Get-Location) $PolicyFile }
if (-not (Test-Path $policyPath)) { throw "Policy file not found: $policyPath" }

$policy = Get-Content -Path $policyPath -Raw | ConvertFrom-Json
$rolePolicy = $policy.roles.$Role
if (-not $rolePolicy) { throw "Unknown role: $Role" }

if ($Action -notin @($rolePolicy.allowed_actions)) {
    throw "DENY: role '$Role' cannot execute action '$Action'."
}

$normalized = $TargetPath.Replace('\','/')
$matchedTags = @()
foreach ($entry in $policy.path_tags) {
    foreach ($pattern in $entry.patterns) {
        if (Match-Pattern -Path $normalized -Pattern $pattern) {
            $matchedTags += $entry.tag
            break
        }
    }
}
$matchedTags = @($matchedTags | Select-Object -Unique)
if (@($matchedTags).Count -eq 0) {
    throw "DENY: target path '$TargetPath' has no classified tag."
}

$allowed = @($rolePolicy.allowed_path_tags)
$intersect = @($matchedTags | Where-Object { $_ -in $allowed })
if (@($intersect).Count -eq 0) {
    throw "DENY: role '$Role' cannot act on path '$TargetPath'. tags=$($matchedTags -join ',')"
}

Write-Output "ALLOW: role=$Role action=$Action path=$TargetPath tags=$($intersect -join ',')"
