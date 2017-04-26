#!/bin/bash
set -euxo pipefail

# Creates release artifacts for FDD (framework-dependent deployment)
# Uses an installed version of .NET Core.

APPNAME="hello-netcoreapp_netcoreapp1.1"

# Restore NuGet packages
dotnet restore

# Publishes FDD files to .\bin\MCD\release\netcoreapp1.1\hello-netcoreapp.dll
dotnet publish -f netcoreapp1.1 -c release

# Create an archive with all FDD files for publishing.j
# tar includes the full path when doing `tar -czf $DESTINATION $SOURCE`
# and a "." when doing `tar -czf $DESTINATION -C $SOURCE .`.
# So work around that.
#TODO: Find and use a way to just archive the files without any path or ".""
SOURCE="$PWD/bin/MCD/release/netcoreapp1.1"
mv $SOURCE/publish $SOURCE/$APPNAME
DESTINATION="$PWD/bin/$APPNAME.tar.gz"
tar -czf $DESTINATION -C $SOURCE $APPNAME
mv $SOURCE/$APPNAME $SOURCE/publish