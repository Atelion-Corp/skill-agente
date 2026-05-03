[CmdletBinding()]
param(
    [string]$ValidationJson,
    [string]$SnapshotJson,
    [string]$OutputHtml = "proyecto_resultado_skill/proyectos/server_diagnostic/ops-overview.html"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $ValidationJson -and -not $SnapshotJson) {
    throw "Provide at least one input: -ValidationJson or -SnapshotJson"
}

$validationRows = @()
if ($ValidationJson -and (Test-Path $ValidationJson)) {
    $validationRows = Get-Content -Path $ValidationJson -Raw | ConvertFrom-Json
}

$snapshot = $null
if ($SnapshotJson -and (Test-Path $SnapshotJson)) {
    $snapshot = Get-Content -Path $SnapshotJson -Raw | ConvertFrom-Json
}

$esc = [System.Net.WebUtility]

$validationTrs = foreach ($r in $validationRows) {
    $cls = if ($r.status -eq "pass") { "ok" } else { "warn" }
    "<tr class='$cls'><td>$($esc::HtmlEncode([string]$r.app))</td><td>$($esc::HtmlEncode([string]$r.status))</td><td>$($r.findings_count)</td><td>$($esc::HtmlEncode([string]$r.findings))</td></tr>"
}

function New-Row([string]$k, [string]$v) {
    return "<tr><td>$($esc::HtmlEncode($k))</td><td>$($esc::HtmlEncode($v))</td></tr>"
}

$kpiCpu = "-"
$kpiMem = "-"
$kpiDisk = "-"
$kpiContainers = "-"
$kpiPorts = "-"

$sysRows = @()
$diskRows = @()
$containerRows = @()
$portRows = @()
$processRows = @()
$logRows = @()

if ($snapshot) {
    if ($snapshot.kpis) {
        $kpiCpu = [string]$snapshot.kpis.cpu_used_percent
        $kpiMem = [string]$snapshot.kpis.mem_used_percent
        $kpiDisk = [string]$snapshot.kpis.root_disk_used_percent
        $kpiContainers = [string]$snapshot.kpis.running_containers
        $kpiPorts = [string]$snapshot.kpis.listening_ports
    }

    $sysRows += New-Row "Host" ([string]$snapshot.identity.hostname)
    $sysRows += New-Row "Usuario" ([string]$snapshot.identity.user)
    $sysRows += New-Row "Kernel" ([string]$snapshot.system.kernel)
    $sysRows += New-Row "OS" ([string]$snapshot.system.os_pretty_name)
    $sysRows += New-Row "CPU" ([string]$snapshot.system.cpu_model)
    $sysRows += New-Row "RAM total" ([string]$snapshot.system.mem_total)
    $sysRows += New-Row "RAM usada" ([string]$snapshot.system.mem_used)
    $sysRows += New-Row "Swap total" ([string]$snapshot.system.swap_total)
    $sysRows += New-Row "Swap usada" ([string]$snapshot.system.swap_used)
    $sysRows += New-Row "Docker" ([string]$snapshot.docker.docker_version)
    $sysRows += New-Row "Compose" ([string]$snapshot.docker.compose_version)

    foreach ($d in @($snapshot.disks)) {
        $diskRows += "<tr><td>$($esc::HtmlEncode([string]$d.mount))</td><td>$($esc::HtmlEncode([string]$d.fs))</td><td>$($esc::HtmlEncode([string]$d.size))</td><td>$($esc::HtmlEncode([string]$d.used))</td><td>$($esc::HtmlEncode([string]$d.avail))</td><td>$($esc::HtmlEncode([string]$d.use_percent))</td></tr>"
    }
    foreach ($c in @($snapshot.docker.containers)) {
        $containerRows += "<tr><td>$($esc::HtmlEncode([string]$c.name))</td><td>$($esc::HtmlEncode([string]$c.image))</td><td>$($esc::HtmlEncode([string]$c.status))</td><td>$($esc::HtmlEncode([string]$c.ports))</td></tr>"
    }
    foreach ($p in @($snapshot.network.listening_ports)) {
        $portRows += "<tr><td>$($esc::HtmlEncode([string]$p.proto))</td><td>$($esc::HtmlEncode([string]$p.local))</td><td>$($esc::HtmlEncode([string]$p.process))</td></tr>"
    }
    foreach ($p in @($snapshot.processes.top_cpu)) {
        $processRows += "<tr><td>CPU</td><td>$($esc::HtmlEncode([string]$p.pid))</td><td>$($esc::HtmlEncode([string]$p.user))</td><td>$($esc::HtmlEncode([string]$p.cpu))</td><td>$($esc::HtmlEncode([string]$p.mem))</td><td>$($esc::HtmlEncode([string]$p.command))</td></tr>"
    }
    foreach ($p in @($snapshot.processes.top_mem)) {
        $processRows += "<tr><td>MEM</td><td>$($esc::HtmlEncode([string]$p.pid))</td><td>$($esc::HtmlEncode([string]$p.user))</td><td>$($esc::HtmlEncode([string]$p.cpu))</td><td>$($esc::HtmlEncode([string]$p.mem))</td><td>$($esc::HtmlEncode([string]$p.command))</td></tr>"
    }
    foreach ($l in @($snapshot.logs)) {
        $logRows += "<tr><td>$($esc::HtmlEncode([string]$l.name))</td><td>$($esc::HtmlEncode([string]$l.path))</td><td>$($esc::HtmlEncode([string]$l.last_lines))</td></tr>"
    }
}

