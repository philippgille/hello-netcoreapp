hello-netcoreapp
================

hello-netcoreapp is a basic *.NET Core* application with additional scripts and files for building and publishing the app as *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker image*.

You can fork this repository and use the files as a starting point for your .NET Core app.

The basic app was created using `dotnet new console` with the .NET Core SDK 1.1 (or rather SDK 1.0.1 and Shared Framework Host 1.1.1).

Terminology:

- FDD: The app relies on an installed version of the *.NET Core* runtime. But it's completely portable to all operating systems where the runtime is installed.
- SCD: The app is completely self-contained. .NET Core runtime files are delivered with the executable, making this package slightly bigger than an FDD. It's independent of an installed .NET Core runtime, but not portable, so multiple SCDs must be created and each one only runs on a single operating system. For a list of supported OSs, see [https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog](https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog).
- Docker image: The app can be run as Docker container (Linux and Windows), which is based on the official [Microsoft/dotnet Docker image](https://hub.docker.com/r/microsoft/dotnet/), using the image for FDDs that Microsoft recommends for use in production.

For more info about FDD and SCD see: [https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/](https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/)

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
- If you're using Linux and you have the .NET Core SDK installed, run: `publish-scd.sh`
    - It will create archives for each runtime identifier specified in the csproj file, for example `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`
- If you're using Windows and you have Docker installed and configured to use Linux containers, run: `publish-scd-docker.ps1`
    - It will create archives for each runtime identifier specified in the csproj file, for example `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`
- If you're using Linux and you have Docker installed, run: `publish-scd-docker.sh`
    - It will create archives for each runtime identifier specified in the csproj file, for example `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`

Additionally to the default SCD, you can also create a "small footprint SCD", which targets `netstandard1.6` instead of `netcoreapp1.1`, making the published files smaller. This requires a change in the csproj file though and makes it incompatible with FDD. Also, the size gain is not very big:

- With `netcoreapp1.1`: 45-55 MB published directory, 20 MB archive
- With `netstandard1.6`: 30-40 MB published directory, 13-15 MB archive

This is for a simple "Hello World" app. For a bigger app with third-party dependencies the size difference is even smaller.

### Docker image

1. First run any of the FDD publish scripts, so that there's `publish/output/hello-netcoreapp_netcoreapp1.1`
2. In the root directory of the repository, depending on which container host system you want to target:
    - For Linux containers, run: `docker build -t my/hello-netcoreapp .`
        - You can do this on both Linux and Windows
    - For Windows containers, run: `docker build -t my/hello-netcoreapp -f Dockerfile.nano .`
        - Note 1: This is not needed for running a Linux container on Windows, which works just fine with Hyper-V. This is specifically for *Windows containers*.
        - Note 2: You can't build Windows containers in Linux.

Run
---

You can run the console app either as *framework-dependent deployment* (FDD), *self-contained deployment* (SCD) or *Docker container*.

### FDD

As mentioned before, you need to have the .NET Core runtime installed for running the FDD.

After building the FDD, you can copy the archive (`hello-netcoreapp_netcoreapp1.1.zip` or `hello-netcoreapp_netcoreapp1.1.tar.gz`) to wherever you want to run the app, extract the archive and run:

- `dotnet path/to/hello-netcoreapp.dll`

### SCD

After building the SCD, you can copy the archive (for example `hello-netcoreapp_ubuntu.16.04-x64.zip` or `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`) to wherever you want to run the app (only the OS has to match), extract the archive and run:

- `path/to/hello-netcoreapp`

### Docker container

After building the image, it's available in the local image cache.

Run: `docker run --rm my/hello-netcoreapp`

Note: This works on Linux with the image for the Linux container, and on Windows with both, the image for the Linux container as well as the image for the Windows container. On Windows you can configure which kind of containers you want to run.

Simplify running the app
------------------------

The app is portable, meaning the FDD or SCD can reside anywhere on your system (for example in `$env:USERPROFILE\MyPortableApps\hello-netcoreapp` on Windows or `$HOME/myPortableApps/hello-netcoreapp` on Linux), and Docker containers can be run anywhere anyway.

Now you should do the following, so you don't have to enter the full path of the executable (for FDD / SCD) or full docker command when you want to run the app:

- On Windows: Create a function (like an alias, but supports passing arguments) for the app for PowerShell:
    1. Edit the file returned by `$PROFILE.CurrentUserAllHosts` and add:
        - For FDD: `function hello-netcoreapp { dotnet $env:USERPROFILE\MyPortableApps\hello-netcoreapp\hello-netcoreapp.dll $args }`
        - For SCD: `function hello-netcoreapp { $env:USERPROFILE\MyPortableApps\hello-netcoreapp\hello-netcoreapp.exe $args }`
        - For Docker: `function hello-netcoreapp { docker run --rm my/hello-netcoreapp $args }`
    1. Source your Profile so that the alias becomes available immediately: `. $PROFILE.CurrentUserAllHosts`
- On Linux: Create a function (like an alias, but supports passing arguments) for the app for Bash:
        1. Edit `~/.bashrc` and add:
        - For FDD: `function hello-netcoreapp() { dotnet $HOME/myPortableApps/hello-netcoreapp/hello-netcoreapp.dll $@; }`
        - For SCD: `function hello-netcoreapp() { $HOME/myPortableApps/hello-netcoreapp/hello-netcoreapp $@; }`
        - For Docker: `function hello-netcoreapp() { docker run --rm my/hello-netcoreapp $@; }`
        1. Source your bashrc so that the alias becomes available immediately: `source ~/.bashrc`
- Linux alternative for SCD: Create a symbolic link in a directory that's already in the PATH:
    - `ln -s $HOME/myPortableApps/hello-netcoreapp/hello-netcoreapp /usr/local/bin/hello-netcoreapp`

Now you can run the following command on any OS and from any directory (and also pass arguments):

- `hello-netcoreapp`

Note: You shouldn't add the directory to the PATH, because the directory contains many files and you don't want tab auto-completion for files like `hello-netcoreapp.deps.json`.

---

TODO
----

- Add AppVeyor build file
- Create automated build on Docker Hub
    - Probably only possible with .NET Core SDK image, because otherwise there's no published app for the FDD image?
- Add scripts for building via Windows Docker containers (might not be possible because of the use of .NET framework classes, which might not be available in *nanoserver*)
- Make SCD with smaller footprint, see [here](https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/deploy-with-cli#small-footprint-self-contained-deployment) (but only if targeting netstandard doesn't have drawbacks versus targeting netcoreapp)
- Add Dockerfile for image using SCD
- Add versioning
- Maybe move Dockerfiles (and change them accordingly)
    - Note: You can't `COPY ../something`, because it leads to the error *Forbidden path outside the build context*.
    - Maybe move to `/src`, and also change all publish scripts to output to `/src/published` instead of `/publish/output` (because the Dockerfile requires the published app).
