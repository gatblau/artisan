<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# Artisan

Artisan is a [command line interface (CLI)](https://en.wikipedia.org/wiki/Command-line_interface) that standardise and secure the packaging, execution and distribution of
automation code across the enterprise.

Artisan is part of the [Onix Configuration Manager](https://onix.gatblau.org) Build System that deals with *build time* configuration.

Typically, DevOps teams need to use multiple toolchains to meet the automation requirements related to building and configuring software.

Standardisation means that both development and operational teams can combine toolchains and execute them in the same consistent and secure way, regardless of the stage in the [application development lifecycle](https://en.wikipedia.org/wiki/Systems_development_life_cycle).

Standardisation facilitates the creation of generic automation libraries regardless of the various chosen toolchains required to execute the scripts that comprise the libraries.

These libraries, are then placed in a registry where they can be pulled on demand into standard container runtimes for execution.

[Cryptographic signatures](https://en.wikipedia.org/wiki/Digital_signature) allow Artisan to validate that the package being executed comes from a trusted source and it is safe to run.

Artisan achieves all the above by combining the functions in the following core subsystems:

- `the packaging engine`: packages and unpackage files using the [zip compression format](https://en.wikipedia.org/wiki/ZIP_(file_format)).
  
- `the execution engine`: executes the logic within the packages using toolchain specific [standard containerised runtimes](https://github.com/gatblau/artisan/tree/master/runtime). The execution engine can run different functions requiring different toolchains using flows(<sup>[1](#flow_footnote)</sup>).
  
- `the distribution engine`: provides the means to tag, push, pull and open packages, enforcing the cryptographic verification of author/source.
  
- `the input engine`: to improve usability and foster reusability, automation packages must have a standard way to publish and consume variables and generate variable specifications. The input engine provide options for automated generation of variable files and loading variables from different sources.

- `the crypto engine`: every package is digitally signed by default using [PGP Keys](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). When the execution engine opens a package, it verifies its digital seal(<sup>[2](#digi_seal_footnote)</sup>) to ensure it is trusted. The crypto engine can create, import, encrypt and decrypt files, and sign and verify packages.
  
## Packaging engine

Automation typically comes as a set of disparate files that need to be executed in a particular order using specific toolchains.

This leads to difficulties in:

- *distributing the files in a way that hides the implementation details from the operator; and*

- *ensuring that tampering of the files, either wilfull or unconcious, has not happened before their execution*

### Treating automation as an application

Automation should be treated as a software application and subjected to the same software development lifecycle. This lifecycle means testing and publishing the automation like an application; in a way that can be used by an operator as a [black box](https://en.wikipedia.org/wiki/Black_box).

### Simple to run for an operator

Operators can be trained to execute the automation but do not necessarily understand how the automation code has been put together or what are the required automation toolchains.

Therefore, there is a need for [encapsulation](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)), a term coined in the object-oriented programming (OOP) community, that refers to restricting the direct access to some of internal logic that make up a function or component.

### Automation as components

The packaging engine achieves encapsulation by creating a [zip file](<https://en.wikipedia.org/wiki/ZIP_(file_format>) containing all the automation code along with a [manifest](https://en.wikipedia.org/wiki/Manifest_file).

The manifest declares the functions that can be executed on such package as well as the their signature (i.e. the inputs requires by such function).

This model simplifies the signing, distribution and execution of automation and reduces the storage and bandwidth requirements for their distribution.

## Execution engine

The execution engine provides a structured framework to run automation scripts.

### ___The build file___

At the core of the execution engine is the build file: a [YAML file](https://en.wikipedia.org/wiki/YAML) that defines:

- one or more functions: functions are lists of commands that have to be executed in sequence
  
- one or more build profiles: profiles describe how to create packages

- one or more inputs: inputs define the information required by functions and profiles to work

Build files can be chained, that is, one can call one build file from another build file. This allow to break complex functions in a manageable way.

*Artisan* has two distinct ways to execute logic, and each of those ways can happen within a container or within a host.

### ___Development vs Production Execution___

The two execution modes are:

- **In place execution**: executes functions or profiles in build files in a location in the file system, typically, where the command line is. This is useful for development purposes as execution can be done without creating a package. Two functions are available for this, namely **run** and **runc**.

- **In package execution**: executes functions or profiles in build files that are embedded in a package. This is the way logic is executed in operations once the package is released. Two functions are available for this, namely **exe** and **exec**.

### ___Container Execution___

**Artisan** can launch a container on a host with docker or podman, and execute the logic within the container. This is useful when the toolchain required to run the automation is not installed on the host.

For example, consider a package that requires [Ansible](https://www.ansible.com/) and you want to run it on a Windows host. As Ansible command line does not work on Windows, **Artisan** can lunch a Linux based Ansible runtime container and execute the logic within it.

### ___Runtimes___

*Artisan runtimes* are container images that implement a standard execution interface. 

Upon creation the container calls the **Artisan** *command line interface* inside the container, which in turns pulls an Artisan package from a registry and execute a specified function.

There are various different container runtimes such as the ones [here](https://github.com/gatblau/artisan/tree/master/runtime) with different toolchains. Runtimes can also be easily created by using [runtime based images](https://github.com/gatblau/artisan/tree/master/runtime/base). These base images ensure the runtime follows the interface required by *Artisan* to run the package logic.

### ___Flows___

Flows are a way to run a sequence of functions from one or more packages that require the same or different runtimes.

A flow definition is a YAML file containing a series of steps, each of them  as follows:

```yaml
---
name: the-flow-name
description: a description of what the flow does

steps:
  # the definition for a step
  - name: one-step
    description: run a function in a package using a runtime
    package: the-name-of-the-package
    runtime: the-runtime-image-to-use
    function: the-function-in-the-package-to-call

  # other steps can be defined below
  - name: another-step
    ...
...
```

The *Artisan* CLI can request the execution of a flow by sending the flow definition to an *Artisan Runner*.

A runner is an HTTP service that is in charge of the execution the flow. At some point different types of runners will be provided. For now, there is an OpenShift runner that uses [Tekton Pipelines](https://cloud.google.com/tekton/) to execute the steps in the flow definition.

## Distribution engine

<a name="flow_footnote">[1]</a> *Artisan flows are [yaml files](https://en.wikipedia.org/wiki/YAML) that simply describe a sequence of execution steps. They can be thought of as a logical pipeline and the emphasis is to make them human readable. An Artisan Runner then takes a flow and transpile it to the physical environment format where they run. For example, an Artisan Runner in Kubernetes transpiles the flow into a [Tekton](https://tekton.dev/) pipeline.*

<a name="digi_seal_footnote">[2]</a> *The digital seal is part of an Artisan package. It is a json file that contains the package manifest and a digital signature for the combination of the package manifest and the package zip file.*

