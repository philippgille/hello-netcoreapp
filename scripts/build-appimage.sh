#!/bin/bash

# Builds the AppImage if a linux-x64 SCD exists
# Downloads appimagetool if it's not present in /tmp

# No "-o pipefail" option for the bash script,
# because when used in the .NET Core SDK Docker container this leads to "invalid option name: pipefail".
set -eux

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APPNAME=$(<$SCRIPTDIR/APP_NAME)
VERSION=$(<$SCRIPTDIR/../VERSION)
ARTIFACTSDIR="$SCRIPTDIR/../artifacts"

$SCRIPTDIR/bumpVersion.sh

# Build AppImage if a linux-x64 SCD was built

if [[ -f $ARTIFACTSDIR/${APPNAME}_v${VERSION}_linux-x64/$APPNAME ]]; then
    # Clean and create directories
    rm -r -f $SCRIPTDIR/../appimage/AppDir/usr/bin/*
    mkdir -p $SCRIPTDIR/../appimage/AppDir/usr/bin/
    # Copy SCD files
    # Copy directory without the version in its name so that the AppRun file can stay unchanged across versions
    cp -r $ARTIFACTSDIR/${APPNAME}_v${VERSION}_linux-x64 $SCRIPTDIR/../appimage/AppDir/usr/bin/${APPNAME}_linux-x64
    # Make sure AppRun is executable
    chmod u+x $SCRIPTDIR/../appimage/AppDir/AppRun
    # Download AppImage creation tool if it doesn't exist yet
    if [[ ! -f /tmp/appimagetool-v9-x86_64.AppImage ]]; then
        curl -Lo /tmp/appimagetool-v9-x86_64.AppImage https://github.com/probonopd/AppImageKit/releases/download/9/appimagetool-x86_64.AppImage
    fi
    chmod u+x /tmp/appimagetool-v9-x86_64.AppImage
    # Extract AppImage so it can be run in Docker containers and on  machines that don't have FUSE installed
    # Note: Extracting requires libglib2.0-0 to be installed
    /tmp/appimagetool-v9-x86_64.AppImage --appimage-extract
    # Create AppImage
#    /tmp/appimagetool-x86_64.AppImage $SCRIPTDIR/../appimage/AppDir/ $ARTIFACTSDIR/${APPNAME}_v${VERSION}_linux-x64.AppImage
    ./squashfs-root/AppRun $SCRIPTDIR/../appimage/AppDir/ $ARTIFACTSDIR/${APPNAME}_v${VERSION}_linux-x64.AppImage
    # Clean up, but don't delete appimagetool to facilitate future offline builds
    rm -r ./squashfs-root
fi
