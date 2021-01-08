# Runtimes

Runtimes are container images with the tool chain that is required to execute an Artisan function.

Every runtime runs the [boot.sh](boot.sh) script, which has the following logic:

- If a package name and a function name is specified, then it executes the function in the package
- If a package name is specified without a function name, then it executes the default function within the package
- If only the function name is specified, then it executes the function in the build file of the mounted project.

  This is normally useful when running the runtime to support the build of source from a git project.
- If neither a package nor a function are specified, then it executes a shell script with the `run.sh` default name.

  This script must be located in the runtime image and can be used to define any custom logic to run when the container is created.

## Runtime standard interface

The interface of any runtime is defined by the following environment variables that control its behaviour:

| variable | description | required |
|---|---|---|
| `PACKAGE_NAME` | the fully qualified artisan package name | false |
| `PUB_KEY_FILE` | the path to the public PGP mounted in the image, required to open the artisan package | only if the `package` name has been provided |
| `ART_REG_USER` | the username to log in the artisan registry where the package is located | only if authentication is required |
| `ART_REG_PWD` |  the password for the username used to log in the artisan registry | only if `username` is defined |
| `FX_NAME` | the name of the artisan function to run either in the package or the source `build.yaml` file | false |

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
