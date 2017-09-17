#!/bin/bash

# Injects the version string from the VERSION file into various other files

set -eux

# Replaces a string found by a RegEx pattern by the version in a specified file.
# The path to the file must be specified from the root of the repository.
#
# Params: REGEX, REPLACEMENT, FILE
#
# Example: replace '<release version="0.1.0"/>' '<release version="0.2.0"/>' appimage/AppDir/usr/share/metainfo/hello-netcoreapp.appdata.xml
function replace() {
    REGEX=$1
    REPLACEMENT=$2
    FILE=$3
    
    # Don't use '/' as delimiter in sed in case the variable might contain the same character
    sed -r -i "s@${REGEX}@${REPLACEMENT}@" $SCRIPTDIR/../$FILE
}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read the version
VERSION=$(<$SCRIPTDIR/../VERSION)

# Replace in hello-netcoreapp.appdata.xml
replace '<release version="[0-9]+\.[0-9]+\.[0-9]+"/>' "<release version=\"${VERSION}\"/>" appimage/AppDir/usr/share/metainfo/hello-netcoreapp.appdata.xml

# Replace in hello-netcoreapp.nuspec
replace '<version>[0-9]+\.[0-9]+\.[0-9]+</version>' "<version>${VERSION}</version>" chocolatey/hello-netcoreapp.nuspec

# Replace in appveyor.yml
replace 'version: [0-9]+\.[0-9]+\.[0-9]+\.\{build\}' "version: ${VERSION}.{build}" appveyor.yml
