[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$OfficialArchive
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$projectRoot = $PSScriptRoot
$archive = (Get-Item -LiteralPath $OfficialArchive).FullName
$inf = Join-Path $projectRoot 'driver\lg-38wn95c-arm64.inf'
$output = Join-Path $projectRoot 'out'
$expectedArchiveHash = 'f402821ec78bfde6d51ec9b1c28565f78a715134968909af27dbe7a5a96c9ae9'
$expectedIcmHash = 'd2af60dd9dad04d6f75b6cb2416a33547a4a4194d112062384260c6250e1b34c'

$archiveHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $archive).Hash.ToLowerInvariant()
if ($archiveHash -ne $expectedArchiveHash) {
    throw "The official archive hash is $archiveHash, expected $expectedArchiveHash."
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($archive)
try {
    $icmEntry = $zip.GetEntry('LG HDR WQHD+.icm')
    if ($null -eq $icmEntry) {
        throw 'The official archive does not contain LG HDR WQHD+.icm.'
    }

    if (Test-Path -LiteralPath $output) {
        Remove-Item -LiteralPath $output -Recurse -Force
    }
    New-Item -ItemType Directory -Path $output | Out-Null
    $icmPath = Join-Path $output 'LG HDR WQHD+.icm'
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($icmEntry, $icmPath)
}
finally {
    $zip.Dispose()
}

$icmHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $icmPath).Hash.ToLowerInvariant()
if ($icmHash -ne $expectedIcmHash) {
    throw "The ICM profile hash is $icmHash, expected $expectedIcmHash."
}

Copy-Item -LiteralPath $inf -Destination $output
$outputInf = Join-Path $output 'lg-38wn95c-arm64.inf'
$infVerif = Get-Command InfVerif.exe -ErrorAction SilentlyContinue
$inf2Cat = Get-Command Inf2Cat.exe -ErrorAction SilentlyContinue
if ($null -eq $infVerif -or $null -eq $inf2Cat) {
    throw 'InfVerif.exe and Inf2Cat.exe must be available on PATH.'
}

& $infVerif.Source /w /v $outputInf
if ($LASTEXITCODE -ne 0) {
    throw "InfVerif /w failed with exit code $LASTEXITCODE."
}

& $infVerif.Source /h /v $outputInf
if ($LASTEXITCODE -ne 0) {
    throw "InfVerif /h failed with exit code $LASTEXITCODE."
}

& $inf2Cat.Source "/driver:$output" '/os:10_GE_ARM64,10_25H2_ARM64'
if ($LASTEXITCODE -ne 0) {
    throw "Inf2Cat failed with exit code $LASTEXITCODE."
}

Write-Output "Built $outputInf"
