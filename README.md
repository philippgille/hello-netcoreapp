Branch | Windows</br>(scripts/build.ps1) | Linux</br>(scripts/build.sh) | Docker</br>(Dockerfile) | Code quality
------ | :-----------------------------: | :--------------------------: | :---------------------: | :----------:
master | [![Build status](https://ci.appveyor.com/api/projects/status/qpjoubjrj9hk4996/branch/master?svg=true)](https://ci.appveyor.com/project/philippgille/hello-netcoreapp/branch/master) | TODO | [![Docker Automated build](https://img.shields.io/docker/automated/philippgille/hello-netcoreapp.svg)](https://hub.docker.com/r/philippgille/hello-netcoreapp/) | [![Codacy Badge](https://api.codacy.com/project/badge/Grade/27c2c07b54b24239b203382131d5d44b)](https://www.codacy.com/app/philippgille/hello-netcoreapp)
develop | [![Build status](https://ci.appveyor.com/api/projects/status/qpjoubjrj9hk4996/branch/develop?svg=true)](https://ci.appveyor.com/project/philippgille/hello-netcoreapp/branch/develop) | TODO | [![Docker Automated build](https://img.shields.io/docker/automated/philippgille/hello-netcoreapp.svg)](https://hub.docker.com/r/philippgille/hello-netcoreapp/) | [![Codacy Badge](https://api.codacy.com/project/badge/Grade/27c2c07b54b24239b203382131d5d44b?branch=develop)](https://www.codacy.com/app/philippgille/hello-netcoreapp)

hello-netcoreapp
================

hello-netcoreapp is a basic *.NET Core* console application that prints "Hello World!". This repository contains additional scripts and files for building the app and creating release artifacts for a *framework-dependent deployment* (FDD), *self-contained deployment* (SCD), *Docker image*, *Chocolatey package* and *AppImage*.

This repository is meant to be a starting point for any new .NET Core console application. You can fork it and base your project upon it. If you improve anything in your fork, please create a PR ☺ .

The basic app was created using `dotnet new console` with the .NET Core SDK 1.1 (or rather SDK 1.0.1 and Shared Framework Host 1.1.1).

Contents
--------

- Terminology
- Directory structure
- Build
- Run
- Uninstall

Terminology
-----------

- > *FDD* - Framework-dependent deployment:

    The app relies on an installed version of the *.NET Core* runtime. But it's completely portable to all operating systems where the runtime is installed.
- > *SCD* - Self-contained deployment:

    The app is completely *self-contained*. .NET Core runtime files are delivered with the executable, making this package slightly bigger than an FDD. It's independent of an installed .NET Core runtime, but not portable, so multiple SCDs must be created and each one only runs on a single operating system. For a list of supported OSs, see [https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog](https://docs.microsoft.com/en-us/dotnet/articles/core/rid-catalog).
- > *Docker image*:

    The app can be run as Docker container (Linux and Windows), which is based on the official [Microsoft/dotnet Docker image](https://hub.docker.com/r/microsoft/dotnet/), using the image for FDDs that Microsoft recommends for use in production.
- > *Chocolatey package*:

    Chocolatey is a package manager for Windows, allowing you to install apps with one CLI command. Its package format is very similar to NuGet's. See [https://chocolatey.org/](https://chocolatey.org/) for details.
- > *AppImage*:

    AppImage is a new packaging format that allows you to execute an app on most Linux distributions without having to install any runtimes, dependencies or the app itself. It's portable, can optionally be integrated into the OS (MIME type registration, inclusion in start menu, ...) and optionally run in a sandbox like [Firejail](https://github.com/netblue30/firejail). See [http://appimage.org/](http://appimage.org/) for details.

For more info about FDD and SCD see: [https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/](https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/)

Directory structure
-------------------

- `.vscode/`: Contains files for debugging the app and the PowerShell scripts in Visual Studio Code
    - Used in case you open the root directory of the repository as workspace in Visual Studio Code
- `appimage/`: Contains files related to the AppImage
- `artifacts/`: Not contained in the git repository, but gets created when one of the build scripts is run
    - After a build script is run it contains the resulting release artifacts, such as `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`
- `docker/`: Dockerfiles for building Docker images for Linux and Windows containers with the app
- `src/`: Contains the application source code, basically just a main class (`Program.cs`) and project file (`hello-netcoreapp.csproj`)
    - `.vscode/`: Contains files for debugging the app in Visual Studio Code
        - Used in case you open the src directory of the repository as workspace in Visual Studio Code
- `chocolatey/`: Contains files related to the Chocolatey package
    - The `hello-netcoreapp.nuspec` describes the package, the `README.md` is shown on Chocolatey or MyGet after publishing
- `scripts/`: Contains scripts for building the app and creating release artifacts
    - The `*.ps1` scripts are for use in Windows (PowerShell), the `*.sh` scripts are for use in Linux.
- `.travis.yml`: Configuration file for Travis CI (Continuous Integration and Deployment cloud service, Linux)
- `appveyor.yml`: Configuration file for AppVeyor (Continuous Integration and Deployment cloud service, Windows)

Build
-----

### Via cloud service

#### AppVeyor

This repository contains `appveyor.yml`, which is a configuration file for the CI / CD cloud service [AppVeyor](https://ci.appveyor.com/project/philippgille/hello-netcoreapp).

It's configured to do the following:

1. Run the build script `build.ps1`, which produces `*.zip` archives for FDD and SCD, as well as a Chocolatey package
2. If a *Git tag* was pushed:
    - Deploy all artifacts to [this repository's GitHub Releases](https://github.com/philippgille/hello-netcoreapp/releases)
        > Note: For adhering to the [Semantic Versioning](http://semver.org/) rules a "v" must be prepended before the actual version number
    
    - Deploy the Chocolatey package to [this app's MyGet feed](https://www.myget.org/gallery/hello-netcoreapp)

#### Travis CI

This repository contains `.travis.yml`, which is a configuration file for the CI / CD cloud service [Travis CI](https://travis-ci.org/philippgille/hello-netcoreapp).

It's currently only configured to run the build script `build.sh` to make sure it works, and not to store build artifacts anywhere.

#### Docker Cloud

The Docker image for Linux containers gets automatically build by Docker Cloud and pushed to the [Docker Hub repository](https://hub.docker.com/r/philippgille/hello-netcoreapp/). This is because Docker Hub itself doesn't support multi-stage builds as of now (2017-07-08).

### Locally

You can create the *FDD*, *SCD*, *Docker image*, *Chocolatey package* and *AppImage* locally as well.

- For building an FDD and SCD you need to have *either* the .NET Core SDK *or* Docker installed
- For building the Docker image you need to have Docker installed
- For building the Chocolatey package you need to use Windows and have Chocolatey installed
- For building the AppImage you need to *either* use Linux *or* have Docker installed

#### FDD + SCD + Chocolatey package + AppImage

Depending on your OS and installed software, run the following scripts:

System | Installed | Run | Artifacts
-------|-----------|-----|----------
Windows | .NET Core SDK | `build.ps1` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.zip`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.zip`</li><li>Chocolatey package (if installed): `hello-netcoreapp.portable.0.1.0.nupkg`</li></ul>
Windows | Docker | `build-with-docker.ps1` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.tar.gz`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`</li><li>AppImage: `hello-netcoreapp_ubuntu.16.04-x64.AppImage`</li></ul>
Linux | .NET Core SDK | `build.sh` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.tar.gz`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`</li><li>AppImage: `hello-netcoreapp_ubuntu.16.04-x64.AppImage`</li></ul>
Linux | Docker | `build-with-docker.sh` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.tar.gz`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`</li><li>AppImage: `hello-netcoreapp_ubuntu.16.04-x64.AppImage`</li></ul>

The SCDs that are built depend on the runtime identifiers in the `.csproj`. To add or remove SCDs, just edit that file accordingly.

##### Small footprint SCD

Additionally to the default SCD, you can also create a "small footprint SCD", which targets `netstandard1.6` instead of `netcoreapp1.1`, making the published files smaller. This requires a change in the csproj file though and makes it incompatible with FDD. Also, the size gain is not very big:

- With `netcoreapp1.1`: 45-55 MB published directory, 20 MB archive
- With `netstandard1.6`: 30-40 MB published directory, 13-15 MB archive

This is for a simple "Hello World" app. For a bigger app with third-party dependencies the size difference is even smaller.

#### Docker image

> Note: A prerequisite when running Windows is to make sure that `scripts/build.sh` and `src/hello-netcoreapp.csproj` line endings are LF instead of CRLF. Even when saving all files with LF and commiting them to the Git repo that way, Git has an option `core.autocrlf` that converts line endings when checking out a repository or branch depending on the configuration value.

In the root directory of the repository, depending on which container host system you want to target:

- For Linux containers, run: `docker build -f docker/Dockerfile -t local/hello-netcoreapp .`
    - You can do this on both Linux and Windows
- For Windows containers, you must first build the app's FDD and then create the Docker image:
    1. Run any of the build scripts, so that there's `artifacts/hello-netcoreapp_netcoreapp1.1`
    2. `docker build -f docker/Dockerfile.nano -t local/hello-netcoreapp .`

> Note 1: You don't need to create a Windows container image for using Docker in Windows. Linux containers work just fine on Windows with Hyper-V. Creating a Windows container image is specifically for actual *Windows containers*, see [https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/).

> Note 2: You can't build Windows containers in Linux.

Run
---

You can run the console app either as *FDD*, *SCD*, *Docker container*, *Chocolatey package* or *AppImage*.

All artifacts are available for download from [this repository's GitHub Releases](https://github.com/philippgille/hello-netcoreapp/releases). The Chocolatey package is also available on [this app's MyGet feed](https://www.myget.org/gallery/hello-netcoreapp).

Alternatively you can build the artifacts on your own (see the *Build* section in this README).

### FDD

As mentioned before, you need to have the .NET Core runtime installed for running the FDD.

You can copy the archive (`hello-netcoreapp_netcoreapp1.1.zip` or `hello-netcoreapp_netcoreapp1.1.tar.gz`) to wherever you want to run the app, extract the archive and run:

- `dotnet path/to/hello-netcoreapp.dll`

### SCD

You can copy the archive (for example `hello-netcoreapp_ubuntu.16.04-x64.zip` or `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`) to wherever you want to run the app (only the OS has to match), extract the archive and run:

- `path/to/hello-netcoreapp`

### Docker container

- The simplest way is to create the Docker container from the Docker image on Docker Hub:
    - `docker run philippgille/hello-netcoreapp`
        > Note: This currently only works for Linux containers (on either Linux or Windows)
- Alternatively you can build the image locally (see the *Build* section in this README) and then create a container from the image in the local image cache:
    - `docker run local/hello-netcoreapp`
        > Note: This works on Linux with the Linux container image, and on Windows with both the Linux and Windows container images (on Windows you can configure which kind of containers you want to run)

### Chocolatey package

> Note: You can only install and run Chocolatey packages on Windows!

First you need to install the package with one of the following ways:

- The simplest way to install it is via the MyGet feed, which also allows you to easily update the app later:
    - `choco install hello-netcoreapp.portable --source https://www.myget.org/F/hello-netcoreapp`
- AppVeyor also automatically publishes all `*.nupkg` artifacts to a project's NuGet feed, so this works as well:
    - `choco install hello-netcoreapp.portable --source https://ci.appveyor.com/nuget/hello-netcoreapp`
- Alternatively install the downloaded or locally built package:
    - `choco install path\to\hello-netcoreapp.portable.0.1.0.nupkg`
- Alternatively you can also install via the package specification file in this repository:
    1. Either run `build.ps1` or manually place `artifacts\hello-netcoreapp_win10-x64` in `chocolatey\tools`
    2. `choco install chocolatey\hello-netcoreapp.nuspec`

Then run: `hello-netcoreapp`

> Note: The package is installed in `%ChocolateyInstall%/lib` (e.g. `C:\ProgramData\Chocolatey\lib`)

### AppImage

> Note: You can only use AppImages on Linux and you must *either* have fuse installed *or* mount or extract the AppImage, see [AppImage/AppImageKit/wiki/FUSE](https://github.com/AppImage/AppImageKit/wiki/FUSE)

After downloading the AppImage, you have to make it executable: `chmod u+x hello-netcoreapp_ubuntu.16.04-x64.AppImage`

Then run: `hello-netcoreapp_ubuntu.16.04-x64.AppImage`

For integrating the AppImage into your OS (MIME type registration, start menu), you can run the optional AppImage daemon. Read more about it here: [https://github.com/AppImage/AppImageKit/blob/appimagetool/master/README.md#appimaged-usage](https://github.com/AppImage/AppImageKit/blob/appimagetool/master/README.md#appimaged-usage)

Simplify running the app
------------------------

> Note: This is not necessary if you installed the app with Chocolatey.

The app is portable, meaning the FDD or SCD can reside anywhere on your system (for example in `$env:USERPROFILE\MyPortableApps\hello-netcoreapp` on Windows or `$HOME/myPortableApps/hello-netcoreapp` on Linux), and Docker containers can be run anywhere anyway.

Now you should do the following, so you don't have to enter the full path of the executable (for FDD / SCD) or full docker command when you want to run the app:

- On Windows: Create a function (like an alias, but supports passing arguments) for the app for PowerShell:
    1. Edit the file returned by `$PROFILE.CurrentUserAllHosts` and add:
        - For FDD: `function hello-netcoreapp { dotnet $env:USERPROFILE\MyPortableApps\hello-netcoreapp\hello-netcoreapp.dll $args }`
        - For SCD: `function hello-netcoreapp { $env:USERPROFILE\MyPortableApps\hello-netcoreapp\hello-netcoreapp.exe $args }`
        - For Docker: `function hello-netcoreapp { docker run --rm local/hello-netcoreapp $args }`
    1. Source your Profile so that the alias becomes available immediately: `. $PROFILE.CurrentUserAllHosts`
- On Linux: Create a function (like an alias, but supports passing arguments) for the app for Bash:
    1. Edit `~/.bashrc` and add:
        - For FDD: `function hello-netcoreapp() { dotnet $HOME/myPortableApps/hello-netcoreapp/hello-netcoreapp.dll $@; }`
        - For SCD: `function hello-netcoreapp() { $HOME/myPortableApps/hello-netcoreapp/hello-netcoreapp $@; }`
        - For Docker: `function hello-netcoreapp() { docker run --rm philippgille/hello-netcoreapp $@; }`
    1. Source your bashrc so that the alias becomes available immediately: `source ~/.bashrc`
- Linux alternative for SCD: Create a symbolic link in a directory that's already in the PATH:
    - `ln -s $HOME/myPortableApps/hello-netcoreapp/hello-netcoreapp /usr/local/bin/hello-netcoreapp`

Now you can run the following command on any OS and from any directory (and also pass arguments):

- `hello-netcoreapp`

> Note: You shouldn't add the whole app directory to the PATH, because the directory contains many files and in some cases this leads to tab auto-completion for files like `hello-netcoreapp.deps.json`.

Uninstall
---------

- FDD:
    1. Delete the directory that contains the `hello-netcoreapp.dll`
    2. Remove the function from your PowerShell profile / `~/.bashrc` in case you set it
- SCD:
    1. Delete the directory that contains the `hello-netcoreapp.exe` (Windows) / `hello-netcoreapp` (Linux)
    2. Remove the function from your PowerShell profile / `~/.bashrc` in case you set it
- Docker image:
    1. Delete the container: `docker container rm <id>`
    2. Delete the image: `docker image rm philippgille/hello-netcoreapp`
- Chocolatey package:
    - `choco uninstall hello-netcoreapp.portable`
- AppImage:
    - Just delete the `*.AppImage` file
