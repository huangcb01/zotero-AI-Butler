param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")),
  [string]$ProfilePath = "",
  [string]$ZoteroPath = ""
)

$ErrorActionPreference = "Stop"

if (-not $ProfilePath) {
  $ProfilePath = Join-Path $ProjectRoot "debug"
}

if (-not $ZoteroPath) {
  $candidatePaths = @(
    $env:ZOTERO_PLUGIN_ZOTERO_BIN_PATH,
    "C:\Program Files\Zotero\zotero.exe",
    "C:\Program Files (x86)\Zotero\zotero.exe",
    (Join-Path $env:LOCALAPPDATA "Programs\Zotero\zotero.exe")
  ) | Where-Object { $_ -and $_.Trim() -ne "" }

  $ZoteroPath = $candidatePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $ZoteroPath -or -not (Test-Path $ZoteroPath)) {
  throw "Cannot find zotero.exe. Set -ZoteroPath or env ZOTERO_PLUGIN_ZOTERO_BIN_PATH first."
}

New-Item -ItemType Directory -Path $ProfilePath -Force | Out-Null

$env:ZOTERO_PLUGIN_ZOTERO_BIN_PATH = $ZoteroPath
$env:ZOTERO_PLUGIN_PROFILE_PATH = $ProfilePath

Write-Host "Using Zotero binary: $ZoteroPath"
Write-Host "Using dev profile:  $ProfilePath"

Push-Location $ProjectRoot
try {
  npm start
} finally {
  Pop-Location
}