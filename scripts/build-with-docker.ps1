# Builds the project and creates release artifacts for FDD (framework-dependent deployment), SCD (self-contained deployment), Chocolatey package and AppImage.

$ErrorActionPreference = "Stop"

# Build everything that can be built with the .NET Core SDK
# Uses a Docker image that's based on the official .NET Core SDK Docker images but has libglib2.0-0 already installed, which is needed for creating the AppImage.
docker run --rm `
    -v $PSScriptRoot\..\:/app `
    -w /app `
    philippgille/dotnet-libglib:2.0-sdk `
    bash -c "./scripts/build.sh"

# Build Chocolatey package
docker run --rm `
    -v $PSScriptRoot\..\:/app `
    -w /app `
    linuturk/mono-choco `
    bash -c "./scripts/build-chocolatey.sh"
