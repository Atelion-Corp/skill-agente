[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AppsRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$moves = @(
    @{ from = "servidor-atelion-project"; to = "server-atelion-project" },
    @{ from = "nurbit"; to = "server-nurbit" }
)

foreach ($m in $moves) {
    $src = Join-Path $AppsRoot $m.from
    $dst = Join-Path $AppsRoot $m.to
    if ((Test-Path $src) -and -not (Test-Path $dst)) {
        Move-Item -LiteralPath $src -Destination $dst
        Write-Host "Renamed: $($m.from) -> $($m.to)" -ForegroundColor Green
    } else {
        Write-Host "Skipped: $($m.from) (missing or destination exists)" -ForegroundColor Yellow
    }
}
