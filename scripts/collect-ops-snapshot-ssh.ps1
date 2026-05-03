[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HostName,
    [string]$UserName = "diego-admin",
    [string]$OutputDir = "proyecto_resultado_skill/proyectos/server_diagnostic",
    [string]$OutputFileName = "ops-snapshot.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) {
    throw "OpenSSH client not found at $ssh"
}

if (-not (Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
}

$remote = @'
set -e
python3 - << "PY"
import json
import os
import re
import shlex
import subprocess
from datetime import datetime, timezone

def run(cmd):
    p = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return (p.stdout or "").strip(), (p.stderr or "").strip(), p.returncode

def safe(cmd, default=""):
    out, err, code = run(cmd)
    if code != 0:
        return default
    return out

def parse_percent(x):
    if x is None:
        return 0
    m = re.search(r"([0-9]+(?:\.[0-9]+)?)", str(x))
    if not m:
        return 0
    return float(m.group(1))

host = safe("hostname")
user = safe("whoami")
kernel = safe("uname -a")
os_pretty = safe("grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '\"'")
cpu_model = safe("lscpu | grep 'Model name' | sed 's/Model name:\\s*//'")
cpu_used = safe("top -bn1 | grep 'Cpu(s)' | sed -E 's/.*, *([0-9.]+) id.*/\\1/' | awk '{print 100 - $1}'", "0")

mem_line = safe("free -m | awk '/^Mem:/ {print $2\" \"$3\" \"$4}'", "0 0 0")
swap_line = safe("free -m | awk '/^Swap:/ {print $2\" \"$3\" \"$4}'", "0 0 0")
mem_total_mb, mem_used_mb, _ = [int(x) for x in mem_line.split()]
swap_total_mb, swap_used_mb, _ = [int(x) for x in swap_line.split()]
mem_used_pct = round((mem_used_mb / mem_total_mb) * 100, 2) if mem_total_mb else 0

df_root = safe("df -h / | awk 'NR==2 {print $5\" \"$3\" \"$2\" \"$4}'", "0% - - -").split()
root_used_pct = parse_percent(df_root[0] if len(df_root) > 0 else "0")

docker_version = safe("docker --version", "N/A")
compose_version = safe("docker compose version", "N/A")

containers = []
docker_ps = safe("docker ps --format '{{.Names}}|{{.Image}}|{{.Status}}|{{.Ports}}'")
for line in docker_ps.splitlines():
    if not line.strip():
        continue
    parts = line.split("|")
    while len(parts) < 4:
        parts.append("")
    containers.append({
        "name": parts[0],
        "image": parts[1],
        "status": parts[2],
        "ports": parts[3]
    })

disks = []
df_all = safe("df -hT --output=target,fstype,size,used,avail,pcent")
for i, line in enumerate(df_all.splitlines()):
    if i == 0:
        continue
    cols = line.split()
    if len(cols) < 6:
        continue
    disks.append({
        "mount": cols[0],
        "fs": cols[1],
        "size": cols[2],
        "used": cols[3],
        "avail": cols[4],
        "use_percent": cols[5]
    })

ports = []
ss_lines = safe("ss -tulpenH").splitlines()
for line in ss_lines[:120]:
    cols = line.split()
    if len(cols) < 6:
        continue
    proto = cols[0]
    local = cols[4]
    proc = cols[-1]
    ports.append({"proto": proto, "local": local, "process": proc[:200]})

top_cpu = []
cpu_lines = safe("ps -eo pid,user,pcpu,pmem,args --sort=-pcpu | head -n 8").splitlines()[1:]
for line in cpu_lines:
    m = re.split(r"\s+", line.strip(), maxsplit=4)
    if len(m) < 5:
        continue
    top_cpu.append({"pid": m[0], "user": m[1], "cpu": m[2], "mem": m[3], "command": m[4]})

top_mem = []
mem_lines = safe("ps -eo pid,user,pcpu,pmem,args --sort=-pmem | head -n 8").splitlines()[1:]
for line in mem_lines:
    m = re.split(r"\s+", line.strip(), maxsplit=4)
    if len(m) < 5:
        continue
    top_mem.append({"pid": m[0], "user": m[1], "cpu": m[2], "mem": m[3], "command": m[4]})

log_paths = [
    ("docs_autocomplete", "/var/log/colossus/docs_autocomplete.log"),
    ("validate_apps", "/var/log/colossus/validate_apps.log"),
    ("archive_lifecycle", "/var/log/colossus/archive_lifecycle.log"),
]
logs = []
for name, path in log_paths:
    if os.path.exists(path):
        tail = safe(f"tail -n 3 {shlex.quote(path)}")
        logs.append({"name": name, "path": path, "last_lines": tail})
    else:
        logs.append({"name": name, "path": path, "last_lines": "missing"})

snapshot = {
    "generated_at": datetime.now(timezone.utc).isoformat(),
    "identity": {"user": user, "hostname": host},
    "system": {
        "kernel": kernel,
        "os_pretty_name": os_pretty,
        "cpu_model": cpu_model,
        "mem_total": f"{mem_total_mb} MB",
        "mem_used": f"{mem_used_mb} MB",
        "swap_total": f"{swap_total_mb} MB",
        "swap_used": f"{swap_used_mb} MB"
    },
    "kpis": {
        "cpu_used_percent": round(float(cpu_used), 2) if cpu_used else 0,
        "mem_used_percent": mem_used_pct,
        "root_disk_used_percent": root_used_pct,
        "running_containers": len(containers),
        "listening_ports": len(ports)
    },
    "docker": {
        "docker_version": docker_version,
        "compose_version": compose_version,
        "containers": containers
    },
    "disks": disks,
    "network": {"listening_ports": ports},
    "processes": {"top_cpu": top_cpu, "top_mem": top_mem},
    "logs": logs
}
print(json.dumps(snapshot, ensure_ascii=False))
PY
'@

Write-Host "Collecting ops snapshot from $UserName@$HostName..." -ForegroundColor Cyan
$raw = & $ssh "$UserName@$HostName" $remote 2>&1

if ($LASTEXITCODE -ne 0) {
    throw "SSH snapshot failed: $raw"
}

$outPath = Join-Path $OutputDir $OutputFileName
$rawText = ($raw | Out-String).Trim()
$rawText | Set-Content -Path $outPath -Encoding UTF8
Write-Host "Snapshot JSON: $outPath" -ForegroundColor Green
