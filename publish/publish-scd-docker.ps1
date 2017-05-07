# Creates release artifacts for SCD (self-contained deployment).
# Uses the official .NET Core Docker container containing the SDK.

docker run --rm -v $PSScriptRoot\..\src:/root/src -v ${PSScriptRoot}:/root/publish microsoft/dotnet:1.1-sdk root/publish/publish-scd.sh