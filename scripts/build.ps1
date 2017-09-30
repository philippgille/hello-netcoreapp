# Builds the project and creates release artifacts for SCD (self-contained deployment) and FDD (framework-dependent deployment).
# Uses an installed version of the .NET Core SDK, which should be version 2.0.

$appName = "hello-netcoreapp"

# Don't change anything below this line ########################################

$ErrorActionPreference = "Stop"

# Builds the project and creates release artifacts
#
# Example 1: New-Build "FDD" "netcoreapp2.0" $artifactsDir $sourceDir
# Example 2: New-Build "SCD" "win-x64" $artifactsDir $sourceDir
function New-Build
{
    Param ($publishType, $frameworkOrRuntime, $artifactsDir, $sourceDir)

    # Set variables depending on publish type
    if ($publishType -eq "FDD") {
        $script:publishSwitch = "-f"
    } elseif ($publishType -eq "SCD") {
        $script:publishSwitch = "-r"
    } else {
        Write-Output "An unknown publish type was passed to the function"
        Exit 1
    }

    $publishName = "${appName}_v${version}_$frameworkOrRuntime"
    $publishDir = "$artifactsDir\$publishName"

    # Clean and create directories
    If (Test-Path "$publishDir") {Remove-Item -Recurse -Force "$publishDir"}
    mkdir "$publishDir"

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    # That doesn't matter in this PowerShell script per say, because the build.sh bash script gets used for that,
    # but if that script needs to adapt to that, let's keep the behavior similar and publish to the same directories.
    dotnet publish $sourceDir $script:publishSwitch $frameworkOrRuntime -c release -o "$publishDir"
    Start-Sleep -s 1

    # Create an archive with all FDD / SCD files for publishing.
    # Requires the full .NET framework to be installed, so that the required assembly can be loaded, which is not part of PowerShell.
    $destination = "$publishDir.zip"
    If (Test-Path $destination) {Remove-Item -Force $destination}
    Add-Type -Assembly "System.IO.Compression.FileSystem"
    [io.compression.zipfile]::CreateFromDirectory("$publishDir", $destination)
}

# Reads the runtime identifiers from the csproj file and returns them
# 
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the csproj file.
function Read-RuntimeIdentifiersFromCsproj
{
    Param ($pathToCsProj)

    # Example line: <RuntimeIdentifiers>win-x64;linux-x64</RuntimeIdentifiers>
    $rIdLine = Get-Content $pathToCsProj | Select-String -Pattern "<RuntimeIdentifiers>.*</RuntimeIdentifiers>"
    $rIdLine = (($rIdLine -Replace " ", "") -Replace "<RuntimeIdentifiers>", "") -Replace "</RuntimeIdentifiers>", ""
    $rIds = $rIdLine -Split ";"
    return $rIds
}

$artifactsDir = "$PSScriptRoot\..\artifacts"
$sourceDir = "$PSScriptRoot\..\src"
$version = Get-Content ${PSScriptRoot}\..\VERSION

&${PSScriptRoot}\bumpVersion.ps1

# Build FDD

New-Build "FDD" "netcoreapp2.0" $artifactsDir $sourceDir

# Build SCD

# Publish the SCD for each runtime identifier
$rIds = Read-RuntimeIdentifiersFromCsproj "$sourceDir\$appName.csproj"
foreach ($rId in $rIds) {
    New-Build "SCD" $rId $artifactsDir $sourceDir
}

# Build Chocolatey package if Chocolatey is installed and a win-x64 SCD was built

If ((Get-Command "choco" -ErrorAction SilentlyContinue) -and (Test-Path "$artifactsDir\${appName}_v${version}_win-x64\${appName}.exe")) {
    mkdir "$PSScriptRoot\..\chocolatey\tools" -Force
    Remove-Item -Force "$artifactsDir\${appName}.*.nupkg"
    Remove-Item -Force -Recurse "$PSScriptRoot\..\chocolatey\tools\*"
    Copy-Item "$artifactsDir\${appName}_v${version}_win-x64" "$PSScriptRoot\..\chocolatey\tools" -Recurse
    choco pack "$PSScriptRoot\..\chocolatey\$appName.nuspec" --out $artifactsDir
}
