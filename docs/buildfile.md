<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# The build file

In the same way that [GNU make](https://www.gnu.org/software/make/) uses a [Makefile](https://www.gnu.org/software/make/manual/make.html#Introduction), you need a file called **build.yaml** (the build file) to tell *Artisan* what to do.

The build file tells *Artisan* how to run `functions`, that is, a sequence of command line instructions.

The build file also tells *Artisan* how to create `packages`. *Artisan* packages are [digitally signed](https://en.wikipedia.org/wiki/Digital_signature) [zip files](https://en.wikipedia.org/wiki/ZIP_(file_format)) containing one or more files and folders.

When a build file is placed within a package, the package becomes `executable`, that is, exported functions in the build file can be executed and use content in the package.

For example, a function in a package that contains a [POM file](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html) could:

- invoke [Maven](https://en.wikipedia.org/wiki/Apache_Maven) to create a [Java](https://en.wikipedia.org/wiki/Java_%28programming_language%29) project using a [Maven archetype](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html); then
- invoke [git](https://en.wikipedia.org/wiki/Git) to push the project to a remote origin

In another example, a function in a package that contains [Ansible roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) could invoke a [playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) to deploy and configure a virtual machine on a public cloud provider.

On more trivial cases, a build file could contain functions to build and package software and create conatiner images.

As the build file is not technology specific, it can be used to build any software with any toolchain, *it is just a command line orchestrator*.

| section | description |
|---|---|
| [*functions section*](#the-functions-section)| describes the syntax for the functions section of the build file |
| [*input section*](#the-input-section)| describes the syntax used to define inputs in a build file |

## The *functions* section

The *functions* section defines the functions available to call by *Artisan* as well as the commands that need to be executed in the command line when the function is called.

:exclamation: note that input section and function bindings as shown in the example below are explained in the *input* section further down.

The sctructure of the *functions* section is as follows:

```yaml
---
# define inputs required by functions in the build file
input:
  # define variables 
  var:
    - name: MY_VAR_1
      description: sample variable 1
      type: string

    - name: MY_VAR_2
      description: sample variable 2
      type: string

  # define secrets
  secret:
    - name: MY_SECRET_1
      description: sample secret 1

    - name: MY_SECRET_2
      description: sample secret 2

  # define PGP keys
  key: 
    - name: MY_KEY_1
      description: sample key 1
      private: true

    - name: MY_KEY_2
      description: sample key 2
      private: false

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

      # binds inputs required by the function
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
           - MY_KEY_2
    
    - name: another-function-here
...
```

## The *input* section

Typically, any complex automation has to be configurable. Configuration in Artisan is managed mostly via environment variables, as this is aligned with the way [linux containers](https://www.redhat.com/en/topics/containers/whats-a-linux-container) work.

Input information required by the build file, is defined in the iput section containing three sub sections as follows:
  
- `var`: these are plain environment variables
- `secret`: these are variables that contain sensitive information like credentials
- `key`: these are the definition of [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) keys that are used by Artisan to sign and verify packages
- `data`: these are the paths to specific files that should be available at package execution time, but that are not in the package. Typical examples of these are SSH keys that, due to security reasons, should not be part of a package 
but are required when the package is running.

:exclamation: Using different names for the different types of input allows *Artisan* to provide differenciated treatment for each of them.

For instance, secrets are variables that try and hide its value where posiible. Keys are variables but containing PGP keys and typically allow for easy loading, for example fro Artisan local registry.

```yaml
---
input:
  # variables definition below
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
  
  # secrets definitions below
  # secrets are variables that are treated as confidential information
  secret:
    - name: MY_USER_NAME
      description: login username

    - name: MY_USER_PWD
      description: login password

  # PGP keys: defines name, description, load path and whther they are private or not
  key:
    - name: MY_PUBLIC_KEY
      description: "I use this key to verify a digital signature"
      # is it private or public?
      private: false
      # what is the default path for the key in the local
      # Artisan registry
      path: /
...
```

### Binding variables

Variables must to be bound to a function to tell *Artisan* that the variable is needed by such function.

This is mostly required when a function is exported so that its required inputs can be added to the package manifest.

:exclamation: this will be clarified when Artisan packages are discussed.

Bindings are written using a similar syntax to the input definition. The following example ilustrates how to bind the **USER_TO_GREET** variable to the **greet-user** function:

```yaml
---
input:
   # variable definition section
   var: 
     - name: USER_TO_GREET
       description: the name of the user to greet
       required: true
       default: Gatblau
       type: string

functions:
    - name: greet-user
      run:
        - echo Hello ${USER_TO_GREET}!
      input:
         # variable binding section
         var:
           - USER_TO_GREET
...
```

:checkered_flag: **try it!**

```bash
# the following example assumes Linux/OSX operating system:

# tell Artisan to run the "greet-user" function from the 
# build file located at the "exercise/ex_01" sub-folder
$  art run greet-user exercise/ex_01 

# you should see an error message as the variable 
# USER_TO_GREET is not defined
error!
* USER_TO_GREET is required

# now try interactive mode, so the command line interface 
# will ask you to enter the missing variables
# note the -i flag to tell Artisan to run in interactive mode
$  art run -i greet-user exercise/01

# you should be able to see the following prompt
# note the default value in brackets
? var => USER_TO_GREET (the name of the user to greet): (Gatblau) 

# press enter to use the default value
# you should now see the message below
Hello Gatblau!

# now export an environment variable 
$ export USER_TO_GREET="Mickey Mouse"
$ art run greet-user exercises/01
  
# you should now see the message below
Hello Mickey Mouse!

# now unset the variable USER_TO_GREET
$ unset USER_TO_GREET

# Artisan can also load variables from a file
# the file can contain one or more environment variables
# to test it, create an environment file as follows
$ echo USER_TO_GREET="Black Pete" >> exercise/01/.env

# now try and run the command below
# note the -e flag to tell Artisan to load the 
# new environment file
$ art run -e exercise/01/.env greet-user exercise/01

# you should see the following message
Hello Black Pete!
```

### Unbound variables

In some cases, you might not want to create a binding but still want Artisan to prompt for the value of a variable if missing. This is normally the case when you do not intend to export functions but still want to run them locally.

In this case, the build file would simply look like the following:

```yaml
---
functions:
  - name: greet-user
    run:
      - echo Hello ${USER_TO_GREET}!
...
```

:checkered_flag: **try it!**

```bash
$ art run greet-user exercise/02

# you should see the following message
error!
* the environment variable 'USER_TO_GREET' is not defined, are you missing a binding? you can always run the command in interactive mode to manually input its value

# now try and do the following and observe what happens:
# 1. run Artisan in interactive mode (use the -i flag)
# 2. export the required variable
# 3. load the variable from an environment file (use the -e flag)
```
