param(
    [string]$LovePath = 'C:/Program Files/LOVE/lovec.exe',
    [ValidateSet('shop', 'catch')][string]$Scenario = 'shop'
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$previewDirectory = Join-Path $env:TEMP ('FishingGame-shop-preview-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $previewDirectory | Out-Null
New-Item -ItemType Directory -Force (Join-Path $PSScriptRoot 'output') | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'main.lua'),(Join-Path $PSScriptRoot 'conf.lua') -Destination $previewDirectory
if ($Scenario -eq 'catch') {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'catch_main.lua') -Destination (Join-Path $previewDirectory 'main.lua')
}
Copy-Item -LiteralPath (Join-Path $projectRoot 'assets'),(Join-Path $projectRoot 'src') -Destination $previewDirectory -Recurse
Push-Location $projectRoot
try {
    & $LovePath $previewDirectory
    if ($LASTEXITCODE -ne 0) { throw 'Shop preview verification failed.' }
} finally {
    Pop-Location
}
