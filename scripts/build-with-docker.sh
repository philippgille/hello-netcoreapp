#!/bin/bash

# Builds the project and creates release artifacts for SCD (self-contained deployment) and FDD (framework-dependent deployment).
# Uses the official .NET Core Docker container containing the SDK.

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm \
    -v $SCRIPTDIR/../appimage:/root/appimage \
    -v $SCRIPTDIR/../artifacts:/root/artifacts \
    -v $SCRIPTDIR:/root/scripts \
    -v $SCRIPTDIR/../src:/root/src \
    microsoft/dotnet:1.1-sdk \
    root/scripts/build.sh
