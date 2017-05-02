# Creates release artifacts for FDD (framework-dependent deployment).
# Uses an installed version of .NET Core.
# .NET Core SDK version should be 1.1.
# Script must be called from the directory where the script is located.

$appname = "hello-netcoreapp"

# Don't change anything below this line ########################################

$ErrorActionPreference = "Stop"

$publishName = "${appname}_netcoreapp1.1"
$publishDir = "$PWD\bin\publish"

# Clean and create directories
If (Test-Path "$publishDir") {Remove-Item "$publishDir"}
mkdir "$publishDir"
mkdir "$publishDir\$publishName"

# Restore NuGet packages
dotnet restore

# "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
# That doesn't matter in this PowerShell script per say, because the publish.sh bash script gets used for that,
# but if that script needs to adapt to that, let's keep the behavior similar and publish to the same directories.
dotnet publish -f netcoreapp1.1 -c release -o "$publishDir\$publishName"

# Create an archive with all FDD files for publishing.
# Requires the full .NET framework to be installed, so that the required assembly can be loaded, which is not part of PowerShell.
$destination = "$publishDir\$publishName.zip"
If (Test-Path $destination) {Remove-Item $destination}
Add-Type -Assembly "System.IO.Compression.FileSystem"
[io.compression.zipfile]::CreateFromDirectory("$publishDir\$publishName", $destination)
