# When Docker for Windows is installed, this switches the Daemon from Windows containers to Linux containers and vice versa

$ErrorActionPreference = "Stop"

& "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon
