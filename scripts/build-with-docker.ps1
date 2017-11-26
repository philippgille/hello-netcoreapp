# Builds the project and creates release artifacts for FDD (framework-dependent deployment), SCD (self-contained deployment), Chocolatey package and AppImage.
#
# You can execute this script with either 0 or 2 parameters.
#
# Example 1: .\build-with-docker.ps1 -publishType "fdd" -frameworkOrRuntime "netcoreapp2.0"
# Example 2: .\build-with-docker.ps1 -publishType "scd" -frameworkOrRuntime "linux-x64"

param (
    [string]$publishType = "",
    [string]$frameworkOrRuntime = ""
 )

$ErrorActionPreference = "Stop"

if ($args.Count -ne 0) {
    # $args are the UNBOUND variables, of which there should be none
    Write-Output "An invalid number of arguments was passed to this script."
    Exit 1
}

# Build everything that can be built with the .NET Core SDK
# Uses a Docker image that's based on the official .NET Core SDK Docker images but has libglib2.0-0 already installed, which is needed for creating the AppImage.
docker run --rm `
    -v $PSScriptRoot\..\:/app `
    -w /app `
    philippgille/dotnet-libglib:2.0-sdk `
    bash -c "./scripts/build.sh $publishType $frameworkOrRuntime"

# Build Chocolatey package
docker run --rm `
    -v $PSScriptRoot\..\:/app `
    -w /app `
    linuturk/mono-choco `
    bash -c "./scripts/build-chocolatey.sh"
