# Dockerfile for creating a Docker image that contains the .NET Core app's FDD
# It makes use of multi-stage builds and requires Docker 17.05 or later:
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/

# Builder image
# Don't bother to clean up the image - it's only used for building

FROM microsoft/dotnet:1.1-sdk as builder

# The following line is needed as long as the AppImage gets created in build.sh.
# Make use of Docker layering: cached layer
RUN apt update && apt install -y libglib2.0-0

WORKDIR /dotnetapp
# Make use of Docker layering: cached layer
COPY src/ src/
RUN dotnet restore src/hello-netcoreapp.csproj
# Make use of Docker layering: new layer
COPY . .
RUN scripts/build.sh

# Runtime image

FROM microsoft/dotnet:1.1-runtime

LABEL maintainer "Philipp Gille"

WORKDIR /dotnetapp
COPY --from=builder /dotnetapp/artifacts/hello-netcoreapp_netcoreapp1.1 .

ENTRYPOINT ["dotnet", "hello-netcoreapp.dll"]
