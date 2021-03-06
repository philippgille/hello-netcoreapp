#!/bin/bash

# Builds the project and creates release artifacts for FDD (framework-dependent deployment) and SCD (self-contained deployment).
# Uses an installed version of the .NET Core SDK, which should be version 2.0.
#
# You can execute this script with either 0 or 2 parameters.
#
# Example 1: ./build.sh "fdd" "netcoreapp2.0"
# Example 2: ./build.sh "scd" "linux-x64"

# No "-o pipefail" option for the bash script,
# because when used in the .NET Core SDK Docker container this leads to "invalid option name: pipefail".
set -eux

# Builds the project and creates release artifacts
#
# Params: PUBLISHTYPE, FRAMEWORKORRUNTIME, ARTIFACTSDIR, SOURCEDIR
#
# Example 1: build "FDD" "netcoreapp2.0" $ARTIFACTSDIR $SOURCEDIR
# Example 2: build "SCD" "win-64" $ARTIFACTSDIR $SOURCEDIR
function build() {
    PUBLISHTYPE=$1
    FRAMEWORKORRUNTIME=$2
    ARTIFACTSDIR=$3
    SOURCEDIR=$4

    # Set variables depending on publish type.
    # Make case insensitive check.
    shopt -s nocasematch
    if [[ "$PUBLISHTYPE" == "FDD" ]]; then
        PUBLISHPARAMS="-f"
    elif [[ "$PUBLISHTYPE" == "SCD" ]]; then
        # Non-Windows machines can only build with netcoreapp as target framework
        PUBLISHPARAMS="-f \"netcoreapp2.0\" -r"
    else
        echo "An unknown publish type was passed to the function"
        exit 1
    fi
    shopt -u nocasematch

    PUBLISHNAME="${APPNAME}_v${VERSION}_$FRAMEWORKORRUNTIME"
    PUBLISHDIR="$ARTIFACTSDIR/$PUBLISHNAME"

    # Clean and create directories
    # Also clean bin and obj to match the behavior of the PowerShell script
    rm -r -f "$SOURCEDIR/bin"
    rm -r -f "$SOURCEDIR/obj"
    rm -r -f "$PUBLISHDIR"
    mkdir -p "$PUBLISHDIR"

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    dotnet publish $SOURCEDIR $PUBLISHPARAMS $FRAMEWORKORRUNTIME -c release -o "$PUBLISHDIR"
    sleep 1s

    # Create an archive with all FDD / SCD files for publishing.
    # tar includes the full path when doing `tar -czf $DESTINATION $SOURCE`
    # and a "." when doing `tar -czf $DESTINATION -C $SOURCE .`.
    # So work around that.
    #TODO: Find and use a way to just archive the files without any path or "."
    DESTINATION="$PUBLISHDIR.tar.gz"
    tar -czf $DESTINATION -C $ARTIFACTSDIR $PUBLISHNAME
}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APPNAME=$(<$SCRIPTDIR/APP_NAME)
VERSION=$(<$SCRIPTDIR/../VERSION)
ARTIFACTSDIR="$SCRIPTDIR/../artifacts"
SOURCEDIR="$SCRIPTDIR/../src"

$SCRIPTDIR/bumpVersion.sh

# Clean old artifacts
rm -rf $ARTIFACTSDIR/*

# Depending on the parameters passed to this script, either build all artifacts or just the given one
if [[ $# -eq 0 ]]; then
    # Build FDD
    # Don't iterate through all target frameworks in the *.csproj file, because only netcoreapp can be built on non-Windows machines.

    build "FDD" "netcoreapp2.0" $ARTIFACTSDIR $SOURCEDIR

    # Build SCD

    # Publish the SCD for each runtime identifier
    # The function stores the RID array in the global variable $XML_VALUES
    source "${SCRIPTDIR}/utils.sh"
    read_csv_from_xml_val "$SOURCEDIR/$APPNAME.csproj" "RuntimeIdentifiers"
    for RID in "${XML_VALUES[@]}"
    do
        build "SCD" $RID $ARTIFACTSDIR $SOURCEDIR
    done
elif [[ $# -eq 2 ]]; then
    build "$1" "$2" $ARTIFACTSDIR $SOURCEDIR
else
    echo "An invalid number of arguments was passed to this script."
    exit 1
fi

# Build AppImage if a linux-x64 SCD was built

$SCRIPTDIR/build-appimage.sh
