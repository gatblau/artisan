# Runtimes

Runtimes are container images with the tool chain that is required to execute an Artisan function.

Any runtime runs the [boot.sh](boot.sh) script, which has the following logic:

- If a package and function names are specified, then it executes the function in the package
- If a package is specified without a function, then it executes the default function in the package
- If only a function is specified, then it executes the function in the build file of the mounted project
- If nether a package nor a function is specified, then it executes a shell script with the run.sh default name.
  This script must be part of the runtime image and can define any custom logic required.

## Runtime standard interface

The interface of any runtime is defined by the following environment variables that control its behaviour:

| variable | description | required |
|---|---|---|
| `PACKAGE_NAME` | the fully qualified artisan package name | false |
| `PUB_KEY_FILE` | the path to the public PGP mounted in the image, required to open the artisan package | only if `package` is provided |
| `ART_REG_USER` | the username to log in the artisan registry where the package is located | only if authentication is required |
| `ART_REG_PWD` |  the password for the username used to log in the artisan registry | only if `username` is defined |
| `FX_NAME` | the name of the artisan function to run either in the package or the context build.yaml | false |

## Runtime Index

| Image | Description | Tools |
|---|---|---|
| [java11](art-java11/readme.md) | Build Java applications | *artisan, OpenJDK-11, maven* |
| [kube](art-kube/readme.md) | Kubernetes and OpenShift client CLIs | *artisan, kubectl, oc* |
| [rhctools](art-kube/readme.md) | Build and sign container images | *artisan, buildah, skopeo* |
| [sonar](art-sonar/readme.md) | Scan source code for quality metrics | *artisan, sonar-scanner* |
| [node](art-node/readme.md) | Build JavaScript applications | *artisan, node-js* |
| [golang](art-go/readme.md) | Build Go applications | *artisan, golang* |
| [python](art-python/readme.md) | Build Python applications | *artisan, python 3* |
