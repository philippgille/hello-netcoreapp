**hello-netcoreapp** Docker Image
=================================

*hello-netcoreapp* is a basic .NET Core console application that prints "Hello World!". Its source code repository contains additional scripts and files for building the app and creating release artifacts for a framework-dependent deployment (FDD), self-contained deployment (SCD), Docker image, Chocolatey package and AppImage. So the purpose of this app is not the app itself, but to showcase how to build the aforementioned release artifacts.

This Docker image is one of those artifacts and allows you to execute the .NET Core application without having to install .NET Core.

Supported Linux amd64 tags and respective `Dockerfile` links
------------------------------------------------

- [`latest` (docker/Dockerfile)](https://github.com/philippgille/hello-netcoreapp/blob/master/docker/Dockerfile)
- [`develop` (docker/Dockerfile)](https://github.com/philippgille/hello-netcoreapp/blob/develop/docker/Dockerfile)

Supported Linux arm32 tags and respective `Dockerfile` links
------------------------------------------------

- [`arm32` (docker/Dockerfile.arm32)](https://github.com/philippgille/hello-netcoreapp/blob/master/docker/Dockerfile.arm32)
- [`develop-arm32` (docker/Dockerfile.arm32)](https://github.com/philippgille/hello-netcoreapp/blob/develop/docker/Dockerfile.arm32)

Usage
-----

`docker run philippgille/hello-netcoreapp`

About the Docker Image build process
-------------------------------------

The build is automated on Docker Cloud, which pushes the images to the Docker Hub registry. This is because Docker Hub doesn't support multi-stage Dockerfile builds as of now (2017-07-08), which is also the reason why the automated build appears to fail. The images pushed by Docker Cloud are automated and work fine though.

Detailed information
--------------------

To learn more about hello-netcoreapp, visit [https://github.com/philippgille/hello-netcoreapp](https://github.com/philippgille/hello-netcoreapp)