$html = @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Colossus Ops Console</title>
<style>
*{box-sizing:border-box}
body{font-family:Segoe UI,Arial,sans-serif;background:#0a0a0a;color:#d4d4d4;margin:0;padding:16px}
h1,h2{margin:0}
h1{font-size:26px;letter-spacing:.4px}
h2{font-size:15px;color:#a7a7a7;margin-bottom:10px;text-transform:uppercase;letter-spacing:.8px}
.meta{color:#8a8a8a;margin:10px 0 16px}
.grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:10px;margin-bottom:14px}
.kpi{background:#131313;border:1px solid #242424;border-radius:8px;padding:12px}
.kpi .v{font-size:24px;color:#e7e7e7;font-weight:700}
.kpi .l{font-size:12px;color:#8f8f8f}
.panel{background:#121212;border:1px solid #232323;border-radius:8px;padding:12px;margin-bottom:12px}
table{width:100%;border-collapse:collapse}
th,td{border:1px solid #272727;padding:8px;text-align:left;font-size:12px;vertical-align:top}
th{background:#191919;color:#bdbdbd}
.ok td{background:#112217}
.warn td{background:#2a1d1d}
.charts{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px}
.bar{height:10px;background:#1f1f1f;border-radius:99px;overflow:hidden}
.bar > span{display:block;height:100%;background:#4c7a5b}
.actions code{display:block;background:#101010;border:1px solid #262626;padding:6px;border-radius:6px;margin-top:6px;white-space:pre-wrap}
@media (max-width:1200px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}.charts{grid-template-columns:1fr}}
</style>
</head>
<body>
<h1>Colossus Operations Console</h1>
<div class="meta">Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</div>

<div class="grid">
  <div class="kpi"><div class="v">$kpiCpu%</div><div class="l">CPU usado</div></div>
  <div class="kpi"><div class="v">$kpiMem%</div><div class="l">RAM usada</div></div>
  <div class="kpi"><div class="v">$kpiDisk%</div><div class="l">Disco / usado</div></div>
  <div class="kpi"><div class="v">$kpiContainers</div><div class="l">Contenedores running</div></div>
  <div class="kpi"><div class="v">$kpiPorts</div><div class="l">Puertos escuchando</div></div>
</div>

<div class="panel charts">
  <div>
    <h2>CPU</h2>
    <div class="bar"><span style="width:$kpiCpu%"></span></div>
  </div>
  <div>
    <h2>RAM</h2>
    <div class="bar"><span style="width:$kpiMem%"></span></div>
  </div>
  <div>
    <h2>DISCO ROOT</h2>
    <div class="bar"><span style="width:$kpiDisk%"></span></div>
  </div>
</div>

<div class="panel">
  <h2>Sistema</h2>
  <table><tbody>$(($sysRows -join "`n"))</tbody></table>
</div>

<div class="panel">
  <h2>Particiones y Almacenamiento</h2>
  <table>
    <thead><tr><th>Mount</th><th>FS</th><th>Size</th><th>Used</th><th>Avail</th><th>Use%</th></tr></thead>
    <tbody>$(($diskRows -join "`n"))</tbody>
  </table>
</div>

<div class="panel">
  <h2>Docker Containers</h2>
  <table>
    <thead><tr><th>Name</th><th>Image</th><th>Status</th><th>Ports</th></tr></thead>
    <tbody>$(($containerRows -join "`n"))</tbody>
  </table>
</div>

<div class="panel">
  <h2>Puertos en Uso</h2>
  <table>
    <thead><tr><th>Proto</th><th>Local</th><th>Process</th></tr></thead>
    <tbody>$(($portRows -join "`n"))</tbody>
  </table>
</div>

<div class="panel">
  <h2>Top Procesos (CPU y RAM)</h2>
  <table>
    <thead><tr><th>Type</th><th>PID</th><th>User</th><th>CPU%</th><th>MEM%</th><th>Command</th></tr></thead>
    <tbody>$(($processRows -join "`n"))</tbody>
  </table>
</div>

<div class="panel">
  <h2>Apps Validation</h2>
  <table>
    <thead><tr><th>App</th><th>Status</th><th>Findings</th><th>Details</th></tr></thead>
    <tbody>$(($validationTrs -join "`n"))</tbody>
  </table>
</div>

<div class="panel">
  <h2>Logs Configurados</h2>
  <table>
    <thead><tr><th>Name</th><th>Path</th><th>Last lines</th></tr></thead>
    <tbody>$(($logRows -join "`n"))</tbody>
  </table>
</div>

<div class="panel actions">
  <h2>Acciones Controladas (Manual Admin)</h2>
  <code>docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'</code>
  <code>cd /opt/apps/server-atelion-project && docker compose stop</code>
  <code>cd /opt/apps/server-atelion-project && docker compose up -d</code>
  <code>tail -f /var/log/colossus/validate_apps.log</code>
  <code>tail -f /var/log/colossus/archive_lifecycle.log</code>
</div>
</body>
</html>
"@

$outDir = Split-Path -Parent $OutputHtml
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}
$html | Set-Content -Path $OutputHtml -Encoding UTF8
Write-Host "Generated: $OutputHtml" -ForegroundColor Green
