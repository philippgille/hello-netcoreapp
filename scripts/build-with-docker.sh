#!/bin/bash
# Builds the project and creates release artifacts for FDD (framework-dependent deployment), SCD (self-contained deployment), Chocolatey package and AppImage.
#
# You can execute this script with either 0 or 2 parameters.
#
# Example 1: ./build-with-docker.sh "fdd" "netcoreapp2.0"
# Example 2: ./build-with-docker.sh "scd" "linux-x64"

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -eq 0 ]]; then
    # Uses a Docker image that's based on the official .NET Core SDK Docker images but has libglib2.0-0 already installed, which is needed for creating the AppImage.
    docker run --rm \
        -v $SCRIPTDIR/../:/app \
        -w /app \
        philippgille/dotnet-libglib:2.0-sdk \
        bash -c "./scripts/build.sh"
elif [[ $# -eq 2 ]]; then
    # Uses a Docker image that's based on the official .NET Core SDK Docker images but has libglib2.0-0 already installed, which is needed for creating the AppImage.
    docker run --rm \
        -v $SCRIPTDIR/../:/app \
        -w /app \
        philippgille/dotnet-libglib:2.0-sdk \
        bash -c "./scripts/build.sh $1 $2"
else
    echo "An invalid number of arguments was passed to this script."
    exit 1
fi

# Build Chocolatey package
docker run --rm \
    -v $SCRIPTDIR/../:/app \
    -w /app \
    linuturk/mono-choco \
    bash -c "./scripts/build-chocolatey.sh"
