# Runs all built artifacts that should be able to run on Windows
# 
# Don't exit the script on error!
# 
# For testing the built artifacts you might want to run this script after building with both "build.ps1" and "build-with-docker.ps1".
# But run this script after running each of the build scripts on their own - don't first run both build scripts and then this run script.
# This is because the artifact directories for example for "hello-netcoreapp_v0.1.0_netcoreapp2.0" get overwritten in the build scripts.
# 
# TODO: automate by reading TargetFrameworks and RuntimeIdentifiers from the *.csproj, like in build.ps1

# .NET Framework 4.5.1 (should work on > Windows 8.1, > Windows Server 2008 R2)
Write-Output "`n.NET Framework 4.5.1 (should work on > Windows 8.1, > Windows Server 2008 R2)"
&${PSScriptRoot}\..\artifacts\hello-netcoreapp_v0.1.0_net451\hello-netcoreapp.exe

# .NET Framework 4.6.1 (should work on > Windows 10)
Write-Output "`n.NET Framework 4.6.1 (should work on > Windows 10)"
&${PSScriptRoot}\..\artifacts\hello-netcoreapp_v0.1.0_net461\hello-netcoreapp.exe

# .NET Core 2.0 (should work on most Windows versions)
Write-Output "`n.NET Core 2.0 (should work on most Windows versions)"
dotnet "${PSScriptRoot}\..\artifacts\hello-netcoreapp_v0.1.0_netcoreapp2.0\hello-netcoreapp.dll"

# .NET Core 2.0 SCD for Windows x64
# - When running after build.ps1: depending on .NET Framework 4.6.1 being installed
# - When running after build-with-docker.ps1: no dependencies
Write-Output "`n.NET Core 2.0 SCD for Windows x64"
&${PSScriptRoot}\..\artifacts\hello-netcoreapp_v0.1.0_win-x64\hello-netcoreapp.exe

# Chocolatey package
# Not automated to not mess with the system (e.g. overwriting an installed version of hello-netcoreapp) and also because it requires a privileged (Admin) PowerShell.
Write-Output "`nNote: Please test the Chocolatey package manually (see this script for instructions)!"
# To test manually:
# - First make sure the command isn't registered yet
# hello-netcoreapp
# - Then install the Chocolatey package
# choco install "${PSScriptRoot}\..\artifacts\hello-netcoreapp.portable.0.1.0.nupkg"
# - The command should now work
# hello-netcoreapp
# - Uninstall
# choco uninstall hello-netcoreapp
# - The command shouldn't be registered anymore
# hello-netcoreapp
