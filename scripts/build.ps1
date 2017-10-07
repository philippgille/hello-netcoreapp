# Builds the project and creates release artifacts for SCD (self-contained deployment) and FDD (framework-dependent deployment).
# Uses an installed version of the .NET Core SDK, which should be version 2.0.

$ErrorActionPreference = "Stop"

# Builds the project and creates release artifacts
#
# Example 1: New-Build "FDD" "netcoreapp2.0" $artifactsDir $sourceDir
# Example 2: New-Build "SCD" "win-x64" $artifactsDir $sourceDir
function New-Build
{
    Param ($publishType, $frameworkOrRuntime, $artifactsDir, $sourceDir)

    # Set variables depending on publish type
    # PowerShell doesn't allow having multiple parameter switches and parameters in one variable and passing that to the command,
    # so we need to make it a bit more complicated than in build.sh.
    $publishNameSuffix = $frameworkOrRuntime
    if ($publishType -eq "FDD") {
        $framework = $frameworkOrRuntime
        $script:runtimeParamSwitch = ""
        $frameworkOrRuntime = ""
    } elseif ($publishType -eq "SCD") {
        if (($frameworkOrRuntime -like "win*") -and ($frameworkOrRuntime -notlike "*arm*")) {
            $framework = "net461"
            $script:runtimeParamSwitch = "-r"
        } else {
            $framework = "netcoreapp2.0"
            $script:runtimeParamSwitch = "-r"
        }
    } else {
        Write-Output "An unknown publish type was passed to the function"
        Exit 1
    }

    $publishName = "${appName}_v${version}_$publishNameSuffix"
    $publishDir = "$artifactsDir\$publishName"

    # Clean and create directories
    If (Test-Path "$publishDir") {Remove-Item -Recurse -Force "$publishDir"}
    mkdir "$publishDir"

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    # That doesn't matter in this PowerShell script per say, because the build.sh bash script gets used for that,
    # but if that script needs to adapt to that, let's keep the behavior similar and publish to the same directories.
    dotnet publish $sourceDir -f $framework $script:runtimeParamSwitch $frameworkOrRuntime -c release -o "$publishDir"
    Start-Sleep -s 1

    # Create an archive with all FDD / SCD files for publishing.
    # Requires the full .NET framework to be installed, so that the required assembly can be loaded, which is not part of PowerShell.
    $destination = "$publishDir.zip"
    If (Test-Path $destination) {Remove-Item -Force $destination}
    Add-Type -Assembly "System.IO.Compression.FileSystem"
    [io.compression.zipfile]::CreateFromDirectory("$publishDir", $destination)
}

# Reads comma seperated values from a given XML value in a given file and returns them
# 
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the file.
function Read-CsvFromXmlVal
{
    Param ($pathToXml, $xmlValueName)

    # Example line: <RuntimeIdentifiers>win-x64;linux-x64</RuntimeIdentifiers>
    $rIdLine = Get-Content $pathToXml | Select-String -Pattern "<${xmlValueName}>.*</${xmlValueName}>"
    $rIdLine = (($rIdLine -Replace " ", "") -Replace "<${xmlValueName}>", "") -Replace "</${xmlValueName}>", ""
    $rIds = $rIdLine -Split ";"
    return $rIds
}

$appName = Get-Content ${PSScriptRoot}\APP_NAME
$version = Get-Content ${PSScriptRoot}\..\VERSION
$artifactsDir = "$PSScriptRoot\..\artifacts"
$sourceDir = "$PSScriptRoot\..\src"

&${PSScriptRoot}\bumpVersion.ps1

# Build FDD

# Publish the FDD for each target framework
$targetFrameworks = Read-CsvFromXmlVal "$sourceDir\$appName.csproj" "TargetFrameworks"
foreach ($targetFramework in $targetFrameworks) {
    New-Build "FDD" $targetFramework $artifactsDir $sourceDir
}

# Build SCD

# Publish the SCD for each runtime identifier
$rIds = Read-CsvFromXmlVal "$sourceDir\$appName.csproj" "RuntimeIdentifiers"
foreach ($rId in $rIds) {
    New-Build "SCD" $rId $artifactsDir $sourceDir
}

# Build Chocolatey package if Chocolatey is installed and a win-x64 SCD was built

&${PSScriptRoot}\build-chocolatey.ps1
