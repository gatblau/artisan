# Working with derived values

This example shows how to define a variable that is derived from an input.

This is useful when one or more input values dictate the value of other variables and you want to automatically generate
them so that there is no scope for error.

For example, you have an URI that should be generated from the value of an input.

Given the input **INPUT_VARIABLE** the **DERIVED_VARIABLE** can be created in the *env* section of the build file as follows:

```yaml
---
env:
    DERIVED_VARIABLE: aaa/$((echo ${INPUT_VARIABLE}))/ccc
...
```

Note the use of the *subshell* operator **$((...))** and the *variable* operator **${...}**.

The subshell operator performs an echo command with the value of the input variable and merges it with the rest of the
derived variable expression.

In order to evaluate the value of the input within the subshell it is necessary to use the *variable* operator **${...}**.

The working example is in the build file [here](build.yaml).

## Running the example

```bash
$ art run derive
```

**NOTE**: the input variable has been defined in the [.env](.env) file so that it can be automatically loaded in the artisan
context.

