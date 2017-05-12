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
# Example 1: build "FDD", "netcoreapp1.1"
# Example 2: build "SCD", "win10-64"
function build() {
    PUBLISHTYPE=$1
    FRAMEWORKORRUNTIME=$2

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
    PUBLISHDIR="$SCRIPTDIR/../artifacts/$PUBLISHNAME"

    # Clean and create directories
    rm -r -f "$PUBLISHDIR"
    mkdir -p "$PUBLISHDIR"

    # Restore NuGet packages
    dotnet restore $SCRIPTDIR/../src $RESTORESWITCH $RESTORERID

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    dotnet publish $SCRIPTDIR/../src $PUBLISHSWITCH $FRAMEWORKORRUNTIME -c release -o "$PUBLISHDIR"

    # Create an archive with all FDD / SCD files for publishing.
    # tar includes the full path when doing `tar -czf $DESTINATION $SOURCE`
    # and a "." when doing `tar -czf $DESTINATION -C $SOURCE .`.
    # So work around that.
    #TODO: Find and use a way to just archive the files without any path or "."
    DESTINATION="$PUBLISHDIR.tar.gz"
    tar -czf $DESTINATION -C $SCRIPTDIR/../artifacts $PUBLISHNAME
}

# Reads the runtime identifiers from the csproj file
# 
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the csproj file.
function readRuntimeIdentifiersFromCsproj() {
    PATHTOCSPROJ=$1

    # Example line: <RuntimeIdentifiers>win10-x64;ubuntu.16.04-x64</RuntimeIdentifiers>
    RIDLINE=$(cat $PATHTOCSPROJ | grep "<RuntimeIdentifiers>.*</RuntimeIdentifiers>")
    RIDLINE=$(echo $RIDLINE | sed 's/\ *//' | sed 's/<RuntimeIdentifiers>//' | sed 's/<\/RuntimeIdentifiers>//')
    RIDLINE=${RIDLINE//;/ }
    RIDS=($RIDLINE)
    return $RIDS
}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build FDD

build "FDD" "netcoreapp1.1"

# Build SCD

# Publish the SCD for each runtime identifier
RIDS=readRuntimeIdentifiersFromCsproj "$SCRIPTDIR/../src/hello-netcoreapp.csproj"
for RID in ${RIDS[@]}
do
    build "SCD" $RID
done
