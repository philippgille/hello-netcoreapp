# Builds the project and creates release artifacts for SCD (self-contained deployment) and FDD (framework-dependent deployment).
# Uses the official .NET Core Docker container containing the SDK.

$ErrorActionPreference = "Stop"

docker run --rm `
    -v $PSScriptRoot\..\appimage:/root/appimage `
    -v $PSScriptRoot\..\artifacts:/root/artifacts `
    -v ${PSScriptRoot}:/root/scripts `
    -v $PSScriptRoot\..\src:/root/src `
    microsoft/dotnet:1.1-sdk `
    bash -c "apt update && apt install -y libglib2.0-0 && root/scripts/build.sh"
