# Dockerfile for creating a Docker image that contains the .NET Core app's FDD
# It makes use of multi-stage builds and requires Docker 17.05 or later:
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/

# Builder image
# Don't bother to clean up the image - it's only used for building

# Use philippgille/dotnet-libglib as long as the AppImage gets created in build.sh.
# In the final Docker image the AppImage isn't needed, so "FROM microsoft/dotnet:2.0-sdk" would suffice.
FROM philippgille/dotnet-libglib:2.0-sdk as builder

WORKDIR /app
# Make use of Docker layering: cached layer
COPY src/*.csproj src/
RUN dotnet restore src/hello-netcoreapp.csproj
# Make use of Docker layering: new layer
COPY . .
RUN scripts/build.sh "fdd" "netcoreapp2.0"

# Runtime image

FROM microsoft/dotnet:2.0-runtime-stretch-arm32v7

LABEL maintainer "Philipp Gille"

WORKDIR /app
COPY --from=builder /app/artifacts/hello-netcoreapp_v*_netcoreapp2.0 ./

ENTRYPOINT ["dotnet", "hello-netcoreapp.dll"]
