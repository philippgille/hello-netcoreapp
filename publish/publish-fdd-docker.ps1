# Creates release artifacts for FDD (framework-dependent deployment)
# Uses the official .NET Core Docker container that contains the SDK

docker run --rm -v ${PWD}/../src:/root/src -v ${PWD}:/root/publish -w /root/publish microsoft/dotnet:1.1-sdk ./publish-fdd.sh