# Creates release artifacts for FDD (framework-dependent deployment)

# Restore NuGet packages
dotnet restore

# Publishes FDD files to .\bin\MCD\release\netcoreapp1.1\hello-netcoreapp.dll
dotnet publish -f netcoreapp1.1 -c release

# Create an archive with all FDD files for publishing.
$source = "$PWD\bin\MCD\release\netcoreapp1.1\publish"
$destination = "$PWD\bin\hello-netcoreapp_netcoreapp1.1.zip"
If (Test-Path $destination) {Remove-Item $destination}
Add-Type -Assembly "System.IO.Compression.FileSystem"
[io.compression.zipfile]::CreateFromDirectory($source, $destination)
