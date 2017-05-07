#!/bin/bash

# Creates release artifacts for FDD (framework-dependent deployment).
# Uses the official .NET Core Docker container containing the SDK.

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm -v $SCRIPTDIR/../src:/root/src -v $SCRIPTDIR:/root/publish microsoft/dotnet:1.1-sdk root/publish/publish-fdd.sh
