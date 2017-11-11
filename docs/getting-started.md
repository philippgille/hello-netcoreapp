Getting started
===============

This page contains a step-by-step guide about what you need to do after forking this repository or downloading its files to start your own *.NET Core CLI app*.

> Note: This article is work in progress and the steps haven't been tested yet in a cloned repository.

Steps
-----

1. Either fork the repository or download its files
1. Go through the following directories and change the following files:
    - `.vscode/`: Change `hello-netcoreapp` in both files to your app's name
    - `appimage/`:
        - `AppRun`: Change the content from `hello-netcoreapp` to your app's name
        - `hello-netcoreapp.desktop`: Change the file name and `hello-netcoreapp` inside the file to your app's name, as well as the `Comment` in the file to whatever you'd like to have as comment
        - `hello-netcoreapp.svg`: Change the file name to your app's name, and completely replace the content by a logo of your app as SVG. It should be 48x48.
    - `chocolatey/`:
        - `*.nuspec`: Change the file names to your app's name, and go through the content of *one* of the files and change occurences of `hello-netcoreapp` to your app's name. Also change other parts of the content to your liking. Then copy the content to the other `*.nuspec`. The only difference should be that the `*portable*` one has a section for `files` but no `dependencies`, while the other has it the other way around. The non-portable one is just a meta package that "points" to the portable package. See the [Chocolatey FAQ regarding meta packages](https://chocolatey.org/docs/chocolatey-faqs#what-is-the-difference-between-packages-no-suffix-as-compared-to-install-portable).
        - `README.md`: This content of this file is shown on Chocolatey and MyGet, when you set them up (more on that later). This requires the proper URL to the README to be included in the `*.nuspec` though (which requires you to know your GitHub repository URL).
    - `docker/`:
        - `Dockerfile*`: Change the `LABEL maintainer` to your Docker Hub username and change all occurences of `hello-netcoreapp` to your app's name.
        - `README.md`: The content of this file gets shown on Docker Hub. This requires you to set up a Docker Hub repository (more on that later).
    - `docs/`: You probably want to replace all documentation by your own. Just keep (and change) the `README.md`
    - `scripts/`: You only need to change the `APP_NAME`. There's nothing hard coded into the scripts that you need to change.
    - `src/`: This is where you'll put all the code for your app.
        - `.vscode/`: Change `hello-netcoreapp` in both files to your app's name
        - `hello-netcoreapp.csproj`: Rename the file to your app's name. You can optionally change the `TargetFrameworks` and `RuntimeIdentifiers` in the `*.csproj`.
    - `.appveyor.yml`: Change `hello-netcoreapp` to your app's name. We advise you to change `force_update` to `false`.
    - `.travis.yml`: Change `hello-netcoreapp` to your app's name. We advise you to change `overwrite` to `false`.
    - `CONTRIBUTING.md`: This file contains the labels that are set up in the GitHub repository. You might want to change that section.
    - `README.md`: You should only need to change the links of the badges, the introductory text that describes your app, as well as replace all occurences of `hello-netcoreapp` by your app's name. This requires you to have set up some accounts (build services, code quality check, MyGet feed etc.) (more on that later).
1. Set up accounts. The following accounts are required to leverage all prepared functionality:
    - [GitHub](https://github.com/): GitHub is meant to host the source code repository of your app. And both AppVeyor and Travis CI deploy downloadable artifacts to "[GitHub Releases](https://help.github.com/articles/about-releases/)"
    - [AppVeyor](https://ci.appveyor.com): AppVeyor automatically builds artifacts from the source code when changes occur to the GitHub repository and deploys them. AppVeyor is Windows-based. You need to add your GitHub repository and change some of the settings.
    - [Travis CI](https://travis-ci.org): Travis CI does the same, but is Linux-based. There's a macOS option, too. You need to add your GitHub repository and change some of the settings.
    - [Docker Hub](https://hub.docker.com): The Docker image is meant to be built automatically and publicly available on Docker Hub. Please note that as of now (2017-11-11), Docker Hub doesn't support multi-stage builds, so you need to go the detour via Docker Cloud, which builds the image and pushes it to the Docker Hub registry.
    - [MyGet](https://www.myget.org): Both AppVeyor and Travis CI deploy the Chocolatey packages to MyGet. You need to create a "feed", so that AppVeyor can push Chocolatey packages to the feed.
    - [Codacy](https://www.codacy.com): For the code quality badge. Again, you must add your GitHub repository so that the service starts watching the code. You might want to change some of the rules that are used to check your code and grade it.
    - [Better Code Hub](https://bettercodehub.com/): For the other code quality badge. You also need to add your GitHub repository.
1. Build *your* app: `.\scripts\build.ps1` (on Windows) / `./scripts/build.sh` (on Linux)
