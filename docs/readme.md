<img src="https://github.com/gatblau/artisan/raw/main/artisan.png" width="150" align="right"/>

# Artisan Package Builder and Runner

*Artisan is a [command line interface (CLI)](https://en.wikipedia.org/wiki/Command-line_interface) written in [Go](https://golang.org/) that helps to standardise and secure the packaging, execution and distribution of
disparate scripts, source code, configuration and other files across the enterprise.*

Artisan uses standard runtimes to run packages in Docker containers.

The documentation is divided in sections adding progressive knowlegde to make it easier to learn:

| section | description |
|---|---|
| [*synopsis*](synopsis.md)| provides a general overview of *Artisan* |
| [*the build file*](buildfile.md)| describes the sections in the build file, which contains the instructions used by Artisan to execute logic |
| [*functions*](function.md)| explains how to modularise execution logic using functions |
| [*packages*](package.md) | explains how to create and manage *Artisan* packages |
| [*manifests*](manifest.md) | explores package manifests and how they are used to define the API of a package |
| [*cryptography*](cryptography.md) | explores how PGP encryption is natively used to sign and verify packages |
| [*runtimes*](runtime.md) | describes how to use and create *Artisan* runtimes |
| [*execution modes*](execution.md) | describes the different ways to run functions in packages |
| [*execution flows*](flow.md) | explains how to chain function calls using different packages and / or runtimes |
| [*flow sources*](flowsource.md) | describes the different option to inject logic in execution flows |
| [*registries*](registry.md) | shows how registries work to provide a vehicle for publishing an distributing  packages |
| [*runners*](runner.md) | describes the use of runners to execute flows regardless of the implementation platform |
| [*OpenShift setup*](openshift-setup/readme.md) | explains how to setup the required services to run Artisan automation in the OpenShift container platform. |

## Get the CLI

Download the CLI for your operating system [here](../bin/).
