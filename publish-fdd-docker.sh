# Creates release artifacts for FDD (framework-dependent deployment)
# Uses the official .NET Core Docker container that contains the SDK

docker run --rm -v ${PWD}:/root/app -w /root/app microsoft/dotnet:1.1-sdk ./publish-fdd.sh