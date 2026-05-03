[CmdletBinding()]
param(
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$RemoteAppsRoot = "/opt/apps",
    [string[]]$ProdProjects = @("server-atelion-project", "server-nurbit"),
    [string]$RemoteArchiveRoot = "/opt/apps/backups/devtest_archives"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ssh = "C:\Windows\System32\OpenSSH\ssh.exe"
if (-not (Test-Path $ssh)) { throw "ssh.exe not found." }

$prodList = ($ProdProjects | ForEach-Object { "'$_'" }) -join ","
$remote = @"
set -e
mkdir -p $RemoteArchiveRoot
cd $RemoteAppsRoot
for d in */ ; do
  name=\${d%/}
  case ",$prodList," in
    *,"\$name",*) continue ;;
  esac
  if [ -f "\$name/docker-compose.yml" ]; then
    ts=\$(date +%Y%m%d_%H%M%S)
    mkdir -p "$RemoteArchiveRoot/\$name"
    docker compose -f "\$name/docker-compose.yml" logs --no-color > "$RemoteArchiveRoot/\$name/logs_\$ts.txt" || true
    tar -czf "$RemoteArchiveRoot/\$name/project_\$ts.tgz" -C "$RemoteAppsRoot" "\$name" || true
    docker compose -f "\$name/docker-compose.yml" down || true
  fi
done
echo "ARCHIVE_STOP_DONE"
"@

& $ssh "$UserName@$HostName" $remote
if ($LASTEXITCODE -ne 0) {
    throw "Remote archive/stop workflow failed."
}
