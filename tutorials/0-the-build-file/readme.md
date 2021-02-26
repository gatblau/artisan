# The build file

In the same way that [GNU make](https://www.gnu.org/software/make/) uses a [Makefile](https://www.gnu.org/software/make/manual/make.html#Introduction), you need a file called **build.yaml** (the build file) to tell *Artisan* what to do.

The build file tells *Artisan* how to run *functions*, that is, a sequence of instructions from the command line.

The build file also tells *Artisan* how to create `packages`. *Artisan* packages are [digitally signed](https://en.wikipedia.org/wiki/Digital_signature) [zip files](https://en.wikipedia.org/wiki/ZIP_(file_format)) containing one or more files and folders.

When a build file is placed within a package, the package is said to be `executable`, meaning that functions in the build file can utilise the files in the package to perform complex operations against a target service.

For example, a function in a package that contains a [POM file](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html) could:

- invoke [Maven](https://en.wikipedia.org/wiki/Apache_Maven) to create a [Java](https://en.wikipedia.org/wiki/Java_%28programming_language%29) project using a [Maven archetype](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html); then
- invoke [git](https://en.wikipedia.org/wiki/Git) to push the project to a remote origin

In another example, a function in a package that contains [Ansible roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) could invoke a [playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) to deploy and configure a virtual machine on a public cloud provider.

On more trivial cases, a build file could contain functions to build and package software and create conatiner images.

As the build file is not technology specific, it can be used to build any software with any toolchain, *it is just a command line orchestrator*.

Typically, any complex automation has to be configurable. Configuration in Artisan is managed mostly via environment variables, as this is aligned with the way [linux containers](https://www.redhat.com/en/topics/containers/whats-a-linux-container) work.

## The *functions* section

The *functions* section defines the functions available to call by *Artisan* as well as the commands that need to be executed in the command line when the function is called.

The sctructure of the *functions* section is as follows:

```yaml
---
# a list of functions 
functions:
    # how the function will be called
    - name: my-function
      # a meaningful description of the function
      description: |-
        description line 1 here
        description line 2 here
        more lines if needed...
      # a flag to tell Artisan to include the function in the 
      # package manifest (make the function available to 
      # package users to call - i.e. public)
      export: true
      # a list of commands to be invoved sequntially
      run:
        - echo "command 1 here"
        - echo "command 2 here"
      input:
        # variable bindings
        var: 
           - MY_VAR_1
           - MY_VAR_2
        # secret bindings
        secret:
           - MY_SECRET_1
           - MY_SECRET_2
        # pgp key bindings
        key:
           - MY_KEY_1
           _ MY_KEY_2
    
    - name: another-function-here
...
```

For clarity, a specific concrete example is provided below:

```yaml
---
    - name: build-app
      description: compiles and tests the application
      run:
        # compile and package the java app
        - mvn package -DskipTests=true
        # run tests
        - mvn test
        # create a folder for the 'app' profile
        - mkdir ./final
        # copy the jar file to the folder
        - cp target/${PROJECT_ARTIFACT_ID}-${PROJECT_ARTIFACT_VERSION}-runner.jar ./final
        # copy the dependencies to the new folder
        - cp -r target/lib/. ./final/lib
      input:
        # these bindings are defined in the general input 
        # section of the build file
        var:
          - PROJECT_ARTIFACT_ID
          - PROJECT_ARTIFACT_VERSION
...
```

## The *input* section

In order to tell *Artisan* what input is required by each function in the build file, the build file contains a section describing:
  
- variables: these are plain environment variables
- secrets: these are variables that contain sensitive information like credentials
- keys: these are the definition of [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) keys that are used by Artisan to sign and verify packages

:exclamation: Using different sections for the different types of input allows *Artisan* to provide differenciated treatment for each type of input.

```yaml
---
input:
  var:
    - name: GREETING_VARIABLE
      description: the description for GREETING_VARIABLE that will be used for documentation generation and to advice users if using command line interactive mode.
      # a boolean flag indicating if the variable is 
      # mandatory, it is used for input validation
      required: true
      # the type of the variable for the purpose of validation. 
      # Possible types are: path (a file path), uri (a unique resource identifier), 
      # name (an Artisan package name), string (any string)
      type: string
      default: "hello world"
        
    - name: OTHER_VARIABLES_HERE
...
```

### Binding variables

Variables need to be bound to a function to tell *Artisan* that the function uses it.

Bindings 