#!/bin/bash

# Executes the run script within a Docker container.
# Uses a Docker image that's based on the official .NET Core SDK Docker images but has libglib2.0-0 already installed, which is needed for creating the AppImage.
# TODO: Switch to .NET Core runtime image instead of SDK image.

set -euo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm \
    -v $SCRIPTDIR/../:/app \
    -w /app \
    philippgille/dotnet-libglib:2.0-sdk \
    bash -c "./scripts/run.sh"
