[CmdletBinding()]
param(
    [string]$Alias = "colosus",
    [string]$HostName = "192.168.1.82",
    [string]$UserName = "diego-admin",
    [string]$IdentityFile = "~/.ssh/id_ed25519",
    [string]$LocalPasswordFile = "$HOME\Documents\colosus_ssh_password.txt"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-StrongPassword {
    param([int]$Length = 28)
    $chars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$%^&*()-_=+[]{}"
    -join ((1..$Length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
}

$password = New-StrongPassword
"Generated at: $(Get-Date -Format s)`nHost: $HostName`nUser: $UserName`nPassword: $password" |
    Set-Content -Path $LocalPasswordFile -Encoding UTF8

$sshConfigPath = Join-Path $HOME ".ssh\config"
if (-not (Test-Path (Split-Path -Parent $sshConfigPath))) {
    New-Item -Path (Split-Path -Parent $sshConfigPath) -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path $sshConfigPath)) {
    New-Item -Path $sshConfigPath -ItemType File -Force | Out-Null
}

$entry = @"
Host $Alias
  HostName $HostName
  User $UserName
  IdentityFile $IdentityFile
"@

$existing = Get-Content -Path $sshConfigPath -Raw
if ($existing -notmatch "(?m)^Host\s+$Alias\s*$") {
    Add-Content -Path $sshConfigPath -Value "`n$entry"
}

Write-Host "Local password note created at: $LocalPasswordFile" -ForegroundColor Green
Write-Host "SSH alias configured: ssh $Alias" -ForegroundColor Green
Write-Host "Next secure step: connect and run passwd interactively to rotate server password." -ForegroundColor Yellow
