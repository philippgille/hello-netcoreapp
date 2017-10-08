# Injects the version string from the VERSION file into various other files

$ErrorActionPreference = "Stop"

# Replaces a string found by a RegEx pattern by a replacement in a specified file.
# The path to the file must be absolute.
#
# Params: REGEX, REPLACEMENT, FILE
#
# Example: replace '<release version="0.1.0"/>' '<release version="0.2.0"/>' appimage\AppDir\usr\share\metainfo\hello-netcoreapp.appdata.xml
function Set-String
{
    Param ($regex, $replacement, $file)

    (Get-Content $file) -replace $regex, $replacement | Set-Content -Encoding UTF8 $file
}

# Read the version
$version = Get-Content ${PSScriptRoot}\..\VERSION

# Replace in hello-netcoreapp.appdata.xml
Set-String '<release version="\d+\.\d+\.\d+"/>' "<release version=`"${version}`"/>" "${PSScriptRoot}\..\appimage\AppDir\usr\share\metainfo\hello-netcoreapp.appdata.xml"

# Replace in hello-netcoreapp.nuspec
Set-String '<version>\d+\.\d+\.\d+</version>' "<version>${version}</version>" "${PSScriptRoot}\..\chocolatey\hello-netcoreapp.portable.nuspec"
Set-String '<version>\d+\.\d+\.\d+</version>' "<version>${version}</version>" "${PSScriptRoot}\..\chocolatey\hello-netcoreapp.nuspec"

# Replace in .appveyor.yml
Set-String 'version: \d+\.\d+\.\d+\.\{build\}' "version: ${version}.{build}" "${PSScriptRoot}\..\.appveyor.yml"
