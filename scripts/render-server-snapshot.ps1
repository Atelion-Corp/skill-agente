[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DiagnosticTextFile,
    [string]$OutputHtml = "proyecto_resultado_skill/proyectos/server_diagnostic/server_snapshot.html"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path $DiagnosticTextFile)) {
    throw "Diagnostic file not found: $DiagnosticTextFile"
}

$content = Get-Content -Path $DiagnosticTextFile -Raw
$escaped = [System.Net.WebUtility]::HtmlEncode($content)

$title = "Server Snapshot - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>$title</title>
  <style>
    :root { --bg:#0e1116; --card:#151a22; --text:#e8eef8; --muted:#9db0c7; --line:#2a3240; --acc:#6fe3ff; }
    body { margin:0; font-family: "IBM Plex Sans", "Segoe UI", sans-serif; background:linear-gradient(180deg,#0b0e14,#111826); color:var(--text); }
    .wrap { max-width:1100px; margin:0 auto; padding:24px; }
    .card { background:var(--card); border:1px solid var(--line); border-radius:14px; padding:20px; box-shadow:0 10px 30px rgba(0,0,0,.25); }
    h1 { margin:0 0 8px; font-size:28px; letter-spacing:.2px; }
    p { color:var(--muted); margin:0 0 16px; }
    pre { white-space:pre-wrap; word-break:break-word; font-family:"Cascadia Code","Consolas",monospace; font-size:13px; line-height:1.45; }
    .badge { display:inline-block; margin:0 8px 12px 0; padding:6px 10px; border:1px solid var(--line); border-radius:999px; color:var(--acc); }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h1>Server Snapshot</h1>
      <p>Generated from non-destructive SSH diagnostics.</p>
      <div class="badge">OpenClaw-first</div>
      <div class="badge">Read-only inventory</div>
      <div class="badge">No secrets stored</div>
      <pre>$escaped</pre>
    </div>
  </div>
</body>
</html>
"@

$outDir = Split-Path -Parent $OutputHtml
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}
$html | Set-Content -Path $OutputHtml -Encoding UTF8
Write-Host "Generated snapshot: $OutputHtml" -ForegroundColor Green
