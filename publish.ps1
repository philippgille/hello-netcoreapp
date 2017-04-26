# Creates release artifacts for FDD (framework-dependent deployment)
# Uses an installed version of .NET Core.
# .NET Core SDK version should be 1.1

$ErrorActionPreference = "Stop"

$appname = "hello-netcoreapp_netcoreapp1.1"

# Restore NuGet packages
dotnet restore

# Publishes FDD files to .\bin\MCD\release\netcoreapp1.1\hello-netcoreapp.dll
dotnet publish -f netcoreapp1.1 -c release

# Create an archive with all FDD files for publishing.
# Requires the full .NET framework to be installed, so that the required assembly can be loaded, which is not part of PowerShell.
$source = "$PWD\bin\MCD\release\netcoreapp1.1\publish"
$destination = "$PWD\bin\$appname.zip"
If (Test-Path $destination) {Remove-Item $destination}
Add-Type -Assembly "System.IO.Compression.FileSystem"
[io.compression.zipfile]::CreateFromDirectory($source, $destination)
