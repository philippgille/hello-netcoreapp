#!/bin/bash

# Runs all built artifacts that should be able to run on Linux

# Don't exit the script on error!
set -uo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# .NET Core 2.0 (should work on most Linux versions)
echo ""
echo ".NET Core 2.0 (should work on most Linux versions)"
dotnet "${SCRIPTDIR}/../artifacts/hello-netcoreapp_v0.1.0_netcoreapp2.0/hello-netcoreapp.dll"

# .NET Core 2.0 SCD for Linux x64
echo ""
echo ".NET Core 2.0 SCD for Linux x64"
${SCRIPTDIR}/../artifacts/hello-netcoreapp_v0.1.0_linux-x64/hello-netcoreapp

# .NET Core 2.0 SCD for Linux ARM
echo ""
echo ".NET Core 2.0 SCD for Linux ARM"
${SCRIPTDIR}/../artifacts/hello-netcoreapp_v0.1.0_linux-arm/hello-netcoreapp
sleep 1s

# AppImage
echo ""
echo "AppImage"
# In case this script is run within a Docker container, extract the AppImage first
source "${SCRIPTDIR}/utils.sh"
running_in_docker
if [[ $RUNNING_IN_DOCKER -eq 1 ]]; then
    echo "Running in Docker. Extracting AppImage first..."
    # Note: Extraction requires libglib2.0-0 to be installed
    ${SCRIPTDIR}/../artifacts/hello-netcoreapp_v0.1.0_linux-x64.AppImage --appimage-extract
    # Then run
    ./squashfs-root/AppRun
    # Then clean up
    rm -r ./squashfs-root
else
    echo "Not running in Docker. Executing AppImage directly..."
    ${SCRIPTDIR}/../artifacts/hello-netcoreapp_v0.1.0_linux-x64.AppImage
fi
