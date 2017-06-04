#!/bin/bash

# Builds the project and creates release artifacts for SCD (self-contained deployment) and FDD (framework-dependent deployment).
# Uses an installed version of the .NET Core SDK, which should be version 1.1.

APPNAME="hello-netcoreapp"

# Don't change anything below this line ########################################

# No "-o pipefail" option for the bash script,
# because when used in the .NET Core SDK Docker container this leads to "invalid option nameet: pipefail".
set -eux

# Builds the project and creates release artifacts
#
# Params: PUBLISHTYPE, FRAMEWORKORRUNTIME
#
# Example 1: build "FDD", "netcoreapp1.1" $ARTIFACTSDIR $SOURCEDIR
# Example 2: build "SCD", "win10-64" $ARTIFACTSDIR $SOURCEDIR
function build() {
    PUBLISHTYPE=$1
    FRAMEWORKORRUNTIME=$2
    ARTIFACTSDIR=$3
    SOURCEDIR=$4

    # Set variables depending on publish type
    if [[ "$PUBLISHTYPE" == "FDD" ]]; then
        RESTORESWITCH=""
        RESTORERID=""
        PUBLISHSWITCH="-f"
    elif [[ "$PUBLISHTYPE" == "SCD" ]]; then
        RESTORESWITCH="-r"
        RESTORERID=$FRAMEWORKORRUNTIME
        PUBLISHSWITCH="-r"
    else
        echo "An unknown publish type was passed to the function"
        exit 1
    fi

    PUBLISHNAME="${APPNAME}_$FRAMEWORKORRUNTIME"
    PUBLISHDIR="$ARTIFACTSDIR/$PUBLISHNAME"

    # Clean and create directories
    rm -r -f "$PUBLISHDIR"
    mkdir -p "$PUBLISHDIR"

    # Restore NuGet packages
    dotnet restore $SOURCEDIR $RESTORESWITCH $RESTORERID

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    dotnet publish $SOURCEDIR $PUBLISHSWITCH $FRAMEWORKORRUNTIME -c release -o "$PUBLISHDIR"

    # Create an archive with all FDD / SCD files for publishing.
    # tar includes the full path when doing `tar -czf $DESTINATION $SOURCE`
    # and a "." when doing `tar -czf $DESTINATION -C $SOURCE .`.
    # So work around that.
    #TODO: Find and use a way to just archive the files without any path or "."
    DESTINATION="$PUBLISHDIR.tar.gz"
    tar -czf $DESTINATION -C $ARTIFACTSDIR $PUBLISHNAME
}

# Reads the runtime identifiers from the csproj file and stores them as array in the global variable $RIDS
# 
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the csproj file.
function read_runtime_identifiers_from_csproj() {
    PATHTOCSPROJ=$1

    # Example line: <RuntimeIdentifiers>win10-x64;ubuntu.16.04-x64</RuntimeIdentifiers>
    RIDLINE=$(cat $PATHTOCSPROJ | grep "<RuntimeIdentifiers>.*</RuntimeIdentifiers>")
    RIDLINE=$(echo $RIDLINE | sed 's/\ *//' | sed 's/<RuntimeIdentifiers>//' | sed 's/<\/RuntimeIdentifiers>//')
    RIDLINE=${RIDLINE//;/ }
    RIDS=($RIDLINE)
    # Bash functions can't return arbitrary values - only exit codes. Use the global variable $RIDS instead.
}

# Determines if the script is being executed in a Docker container, result accessible via $RUNNING_IN_DOCKER (1=yes, 0=no)
# https://stackoverflow.com/a/23575107
function running_in_docker() {
    RUNNING_IN_DOCKER=1
    (awk -F/ '$2 == "docker"' /proc/self/cgroup | read non_empty_input) || RUNNING_IN_DOCKER=0
}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARTIFACTSDIR="$SCRIPTDIR/../artifacts"
SOURCEDIR="$SCRIPTDIR/../src"

# Build FDD

build "FDD" "netcoreapp1.1" $ARTIFACTSDIR $SOURCEDIR

# Build SCD

# Publish the SCD for each runtime identifier
# The function stores the RID array in the global variable $RIDS
read_runtime_identifiers_from_csproj "$SOURCEDIR/$APPNAME.csproj"
for RID in "${RIDS[@]}"
do
    build "SCD" $RID $ARTIFACTSDIR $SOURCEDIR
done

# Build AppImage if a ubuntu.16.04-x64 SCD was built and not running in a Docker container
# TODO: Fix issues with Docker container ()

# Call function to store result in $RUNNING_IN_DOCKER
running_in_docker
if [[ -f $ARTIFACTSDIR/${APPNAME}_ubuntu.16.04-x64/$APPNAME && $RUNNING_IN_DOCKER -eq 0 ]]; then
    # Clean and create directories
    rm -r -f $SCRIPTDIR/../appimage/AppDir/usr/bin/*
    mkdir -p $SCRIPTDIR/../appimage/AppDir/usr/bin/
    # Copy SCD files
    cp -r $ARTIFACTSDIR/${APPNAME}_ubuntu.16.04-x64 $SCRIPTDIR/../appimage/AppDir/usr/bin/
    # Make sure AppRun is executable
    chmod u+x $SCRIPTDIR/../appimage/AppDir/AppRun
    # Download AppImage creation tool, make it executable and extract it, so we don't need to have fuse installed
    curl -Lo /tmp/appimagetool-x86_64.AppImage https://github.com/probonopd/AppImageKit/releases/download/8/appimagetool-x86_64.AppImage
    chmod u+x /tmp/appimagetool-x86_64.AppImage
    # Create AppImage
    /tmp/appimagetool-x86_64.AppImage $SCRIPTDIR/../appimage/AppDir/ $ARTIFACTSDIR/${APPNAME}_ubuntu.16.04-x64.AppImage
    # Delete downloaded AppImage creation tool
    rm /tmp/appimagetool-x86_64.AppImage
fi
