# Builds the Chocolatey package if a win-x64 SCD exists
# Uses an installed version of Chocolatey

$ErrorActionPreference = "Stop"

$appName = Get-Content ${PSScriptRoot}\APP_NAME
$version = Get-Content ${PSScriptRoot}\..\VERSION
$artifactsDir = "$PSScriptRoot\..\artifacts"

&${PSScriptRoot}\bumpVersion.ps1

# Build Chocolatey package if Chocolatey is installed and a win-x64 SCD was built

If ((Get-Command "choco" -ErrorAction SilentlyContinue) -and (Test-Path "$artifactsDir\${appName}_v${version}_win-x64\${appName}.exe")) {
    # Create and clean directories
    mkdir "$PSScriptRoot\..\chocolatey\tools" -Force
    Remove-Item -Force "$artifactsDir\${appName}.*.nupkg"
    Remove-Item -Force -Recurse "$PSScriptRoot\..\chocolatey\tools\*"
    # Copy SCD files
    Copy-Item "$artifactsDir\${appName}_v${version}_win-x64" "$PSScriptRoot\..\chocolatey\tools" -Recurse
    # Build Chocolatey package
    choco pack "$PSScriptRoot\..\chocolatey\$appName.nuspec" --out $artifactsDir
}
