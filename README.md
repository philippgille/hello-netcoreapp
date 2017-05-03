hello-netcoreapp
================

hello-netcoreapp is a basic *.NET Core* application with additional scripts and files for building and publishing the app as *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker image*.

You can fork this repository and use the files as a starting point for your .NET Core app.

The basic app was created using `dotnet new console` with the .NET Core SDK 1.1 (or rather SDK 1.0.1 and Shared Framework Host 1.1.1).

Terminology:

- FDD: The app relies on an installed version of *.NET Core*. But it's completely portable to all systems running .NET Core.
- SCD: The app is completely self-contained. .NET Core runtime files are delivered with the executable, making this package bigger than an FDD. It's independent of a .NET Core installation, but not portable, so multiple SCDs must be created and each one only runs on a single operating systems. For a list of supported systems, see [https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog](https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog).
- Docker image: The app can be run as Docker container, which is based on the official [Microsoft/dotnet Docker image](https://hub.docker.com/r/microsoft/dotnet/), using the image for FDDs that they recommended for use in production.

Directory structure
-------------------

- /.vscode: Contains files for debugging in Visual Studio Code. Used in case you open the root directory of the repository as workspace in Visual Studio Code
- /src: Contains the application source code, basically just a main class (`Program.cs`) and project file (`hello-netcoreapp.csproj`)
    - .vscode: Contains files for debugging in Visual Studio Code. Used in case you open the /src directory of the repository as workspace in Visual Studio Code
- /publish: Contains scripts for building and publishing the app
    - output: When running one of the publish scripts, this directory will contain the resulting files, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`

Build
-----

You can create a *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker image*.

You can create an FDD or SCD with *either* the .NET Core SDK *or* Docker installed. For building the Docker image you need to have Docker installed.

### FDD

- Run `publish-fdd.ps1` if you're using Windows and you have the .NET Core SDK installed. It will create the archive `hello-netcoreapp_netcoreapp1.1.zip`.
- Run `publish-fdd.sh` if you're using Linux and you have the .NET Core SDK installed. It will create the archive `hello-netcoreapp_netcoreapp1.1.tar.gz`.
- Run `publish-fdd-docker.ps1` if you're using Windows and you have Docker installed. It will create the archive `hello-netcoreapp_netcoreapp1.1.tar.gz`.
- Run `publish-fdd-docker.sh` if you're using Linux and you have Docker installed. It will create the archive `hello-netcoreapp_netcoreapp1.1.tar.gz`.

Run
---

You can run the console app either as *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker container*.

### FDD

After building the FDD, you can copy the `hello-netcoreapp_netcoreapp1.1.zip` / `hello-netcoreapp_netcoreapp1.1.tar.gz` to wherever you want to run the app, extract the archive and run `dotnet hello-netcoreapp.dll`.

TODO
----

- Add SCD scripts
- Add SCD README section
- Add Dockerfile
- Add Dockerfile README section
- Add Dockerfile for image using SCD
- Add Dockerfile for image using SCD README section
- Add Dockerfile for Windows Server 2016 Nano
- Add Dockerfile for Windows Server 2016 Nano README section
