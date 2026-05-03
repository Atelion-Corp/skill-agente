[CmdletBinding()]
param(
    [string]$OutputHtml = "proyecto_resultado_skill/proyectos/server_diagnostic/admin-ops-console-template.html"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$html = @"
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Admin Ops Console</title>
<style>
body{margin:0;font-family:Segoe UI,Arial,sans-serif;background:#0a0f1a;color:#e9eef7}
.wrap{max-width:1200px;margin:0 auto;padding:24px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:14px}
.card{background:#151d2b;border:1px solid #2a3448;border-radius:12px;padding:14px}
h1{margin:0 0 8px} h2{margin:0 0 8px;font-size:16px}
.kpi{font-size:28px;font-weight:700}
.tag{display:inline-block;border:1px solid #35507a;border-radius:999px;padding:4px 10px;font-size:12px;color:#9bc2ff}
</style>
</head>
<body>
<div class="wrap">
  <h1>Admin Operations Console</h1>
  <div class="tag">Admin only</div>
  <div class="grid" style="margin-top:14px">
    <div class="card"><h2>CPU</h2><div class="kpi">--%</div></div>
    <div class="card"><h2>RAM</h2><div class="kpi">--%</div></div>
    <div class="card"><h2>Disco</h2><div class="kpi">--%</div></div>
    <div class="card"><h2>Docker activos</h2><div class="kpi">--</div></div>
  </div>
  <div class="grid" style="margin-top:14px">
    <div class="card"><h2>Validación Apps</h2><p>Estado individual/global con findings.</p></div>
    <div class="card"><h2>Deploy Manual Docker</h2><p>Upload, validate, deploy con gates de agentes.</p></div>
    <div class="card"><h2>Archivado Lifecycle</h2><p>30d compresión media, 180d compresión alta + cifrado opcional.</p></div>
    <div class="card"><h2>Secretos</h2><p>Inventario sin valores, rotación y auditoría.</p></div>
  </div>
</div>
</body>
</html>
"@

$outDir = Split-Path -Parent $OutputHtml
if (-not (Test-Path $outDir)) { New-Item -Path $outDir -ItemType Directory -Force | Out-Null }
$html | Set-Content -Path $OutputHtml -Encoding UTF8
Write-Host "Generated: $OutputHtml" -ForegroundColor Green
