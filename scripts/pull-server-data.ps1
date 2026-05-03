[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteArchive = "/tmp/colossus_export_apps.tgz",
    [string]$LocalOutputDir = "$HOME\server_backups\colossus",
    [switch]$IncludeEtc,
    [switch]$UseSudo
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
$scp = "C:\Windows\System32\OpenSSH\scp.exe"

if (-not (Test-Path $ssh)) { throw "No se encontró ssh.exe en $ssh" }
if (-not (Test-Path $scp)) { throw "No se encontró scp.exe en $scp" }

if (-not (Test-Path $LocalOutputDir)) {
    New-Item -Path $LocalOutputDir -ItemType Directory -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$localArchive = Join-Path $LocalOutputDir "colossus_export_$timestamp.tgz"
$extractDir = Join-Path $LocalOutputDir "colossus_export_$timestamp"

$paths = @("/opt/apps")
if ($IncludeEtc) {
    $paths += "/etc/nginx"
    $paths += "/etc/systemd/system"
}
$pathList = $paths -join " "
$tarCmd = "tar -czf $RemoteArchive $pathList"
if ($UseSudo) {
    $tarCmd = "sudo $tarCmd"
}

Write-Host "Creando archivo en servidor (puede pedir clave SSH, no se guarda)..." -ForegroundColor Cyan
$null = & $ssh "$UserName@$HostName" $tarCmd
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo crear el archivo en el servidor. Si necesita permisos root, reintente con -UseSudo y sesión con TTY interactiva."
}

Write-Host "Descargando archivo a PC..." -ForegroundColor Cyan
$null = & $scp "$UserName@$HostName`:$RemoteArchive" "$localArchive"
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $localArchive)) {
    throw "No se pudo descargar el archivo remoto: $RemoteArchive"
}

Write-Host "Extrayendo archivo local..." -ForegroundColor Cyan
if (-not (Test-Path $extractDir)) {
    New-Item -Path $extractDir -ItemType Directory -Force | Out-Null
}
tar -xzf "$localArchive" -C "$extractDir"
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo extraer el archivo local: $localArchive"
}

Write-Host "Limpieza de archivo temporal remoto..." -ForegroundColor Cyan
$null = & $ssh "$UserName@$HostName" "rm -f $RemoteArchive"

Write-Host "Backup local listo:" -ForegroundColor Green
Write-Host "  Archivo: $localArchive" -ForegroundColor Green
Write-Host "  Carpeta: $extractDir" -ForegroundColor Green
