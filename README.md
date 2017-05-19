Branch | scripts/build.ps1 | scripts/build.sh
-------| :---------------: | :--------------:
master | [![Build status](https://ci.appveyor.com/api/projects/status/qpjoubjrj9hk4996/branch/master?svg=true)](https://ci.appveyor.com/project/philippgille/hello-netcoreapp/branch/master) | TODO
develop | [![Build status](https://ci.appveyor.com/api/projects/status/qpjoubjrj9hk4996/branch/develop?svg=true)](https://ci.appveyor.com/project/philippgille/hello-netcoreapp/branch/develop) | TODO

hello-netcoreapp
================

hello-netcoreapp is a basic *.NET Core* console application that prints "Hello World!". This repository contains additional scripts and files for building the app and creating release artifacts for a *framework-dependent deployment* (FDD), *self-contained deployment* (SCD), *Docker image* and *Chocolatey package*.

This repository is meant to be a starting point for any new .NET Core console applications. You can fork it and base your project upon it. If you improve anything in your fork, please create a PR ☺ .

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

For more info about FDD and SCD see: [https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/](https://docs.microsoft.com/en-us/dotnet/articles/core/deploying/)

Directory structure
-------------------

- `.vscode/`: Contains files for debugging the app and the PowerShell scripts in Visual Studio Code
    - Used in case you open the root directory of the repository as workspace in Visual Studio Code
- `artifacts/`: Not contained in the git repository, but gets created when one of the build scripts is run
    - After a build script is run it contains the resulting release artifacts, such as `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`
- `src/`: Contains the application source code, basically just a main class (`Program.cs`) and project file (`hello-netcoreapp.csproj`)
    - `.vscode/`: Contains files for debugging the app in Visual Studio Code
        - Used in case you open the src directory of the repository as workspace in Visual Studio Code
- `chocolatey/`: Contains files related to the Chocolatey package
    - The `hello-netcoreapp.nuspec` describes the package, the `README.md` is shown on Chocolatey or MyGet after publishing
- `scripts/`: Contains scripts for building the app and creating release artifacts
    - The `*.ps1` scripts are for use in Windows (PowerShell), the `*.sh` scripts are for use in Linux.
- `appveyor.yml`: Configuration file for AppVeyor (Continuous Integration and Deployment cloud service)
- `Dockerfile`: The Dockerfile for building a Docker image for Linux containers with the app
- `Dockerfile.nano`: The Dockerfile for building a Docker image for Windows containers with the app

Build
-----

### Via cloud service

This repository contains `appveyor.yml`, which is a configuration file for the CI / CI cloud service [AppVeyor](https://www.appveyor.com/).

It's configured to do the following:

1. Run the build script `build.ps1`, which produces `*.zip` archives for FDD and SCD, as well as a Chocolatey package
2. If a *Git tag* was pushed:
    - Deploy all artifacts to [this repository's GitHub Releases](https://github.com/philippgille/hello-netcoreapp/releases)
        - > Note: For adhering to the [Semantic Versioning](http://semver.org/) rules a "v" must be prepended before the actual version number
    
    - Deploy the Chocolatey package to [this app's MyGet feed](https://www.myget.org/gallery/hello-netcoreapp)

### Locally

You can create the *FDD*, *SCD*, *Docker image* and *Chocolatey package* locally as well.

- For building an FDD and SCD you need to have *either* the .NET Core SDK *or* Docker installed
- For building the Docker image you need to have Docker installed
- For building the Chocolatey package you need to have Chocolatey installed.

#### FDD + SCD + Chocolatey package

Depending on your OS and installed software, run the following scripts:

System | Installed | Run | Artifacts
-------|-----------|-----|----------
Windows | .NET Core SDK | `build.ps1` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.zip`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.zip`</li><li>Chocolatey package (if installed): `hello-netcoreapp.portable.0.1.0.nupkg`</li></ul>
Windows | Docker | `build-with-docker.ps1` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.tar.gz`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`</li></ul>
Linux | .NET Core SDK | `build.sh` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.tar.gz`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`</li></ul>
Linux | Docker | `build-with-docker.sh` | <ul><li>FDD: `hello-netcoreapp_netcoreapp1.1.tar.gz`</li><li>SCDs, e.g. `hello-netcoreapp_ubuntu.16.04-x64.tar.gz`</li></ul>

The SCDs that are built depend on the runtime identifiers in the `.csproj`. To add or remove SCDs, just edit that file accordingly.

##### Small footprint SCD

Additionally to the default SCD, you can also create a "small footprint SCD", which targets `netstandard1.6` instead of `netcoreapp1.1`, making the published files smaller. This requires a change in the csproj file though and makes it incompatible with FDD. Also, the size gain is not very big:

- With `netcoreapp1.1`: 45-55 MB published directory, 20 MB archive
- With `netstandard1.6`: 30-40 MB published directory, 13-15 MB archive

This is for a simple "Hello World" app. For a bigger app with third-party dependencies the size difference is even smaller.

#### Docker image

1. First run any of the build scripts, so that there's `artifacts/hello-netcoreapp_netcoreapp1.1`
2. In the root directory of the repository, depending on which container host system you want to target:
    - For Linux containers, run: `docker build -t my/hello-netcoreapp .`
        - You can do this on both Linux and Windows
    - For Windows containers, run: `docker build -t my/hello-netcoreapp -f Dockerfile.nano .`
        - > Note 1: This is not needed for running a Linux container on Windows, which works just fine with Hyper-V. This is specifically for *Windows containers*.

        - > Note 2: You can't build Windows containers in Linux.

Run
---

You can run the console app either as *FDD*, *SCD*, *Docker container* or *Chocolatey package*.

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

Running the app as Docker container currently requires you to build the image locally (see the *Build* section in this README). After building the image, it's available in the local image cache.

Run: `docker run --rm my/hello-netcoreapp`

> Note: This works on Linux with the image for the Linux container, and on Windows with both the image for the Linux container as well as the image for the Windows container. On Windows you can configure which kind of containers you want to run.

### Chocolatey package

> Note: You can only install and run Chocolatey packages on Windows!

First you need to install the package:

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

Simplify running the app
------------------------

> Note: This is not necessary if you installed the app with Chocolatey.

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

> Note: You shouldn't add the directory to the PATH, because the directory contains many files and you don't want tab auto-completion for files like `hello-netcoreapp.deps.json`.

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
    2. Delete the image: `docker image rm my/hello-netcoreapp`
- Chocolatey package:
    - `choco uninstall hello-netcoreapp.portable`

---

TODO
----

### Docker

- Create automated build on Docker Hub
    - Probably only possible with .NET Core SDK image, because otherwise there's no published app for the FDD image?
- Add scripts for building via Windows Docker containers
    - Might not be possible because of the use of .NET framework classes, which might not be available in *nanoserver*
- Add Dockerfile for image using SCD
- Maybe move Dockerfiles (and change them accordingly)
    - You can't `COPY ../something`, because it leads to the error "*Forbidden path outside the build context*".
    - Maybe move to `src/`, and also change all publish scripts to output to `src/artifacts/` instead of `artifacts/` (because the Dockerfile requires the published app)
    - Or probably better: When running `docker build`, the build context gets passed, which could be `artifacts/`, then from within the Dockerfile that's `.`
        - Nope - "*unable to prepare context: The Dockerfile must be within the build context*"

### CI / CD

- Add Travis CI build file
- Add versioning
- Add building Chocolatey package in `build.sh` as well (which would make it working in the `build-with-docker.*` scripts as well)
    - Alternatively, use a Docker image that contains the .NET Core SDK as well as Chocolatey (and thus Mono)
        - For Chocolatey in a container, see [this article](http://www.onitato.com/running-chocolatey-on-linux.html), the corresponding [GitHub repo](https://github.com/Linuturk/mono-choco) and the [docker directory in the Chocolatey repository](https://github.com/chocolatey/choco/tree/master/docker).
- Fix installing Chocolatey package via OneGet doesn't lead to the app being available on the PATH
    - See [this Chocolatey OneGet GitHub issue comment](https://github.com/chocolatey/chocolatey-oneget/issues/2#issuecomment-301299133)
- Add building Chocolatey packages for other OSs than win10-x64 *if necessary*
- Add building NuGet package containing the executable app via `dotnet pack` *if possible*
    - Seems to build an FDD, so not executable without .NET Core runtime
- Add scripts for deploying to "GitHub Releases" and MyGet locally (instead of just on AppVeyor)
- Add signing
- Add creating Debian package
- Add creating Vagrantfile or use [Packer](https://www.packer.io/) to create images for multiple Cloud hosters
- Add creating Flatpak, AppImage, Snap

### Other

- Fix line break issues when running build script on Windows in Git Bash
- Put TODOs in GitHub issues instead of this README
