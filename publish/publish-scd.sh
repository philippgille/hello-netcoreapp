#!/bin/bash

# Creates release artifacts for FDD (framework-dependent deployment).
# Uses an installed version of the .NET Core SDK, which should be version 1.1.

APPNAME="hello-netcoreapp"

# Don't change anything below this line ########################################

# No "-o pipefail" option for the bash script,
# because when used in the .NET Core SDK Docker container this leads to "invalid option nameet: pipefail".
set -eux

# Parse the runtime identifiers from the csproj file
# Example: <RuntimeIdentifiers>win10-x64;ubuntu.16.04-x64</RuntimeIdentifiers>
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the csproj file.
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RIDLINE=$(cat "$SCRIPTDIR/../src/hello-netcoreapp.csproj" | grep "<RuntimeIdentifiers>.*</RuntimeIdentifiers>")
RIDLINE=$(echo $RIDLINE | sed 's/\ *//' | sed 's/<RuntimeIdentifiers>//' | sed 's/<\/RuntimeIdentifiers>//')
RIDLINE=${RIDLINE//;/ }
RIDS=($RIDLINE)

# Publish the SCD for each runtime identifier
for RID in ${RIDS[@]}
do
    PUBLISHNAME="${APPNAME}_$RID"
    PUBLISHDIR="$SCRIPTDIR/output/$PUBLISHNAME"

    rm -r -f "$PUBLISHDIR"
    mkdir -p "$PUBLISHDIR"

    # Restore NuGet packages
    dotnet restore $SCRIPTDIR/../src -r $RID

    # "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
    dotnet publish $SCRIPTDIR/../src -r $RID -c release -o "$PUBLISHDIR"

    # Create an archive with all SCD files for publishing.
    # tar includes the full path when doing `tar -czf $DESTINATION $SOURCE`
    # and a "." when doing `tar -czf $DESTINATION -C $SOURCE .`.
    # So work around that.
    #TODO: Find and use a way to just archive the files without any path or "."
    DESTINATION="$PUBLISHDIR.tar.gz"
    tar -czf $DESTINATION -C $SCRIPTDIR/output $PUBLISHNAME
done
