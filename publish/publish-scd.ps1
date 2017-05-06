# Creates release artifacts for SCD (self-contained deployment).
# Uses an installed version of the .NET Core SDK, which should be version 1.1
# Script must be called from the directory where the script is located.

$appname = "hello-netcoreapp"

# Don't change anything below this line ########################################

$ErrorActionPreference = "Stop"

# Parse the runtime identifiers from the csproj file
# Example: <RuntimeIdentifiers>win10-x64;ubuntu.16.04-x64</RuntimeIdentifiers>
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the csproj file.
$rIdLine =  Get-Content "..\src\hello-netcoreapp.csproj" | Select-String -Pattern "<RuntimeIdentifiers>.*</RuntimeIdentifiers>"
$rIdLine = (($rIdLine -Replace " ", "") -Replace "<RuntimeIdentifiers>", "") -Replace "</RuntimeIdentifiers>", ""
$rIds = $rIdLine -Split ";"

# Publish the SCD for each runtime identifier
foreach ($rId in $rIds) {
    $publishName = "${appname}_$rId"
    $publishDir = "$PWD\output\$publishName"

    # Clean and create directories
    If (Test-Path "$publishDir") {Remove-Item -Recurse -Force "$publishDir"}
    mkdir "$publishDir"

    # cd into source directory for dotnet commands
    Set-Location ..\src

    # Restore NuGet packages
    dotnet restore -r $rId

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    # That doesn't matter in this PowerShell script per say, because the publish.sh bash script gets used for that,
    # but if that script needs to adapt to that, let's keep the behavior similar and publish to the same directories.
    dotnet publish -r $rId -c release -o "$publishDir"

    # cd back to original publish directory
    Set-Location ..\publish

    # Create an archive with all SCD files for publishing.
    # Requires the full .NET framework to be installed, so that the required assembly can be loaded, which is not part of PowerShell.
    $destination = "$publishDir.zip"
    If (Test-Path $destination) {Remove-Item $destination}
    Add-Type -Assembly "System.IO.Compression.FileSystem"
    [io.compression.zipfile]::CreateFromDirectory("$publishDir", $destination)
}
