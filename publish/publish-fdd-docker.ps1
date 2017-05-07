# Creates release artifacts for FDD (framework-dependent deployment).
# Uses the official .NET Core Docker container containing the SDK.

docker run --rm -v $PSScriptRoot\..\src:/root/src -v ${PSScriptRoot}:/root/publish microsoft/dotnet:1.1-sdk root/publish/publish-fdd.sh
