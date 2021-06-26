# Functions

*Artisan* can execute customer actions called functions. Specifically, a function represents a unit of code that takes zero or more inputs (i.e. variables), and produces concrete results involving actual operations based on the inputs.

:exclamation: *functions are a way to encapsulate a list of Operating System commands*.

The following are examples of what functions can do:
  
- compile an application
- commit code to a git repository
- push a container image to a registry
- execute calls to automation tools such as Terraform or Ansible
- install packages in an Operating System

Functions are defined in the build file within the *functions* section.

## Function Attributes

| attribute | description | type | mandatory | default |
|---|---|---|---|---|
| `name` | A unique name used to call the function from the command line. It should not contain any whitespaces. | string | yes | n/a |
| `description` | A description of what the function does, only for documentation purposes in the build file. | string | no | empty string |
| `export` | Indicates whether the function should be added to the package manifest and become available to call in an executable package (i.e. the function is added to the package API) | boolean | no | false |
| `run` | A list of command line statements to be executed when the function is invoked. | list of strings | no |  empty list |
| `input` | Specifies the inputs that are required by this function. These are input bindings as they are not the inputs per se but references to inputs defined in the input section of the build file. | file, key, secret, var | no | n/a |
| `runtime` | Specifies the runtime to use when running this function. | string | **yes** if using `runc` or `exec` commands; **no** otherwise | empty string |
| `env` | A list of environment variables values to be available in the function. | dictionary of string, string | no | empty dictionary |

An expample using all attributes is shown below:

```yaml
---
input:
    var:
        - name: HELLO_WORD
          description: "the hello word in the language of choice"
          required: true
functions:
    - name: say-hello
      description: "prints a hello greeting to the standard output in a specific language"
      export: true
      runtime: quay.io/artisan/ubi-min
      env: 
        NAME_TO_GREET: Gatblau
      input:
        var:
           - HELLO_WORD
      run:
        - echo ${HELLO_WORD} ${NAME_TO_GREET}  
...
```

:checkered_flag: **try it!**

In the command line navigate to [this folder](examples/50) and execute the following command:

```bash
# tell artisan to call the "say-hello" function
art run say-hello

# you should see:
error!
* HELLO_WORD is required
```

Artisan is expecting **HELLO_WORD** as an input in the form of an environment variable. As it is not defined in the environment, then an error message is displayed and execution is not carried out.

So there are a couple of options for passing input, one as described before is to set an environment variable as follows:

```bash
EXPORT HELLO_WORD=HOLA
```

Alternatively, you can tell *Artisan* to prompt for the variable using *interactive mode* as follows:

```bash
# set interactive mode with the -i flag
art run say-hello -i

# you should see a prompt like:
? var => HELLO_WORD (the hello word in the language of choice): 
```

:exclamation: *note that the input description appears in brackets by the prompt to provide a hint.*

