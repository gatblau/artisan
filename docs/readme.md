<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# Artisan

Artisan is a [command line interface (CLI)](https://en.wikipedia.org/wiki/Command-line_interface) that standardise and secure the packaging, execution and distribution of
automation code across the enterprise.

Artisan is part of the [Onix Configuration Manager](https://onix.gatblau.org) Build System that deals with *build time* configuration.

Typically, DevOps teams need to use multiple toolchains to meet the automation requirements related to building and configuring software.

Standardisation means that both development and operational teams can combine toolchains and execute them in the same consistent and secure way, regardless of the stage in the [application development lifecycle](https://en.wikipedia.org/wiki/Systems_development_life_cycle).

It facilitates the creation of a generic automation library regardless of the various chosen toolchains required to resolve a problem.

Artisan achieves this by combining the functions in the following core components:

- `the packaging engine`: packages files and unpackage files.
  
- `the execution engine`: execute logic within the packages using standard containerised runtimes with the toolchains required to run the automation. The execution engine can run different tasks with different runtime using flows(<sup>[1](#flow_footnote)</sup>).
  
- `the distribution engine`: provides the means to tag, push, pull and open packages, using cryptographic verification of author/source.
  
- `the input engine`:

- `the cryptographic engine`:
  
## Packaging engine

The packaging engine packages any files required to run a certain automation task using the [zip file](<https://en.wikipedia.org/wiki/ZIP_(file_format>) format.

## Execution engine

## Distribution engine



<a name="flow_footnote">(1)</a>: *Artisan flows are [yaml files](https://en.wikipedia.org/wiki/YAML) that simply describe a sequence of execution steps. They can be thought of as a logical pipeline and the emphasis is to make them human readable. An Artisan Runner then takes a flow and transpile it to the physical environment format where they run. For example, an Artisan Runner in Kubernetes transpiles the flow into a [Tekton](https://tekton.dev/) pipeline.*
