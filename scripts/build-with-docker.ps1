# Builds the project and creates release artifacts for SCD (self-contained deployment) and FDD (framework-dependent deployment).
# Uses the official .NET Core Docker container containing the SDK.

docker run --rm `
    -v $PSScriptRoot\..\:/dotnetapp `
    -w /dotnetapp `
    microsoft/dotnet:1.1-sdk `
    bash -c "apt update && apt install -y --no-install-recommends libglib2.0-0 && ./scripts/build.sh"
