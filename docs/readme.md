<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# Artisan

Artisan is a [command line interface (CLI)](https://en.wikipedia.org/wiki/Command-line_interface) that standardise and secure the packaging, execution and distribution of
automation code across the enterprise.

Artisan is part of the [Onix Configuration Manager](https://onix.gatblau.org) Build System that deals with *build time* configuration.

Typically, DevOps teams need to use multiple toolchains to meet the automation requirements related to building and configuring software.

Standardisation means that both development and operational teams can combine toolchains and execute them in the same consistent and secure way, regardless of the stage in the [application development lifecycle](https://en.wikipedia.org/wiki/Systems_development_life_cycle).

Standardisation facilitates the creation of generic automation libraries regardless of the various chosen toolchains required to resolve a problem.

These libraries, are then placed in a registry where they can be downloaded on demand into container runtimes for execution.

:white_check_mark: [Cryptographic signatures](https://en.wikipedia.org/wiki/Digital_signature) allow Artisan to validate the package being executed comes from a trusted source and it is safe to run.

Artisan achieves this by combining the functions in the following core components:

- `the packaging engine`: packages files and unpackage files using the [zip compression format](https://en.wikipedia.org/wiki/ZIP_(file_format)).
  
- `the execution engine`: execute logic within the packages using [standard container runtimes](https://github.com/gatblau/artisan/tree/master/runtime) with different toolchains required to run the automation. The execution engine can run different tasks with different runtime using flows(<sup>[1](#flow_footnote)</sup>).
  
- `the distribution engine`: provides the means to tag, push, pull and open packages, using cryptographic verification of author/source.
  
- `the input engine`: one of the most difficult problems for usability is the management of configuration variables required by the automation to be reusable. The input engine provide options for auto generation of variable files and loading variables from different sources.

- `the crypto engine`: every package is digitally signed by default using [PGP Keys](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). When the execution engine opens a package, it verifies its digital seal to ensure it is trusted. The crypto engine can create, import, encrypt and decrypt files, and sign and verify packages.
  
## Packaging engine

In order to black box automation logic, it is neccessary to package it using a standard and reliable format. In addition, packaging allows to simplify the storage and deployment of the automation. If the packaging format also introduce lossless data compression, it can reduce bandwidth and storage requirement for packages.

The packaging engine packages any files required to run a certain automation task using the [zip file](<https://en.wikipedia.org/wiki/ZIP_(file_format>) format.

## Execution engine

## Distribution engine



<a name="flow_footnote">(1)</a>: *Artisan flows are [yaml files](https://en.wikipedia.org/wiki/YAML) that simply describe a sequence of execution steps. They can be thought of as a logical pipeline and the emphasis is to make them human readable. An Artisan Runner then takes a flow and transpile it to the physical environment format where they run. For example, an Artisan Runner in Kubernetes transpiles the flow into a [Tekton](https://tekton.dev/) pipeline.*
