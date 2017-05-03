#!/bin/bash

# Creates release artifacts for FDD (framework-dependent deployment).
# Uses an installed version of the .NET Core SDK, which should be version 1.1
# Script must be called from the directory where the script is located.
#
# Note: No "-o pipefail" option for the bash script,
# because when used in the .NET Core SDK Docker container this leads to "invalid option nameet: pipefail".

APPNAME="hello-netcoreapp"

# Don't change anything below this line ########################################

set -eux

PUBLISHNAME="${APPNAME}_netcoreapp1.1"
PUBLISHDIR="$PWD/output/$PUBLISHNAME"

rm -r -f "$PUBLISHDIR"
mkdir "$PUBLISHDIR"

# cd into source directory for dotnet commands
cd ..\src

# Restore NuGet packages
dotnet restore

# "dotnet publish" without "-o" option publishes to different directories on Windows vs. .NET Core SDK Docker container.
dotnet publish -f netcoreapp1.1 -c release -o "$PUBLISHDIR"

# cd back to original publish directory
cd ..\publish

# Create an archive with all FDD files for publishing.
# tar includes the full path when doing `tar -czf $DESTINATION $SOURCE`
# and a "." when doing `tar -czf $DESTINATION -C $SOURCE .`.
# So work around that.
#TODO: Find and use a way to just archive the files without any path or ".""
DESTINATION="$PUBLISHDIR.tar.gz"
tar -czf $DESTINATION -C $PUBLISHDIR $PUBLISHNAME