Used libraries and services
===========================

Boilerplate projects should follow best practices and use popular, widely-adopted and well-maintained frameworks, libraries and services.

This page lists the used libraries and services and describes why we decided to use a specific product.

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
