The build is automated on Docker Cloud, which pushes the images to the Docker Hub registry. This is because Docker Hub doesn't support multi-stage Dockerfile builds as of now (2017-07-08), which is also the reason why the automated build appears to fail. The images pushed by Docker Cloud are automated and work fine though.

To learn about hello-netcoreapp, visit [https://github.com/philippgille/hello-netcoreapp](https://github.com/philippgille/hello-netcoreapp)
