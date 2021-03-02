# Artisan

Artisan is a [command line interface (CLI)](https://en.wikipedia.org/wiki/Command-line_interface) that standardise and secure the packaging, execution and distribution of
automation code across the enterprise.

Artisan is part of the [Onix](https://onix.gatblau.org) Build System.

Typically, DevOps teams need to use multiple toolchains to meet the automation requirements related to building and configuring software.

Standardisation means that both development and operational teams can combine toolchains and execute them in the same consistent and secure way, regardless of the stage in the [application development lifecycle](https://en.wikipedia.org/wiki/Systems_development_life_cycle).

It facilitates the creation of a generic automation library regardless of the various chosen toolchains required to resolve a problem.

Artisan achieves this by combining the power of the following components:

- `the packaging engine`: packages files and digitally sign them.
  
- `the execution engine`: provides various modes for executing automation, typically using standard containerised runtimes with the toolchains required to run the automation. This means all tools are containerised and can run in container platforms.
  
- `the distribution engine`: provides the means to tag, push, pull and open packages, using cryptographic verification of author/source.
  
## Packaging engine

The packaging engine packages any files required to run a certain automation task using the [zip file](<https://en.wikipedia.org/wiki/ZIP_(file_format>) format.

## Execution engine

## Distribution engine

