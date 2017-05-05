FROM microsoft/dotnet:1.1-runtime

LABEL maintainer "Philipp Gille"

WORKDIR /dotnetapp
COPY publish/output/hello-netcoreapp_netcoreapp1.1 .

ENTRYPOINT ["dotnet", "hello-netcoreapp.dll"]