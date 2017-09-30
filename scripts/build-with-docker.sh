#!/bin/bash

# Builds the project and creates release artifacts for SCD (self-contained deployment), FDD (framework-dependent deployment) and AppImage.
# Uses a Docker image that's based on the official .NET Core SDK Docker images but has libglib2.0-0 already installed, which is needed for creating the AppImage.

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm \
    -v $SCRIPTDIR/../:/app \
    -w /app \
    philippgille/dotnet-libglib:2.0-sdk \
    bash -c "./scripts/build.sh"
