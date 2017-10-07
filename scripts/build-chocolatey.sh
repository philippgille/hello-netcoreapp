#!/bin/bash

# Builds the Chocolatey package if a win-x64 SCD exists
# Uses Chocolatey via Mono
# Is intended to be used inside a linuturk/mono-choco Docker container

# No "-o pipefail" option for the bash script,
# because when used in the .NET Core SDK Docker container this leads to "invalid option name: pipefail".
set -eux

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APPNAME=$(<$SCRIPTDIR/APP_NAME)
VERSION=$(<$SCRIPTDIR/../VERSION)
ARTIFACTSDIR="$SCRIPTDIR/../artifacts"

$SCRIPTDIR/bumpVersion.sh

# Build chocolatey package if a win-x64 SCD was built

if [[ -f $ARTIFACTSDIR/${APPNAME}_v${VERSION}_win-x64/$APPNAME.exe ]]; then
    # Clean and create directories
    rm -f $ARTIFACTSDIR/$APPNAME.*.nupkg
    rm -r -f $SCRIPTDIR/../chocolatey/tools/*
    mkdir -p $SCRIPTDIR/../chocolatey/tools
    # Copy SCD files
    cp -r $ARTIFACTSDIR/${APPNAME}_v${VERSION}_win-x64 $SCRIPTDIR/../chocolatey/tools
    # Workaround for a bug where choco uses the wrong working directory when using choco via Mono
    REGEX="<file src=\\\"tools\\\\\**\\\" target=\"tools\" />"
    REPLACEMENT="<file src=\"${SCRIPTDIR}/../chocolatey/tools\\**\" target=\"tools\" />"
    sed -r "s@${REGEX}@${REPLACEMENT}@g" $SCRIPTDIR/../chocolatey/$APPNAME.nuspec > $SCRIPTDIR/../chocolatey/$APPNAME.temp-linux.nuspec
    # Build Chocolatey package
    choco pack "$SCRIPTDIR/../chocolatey/$APPNAME.temp-linux.nuspec" --out $ARTIFACTSDIR
    # Clean up workaround
    rm -f $SCRIPTDIR/../chocolatey/$APPNAME.temp-linux.nuspec
fi
