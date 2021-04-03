<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# Artisan synopsis

*Artisan is a [command line interface (CLI)](https://en.wikipedia.org/wiki/Command-line_interface) written in [Go](https://golang.org/) that helps to standardise and secure the packaging, execution and distribution of
disparate scripts, code, configuration and other required files across the enterprise.*

Artisan is part of the [Onix Configuration Manager](https://onix.gatblau.org) Build System that deals with *build time* configuration.

## Why Artisan?

Typically, DevOps teams need to use multiple toolchains and technologies to meet the automation requirements related to building and configuring software.

Standardisation means that both development and operational teams can combine toolchains and execute them in the same consistent and secure way, regardless of the stage in the [application development lifecycle](https://en.wikipedia.org/wiki/Systems_development_life_cycle).

Although this is technologically possible, without a consistent set of standards and abstractions that guide the way logic is packaged, distributed and consumed across a plethora of automation vendors, teams usually find themselves reinventing the wheel for every new project and have to manage more than one toolchain in different ways.

Linux containers provide the basis to resolve this problem. However, it takes a great deal of effort and knowledge to use containers in a consistent and secure way.

:boom: *Artisan* acts as the ***craftman in the middle*** of container and scripting technology, providing a generic way to amalgamate them and facilitate its use: package disparate sets of scripts, store them in a library (registry) and execute them in toolchain containers (runtimes).

## How Artisan Packages compare to Container Images?

*Artisan* packages are created in a similar way as container images. Once created, they can be tagged, pushed to and pulled from an *Artisan* registry.

However, *Artisan* packages are smaller than container images, and are designed to be deployed in a container at runtime.

This allows for the creation of runtime libraries consisting of standard container images with specific toolchains.

Packages are the logic and containers are the environment where the logic runs.

:exclamation: by separating them at build time and combining them at runtime complex flows can be easily created to execute any combination of packaged functions.
## Standard but flexible

Sometimes standardisation is associated with opinionated and inflexible. *Artisan* tries hard to be flexible by placing the control in the hands of the developers.

:exclamation: *Artisan* takes commands from a configuration file (i.e. the build file). This file allows developers to inject instructions at key parts of the process, telling *Artisan* exactly what to do, and thus providing the freedom to customise the execution logic. *Artisan* then takes these instructions and execute them in well defined, secure and standard process.

## Secure by default

Cryptography is hard, so *Artisan* puts the emphasis on making cryptography seamless, easy to use and implicitly engrained in the fabric of packages.

:boom: Using [Pretty Good Privacy (PGP)](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) keys by default, *Artisan* can automatically validate that the package being executed comes from a trusted source and it is safe to run.

## Embedded SOPs

When companies onboard new employees or team members, they need to go through a learning curve before they can be effective at their jobs. Time is always in short supply for training.

Standard Operating Procedures (SOP) are documents that contain the necessary instructions to complete critical processes. 

SOPs ensure that a business can keep running smoothly as employees come and go, thus providing business continuity.

:boom: *Artisan* can embed SOPs in packages making them easy to distribute and readily available to operators.

## Core Subsystems

Artisan achieves all the above by combining the functions in the following core subsystems:

1. [the packaging engine](#packaging-engine) packages and unpackage files using the [zip compression format](https://en.wikipedia.org/wiki/ZIP_(file_format)).
  
2. [the execution engine](#execution-engine) executes the logic within the packages using toolchain specific [standard containerised runtimes](https://github.com/gatblau/artisan/tree/master/runtime). The execution engine can run different functions requiring different toolchains using flows(<sup>[1](#flow_footnote)</sup>).
  
3. [the publishing engine](#publishing-engine) provides the means to tag, push, pull and open packages, enforcing the cryptographic verification of author/source.
  
4. [the input engine](#input-engine) to improve usability and foster reusability, automation packages must have a standard way to publish and consume variables and generate variable specifications. The input engine provide options for automated generation of variable files and loading variables from different sources.

5. [the cryptographic engine](#cryptographic-engine) every package is digitally signed by default using [PGP Keys](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). When the execution engine opens a package, it verifies its digital seal(<sup>[2](#digi_seal_footnote)</sup>) to ensure it is trusted. The crypto engine can create, import, encrypt and decrypt files, and sign and verify packages.

---

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

---

## Execution engine

The execution engine provides a structured framework to run automation scripts.

### ___The build file___

At the core of the execution engine is the build file: a [YAML file](https://en.wikipedia.org/wiki/YAML) that defines:

- ***functions***: functions are lists of commands that have to be executed in sequence. For those familiar with GNU Make, *Artisan* functions are similar to [make functions](https://www.gnu.org/software/make/manual/html_node/Functions.html).
  
- ***profiles***: describe the operations required to create *Artisan* packages. In the simplest form they can be just the location of a target folder to zip, in a more complex case, they might involve execution of shell commands or other *Artisan* functions required to prepare the contents of a package.

- ***inputs***: inputs define the information required by functions and profiles to work. Inputs can be ordinary variables, secrets or (PGP) keys.

Build files can be chained, that is, one can call one build file from another build file. This allow to break complex functions in a manageable way.

*Artisan* has two distinct ways to execute logic, and each of those ways can happen within a container or within a host.

### ___In Place Execution___

In place execution is when *Artisan* executes functions or profiles in build files that have not been boxed in a package.

Source code sits in a location in the file system, typically, where the command line terminal prompt is. This is useful mostly for development purposes as execution can be done without creating a package.

:boom: *Artisan* uses in place execution within a runtime that is part of a flow with a git source. If a flow uses a git source, the files have already being mounted in the runtime and a package is not required.

:exclamation: In place execution can be invoked using the **run** command.

### ___Package Execution___

Package execution is when *Artisan* executes functions or profiles in build files that are embedded in a package. This is the way logic is mostly executed in operation environments once a package is released.

:boom: *Artisan* uses package execution within a flow when there is no need to bind to a git source (e.g. for development / Continuous Integration purposes). This is normally the scenario where operations are permorming one-time configurations or installations.

:exclamation: package execution can be invoked using the **exe** command.

### ___Container Execution___

In addition to the two execution modes descussed before, **Artisan** can perform in place or package execution within a linux container in a host with [docker](https://docs.docker.com/get-started/) or [podman](https://podman.io/) installed.

This is useful when the toolchain required to run the automation is not installed on the host.

For example, consider a package that requires [Ansible](https://www.ansible.com/) and you want to run it on a Windows host. As Ansible command line does not work on Windows, **Artisan** can lunch a Linux based Ansible runtime container and execute the logic within it.

:boom: container execution can be used with both in-place and package execution.

:exclamation: use **runc** instead of **run** to add container execution in-place. Use **exec** instead of **exe** to add container execution for a packaged function.

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

### ___Artisan Runners___

A runner is an HTTP service that is in charge of the execution the flow. At some point different types of runners will be provided. For now, there is an OpenShift runner that uses [Tekton Pipelines](https://cloud.google.com/tekton/) to execute the steps in the flow definition.

---

## Publishing engine

The publishing engine goal is to facilitate the distribution of packages and the dynamic installation of packages into runtimes.

The *Artisan CLI* can create, tag and push packages to a registry. Once there, they can be pulled and opened within runtimes ready for execution.

At the heart of the publishing engine is the Artisan Registry.

### ___The Artisan Registry___

In a similar way to a [Docker registry](https://docs.docker.com/registry/), the *Artisan Registry* is a stateless, highly scalable server side application that stores and lets you distribute *Artisan Packages*.

The registry can sit in front of various backends, such as a [Nexus Repository](https://www.sonatype.com/nexus/repository-pro). Other backends such as S3 or Artifactory can be implemented in the future.

The registry is typically package as a container image which can run from any [Kubernetes](https://kubernetes.io/) implementation.

### ___Discoverable Library___

The *Artisan Registry* can be used to implement an enterprise wide library made of digitally signed, black boxed and discoverable packages that can be ubiquitously run using container runtimes, fully encapsulating the implementaion details and the underlying toolchains.

Packages in the library can be mixed and matched using flows, to cater for a wide range of complex Enterprise automation scenarios.

---

## Input engine

The input engine provides the means to pass configuration to packages using environment variables and mounting files.

In order to make functions and profiles configurable *Artisan* can can read input information from a build file or the package manifest.

Four types of *inputs* are available as follows:

1. `var`: variables define information required to run a function or profile.

2. `secret`: are like variables but their values are given a particular treatment to ensure they are protected.

3. `key`: allows to PGP keys easily load and pass PGP keys to packages and flows. 

4. `data`: allows to load and pass arbitrary files to packages and flows.

:exclamation: *As any piece of input could be used by one or more functions or profiles, inputs have to be bound to them. Bindings allow Artisan to actively required the inputs before the execution of a function can take place.*

---

## Cryptographic engine

*Artisan* uses PGP encryption to digitally sign every package. A private key is used to sign packages.

In the same way, any package that is executed must pass the verification of its digital signature before they can do so. The counterpart public key is used to verify the package signature.

*Artisan* can create PGP keys, and has a local requistry where keys can be placed. The registry allows to place keys in a hierarchical structure to facilitate overriding following the package group/name convention.

For example placing a key in the root make it usable to sign/verify all packages, where as placing a key withing a specific group and or name make the key usable within that package group or name.

---

<a name="flow_footnote">[1]</a> *Artisan flows are [yaml files](https://en.wikipedia.org/wiki/YAML) that simply describe a sequence of execution steps. They can be thought of as a logical pipeline and the emphasis is to make them human readable. An Artisan Runner then takes a flow and transpile it to the physical environment format where they run. For example, an Artisan Runner in Kubernetes transpiles the flow into a [Tekton](https://tekton.dev/) pipeline.*

<a name="digi_seal_footnote">[2]</a> *The digital seal is part of an Artisan package. It is a json file that contains the package manifest and a digital signature for the combination of the package manifest and the package zip file.*

