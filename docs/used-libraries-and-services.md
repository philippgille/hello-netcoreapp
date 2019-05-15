Used libraries and services
===========================

Boilerplate projects should follow best practices and use popular, widely-adopted and well-maintained frameworks, libraries and services.

This page lists the used libraries and services and describes why we decided to use a specific product.

Command line parsing library
----------------------------

- `CommandLineParser` ([NuGet](https://www.nuget.org/packages/commandlineparser), [GitHub](https://github.com/gsscoder/commandline)): Stable NuGet package last updated in 2013 (as of 2017-10-14). Otherwise extremely popular. And version 2.0 is actively developed, see [here](https://github.com/gsscoder/commandline/wiki/Latest-Version).
- `Microsoft.Extensions.CommandLineUtils` by Microsoft ([NuGet](https://www.nuget.org/packages/microsoft.extensions.commandlineutils/), [GitHub (in the past)](https://github.com/aspnet/Common)): Not maintained anymore, see [here](https://github.com/aspnet/Common/commit/2230370a3985fd1bbeebbdd904a3dd348f612d35), §§§. Not much documentation, but some articles: [MSDN magazine](https://msdn.microsoft.com/en-us/magazine/mt763239.aspx), [this GitHub Gist](https://gist.github.com/iamarcel/8047384bfbe9941e52817cf14a79dc34), [this blog article](https://blog.terribledev.io/Parsing-cli-arguments-in-dotnet-core-Console-App/) and [this one](https://www.areilly.com/2017/04/21/command-line-argument-parsing-in-net-core-with-microsoft-extensions-commandlineutils/). Mentioned alternatives are the official `System.Commandline` and the community fork `McMaster.Extensions.CommandLineUtils`.
- `System.Commandline` by the .NET foundation ([GitHub](https://github.com/dotnet/corefxlab/tree/master/src/System.CommandLine)): Still work in progress as you can see in the README, and also not part of the .NET class library yet, but still in the "labs". Asking questions like:
    > Should we support a case insensitive mode?  
    > Should we allow "empty" commands, so that the tool can support options without a command, like `git --version`?

Sources:
- [quozd/awesome-dotnet#cli]()https://github.com/quozd/awesome-dotnet#cli
- [*NuGet Must Haves* "commandline"](http://nugetmusthaves.com/Tag/commandline)
- [dotnet.libhunt.com "CLI"](https://dotnet.libhunt.com/categories/1779-cli)

Build / CI / CD service
-----------------------

Used:
- [AppVeyor](https://www.appveyor.com/) is the most used one across C# projects on GitHub, because they use Windows build servers, while all other popular CI services use Linux build servers
- [Travis CI](https://travis-ci.org/) is the most used one across all popular projects on GitHub

Other services (in alphabetical order):
- [Buildkite](https://buildkite.com/)
- [CircleCI](https://circleci.com/)
- [Codefresh](https://codefresh.io/) (Docker container focused)
- [Codeship](https://codeship.com/)
- [MyGet](https://www.myget.org/) ([CI documentation](https://docs.myget.org/docs/how-to/auto-trigger-a-myget-build-using-an-http-post-hook-url))
- [shippable](https://www.shippable.com/)
- [Vexor](https://vexor.io/) (only 100 minutes of free build time per month as of 2017-10-14)
- [Visual Studio Team Services](https://www.visualstudio.com/team-services/)
- [wercker (by Oracle)](http://www.wercker.com/) (Docker container focused)

Code quality / analysis service
-------------------------------

Used:
- [Codacy](https://www.codacy.com)
- [Better Code Hub](https://bettercodehub.com/)

Other services:
- [SonarQube](https://www.sonarqube.org/)
- [Code Climate](https://codeclimate.com/) (no C#)
- [Codebeat](https://codebeat.co/) (no C#)
- [SideCI](https://sideci.com/) ([no C#](https://sideci.com/en/features/tools))

Sources: Google, GitHub and [this GitHub repo](https://github.com/mre/awesome-static-analysis#web-services)

Test coverage
-------------

Nothing used yet, because there's nothing to test yet. But as soon as there will be tests, we will probably go with Coveralls and/or Codecov.
