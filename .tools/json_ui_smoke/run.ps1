param([string]$LovePath = 'C:/Program Files/LOVE/lovec.exe')
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$testDirectory = Join-Path $env:TEMP ('FishingGame-json-ui-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $testDirectory | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'main.lua'),(Join-Path $PSScriptRoot 'conf.lua') -Destination $testDirectory
Copy-Item -LiteralPath (Join-Path $projectRoot 'assets'),(Join-Path $projectRoot 'src') -Destination $testDirectory -Recurse
& $LovePath $testDirectory
if ($LASTEXITCODE -ne 0) { throw 'JSON UI verification failed.' }
