hello-netcoreapp
================

hello-netcoreapp is a basic .NET Core app with automation scripts and Dockerfiles.

It was created using `dotnet new console` with the .NET Core SDK 1.1 (or rather SDK 1.0.1 and Shared Framework Host 1.1.1).

Its only additions are files for build and publishing automation.

Build
-----

You can create a *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker image*.

### FDD

- Run `publish-fdd.ps1` if you're using Windows and you have the .NET Core SDK installed
- Run `publish-fdd.sh` if you're using Linux and you have the .NET Core SDK installed
- Run `publish-fdd-docker.ps1` if you're using Windows and you have Docker installed
- Run `publish-fdd-docker.sh` if you're using Linux and you have Docker installed

TODO
----

- Add SCD scripts
- Add SCD README section
- Add Dockerfiles
- Add Dockerfiles README section