hello-netcoreapp
================

hello-netcoreapp is a basic *.NET Core* application with additional scripts and files for building and publishing the app as *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker image*.

You can fork this repository and use the files as a starting point for your .NET Core app.

The basic app was created using `dotnet new console` with the .NET Core SDK 1.1 (or rather SDK 1.0.1 and Shared Framework Host 1.1.1).

Terminology:

- FDD: The app relies on an installed version of *.NET Core*. But it's completely portable to all systems running .NET Core.
- SCD: The app is completely self-contained. .NET Core runtime files are delivered with the executable, making this package bigger than an FDD. It's independent of a .NET Core installation, but not portable, so multiple SCDs must be created and each one only runs on a single operating systems. For a list of supported systems, see [https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog](https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog).
- Docker image: The app can be run as Docker container (Linux and Windows), which is based on the official [Microsoft/dotnet Docker image](https://hub.docker.com/r/microsoft/dotnet/), using the image for FDDs that they recommended for use in production.

Directory structure
-------------------

- /.vscode: Contains files for debugging in Visual Studio Code. Used in case you open the root directory of the repository as workspace in Visual Studio Code
- /src: Contains the application source code, basically just a main class (`Program.cs`) and project file (`hello-netcoreapp.csproj`)
    - .vscode: Contains files for debugging in Visual Studio Code. Used in case you open the /src directory of the repository as workspace in Visual Studio Code
- /publish: Contains scripts for building and publishing the app
    - output: When running one of the publish scripts, this directory will contain the resulting files, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`
- Dockerfile: The Dockerfile for building a Docker image for Linux containers with the app
- Dockerfile.nano: The Dockerfile for building a Docker image for Windows containers with the app

Build
-----

You can create a *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker image*.

You can create an FDD or SCD with *either* the .NET Core SDK *or* Docker installed. For building the Docker image you need to have Docker installed.

### FDD

- If you're using Windows and you have the .NET Core SDK installed, run: `publish-fdd.ps1`
    - It will create the archive `hello-netcoreapp_netcoreapp1.1.zip`.
- If you're using Linux and you have the .NET Core SDK installed, run: `publish-fdd.sh`
    - It will create the archive `hello-netcoreapp_netcoreapp1.1.tar.gz`.
- If you're using Windows and you have Docker installed and configured to use Linux containers, run: `publish-fdd-docker.ps1`
    - It will create the archive `hello-netcoreapp_netcoreapp1.1.tar.gz`.
- If you're using Linux and you have Docker installed, run: `publish-fdd-docker.sh`
    - It will create the archive `hello-netcoreapp_netcoreapp1.1.tar.gz`.

### SCD

- If you're using Windows and you have the .NET Core SDK installed, run: `publish-scd.ps1`
    - It will create archives for each runtime identifier specified in the csproj file, for example `hello-netcoreapp_ubuntu.16.04-x64.zip`

### Docker image

1. First run any of the FDD publish scripts, so that there's `/publish/output/hello-netcoreapp_netcoreapp1.1`
    - Note: You should run those scripts from the publish directory, so you might need to `cd` into it first
2. In the root directory of the repository, depending on which container host system you want to target:
    - For Linux containers, run: `docker build -t my/hello-netcoreapp .`
    - For Windows containers, run: `docker build -t my/hello-netcoreapp -f Dockerfile.nano .`

Run
---

You can run the console app either as *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker container*.

### FDD

After building the FDD, you can copy the archive (`hello-netcoreapp_netcoreapp1.1.zip` or `hello-netcoreapp_netcoreapp1.1.tar.gz`) to wherever you want to run the app, extract the archive and run `dotnet hello-netcoreapp.dll`.

### SCD

After building the SCD, you can copy the archive (`hello-netcoreapp_ubuntu.16.04-x64.zip`) to wherever you want to run the app (only the operating system has to match), extract the archive and run, depending on the OS:

- On Windows: `output\hello-netcoreapp_win10-x64\hello-netcoreapp.exe`
- On Ubuntu: `output/hello-netcoreapp_ubuntu.16.04-x64/hello-netcoreapp`
- etc.

#### Simplify execution

The app is portable, so you can move the directory wherever you want on your system, for example `C:\Users\Philipp\MyPortableApps\hello-netcoreapp` on Windows, or `/home/users/philipp/myPortableApps/hello-netcoreapp` on Linux. Then you should add the executable file to your PATH, or create a link to the executable in `/usr/bin` (on Linux), or create an alias in your `.bash_rc` (on Linux), so you don't have to enter the full path of the executable when you want to run the app.

Then you can run the following command on any system (even Windows) and from any directory: `hello-netcoreapp`

### Docker container

Run: `docker run --rm my/hello-netcoreapp`

This works on Linux with the image for the Linux container, and on Windows with both, the image for the Linux container as well as the image for the Windows container. On Windows you can configure which kind of containers you want to run.

TODO
----

- Add SCD scripts for Linux
- Add SCD scripts for building via Docker container
- Create automated build on Docker Hub
- Add AppVeyor build file
- Add versioning
- Make SCD with smaller footprint, see [here](https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/deploy-with-cli#small-footprint-self-contained-deployment) (but only if targeting netstandard doesn't have drawbacks versus targeting netcoreapp)
- Add Dockerfile for image using SCD
- Move Dockerfiles to `/docker` directory, change scripts, Dockerfiles and README accordingly
