<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

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
| `OXART_PACKAGE_NAME` | the fully qualified artisan package name | false |
| `OXART_ART_REG_USER` | the username to log in the artisan registry where the package is located | only if authentication is required |
| `OXART_REG_PWD` |  the password for the username used to log in the artisan registry | only if `username` is defined |
| `OXFX_NAME` | the name of the artisan function to run either in the package or the source `build.yaml` file | false |
| `OXART_PACKAGE_SOURCE` | the of source to use when the package runs in a flow. Possible values are: **none**: transient, **create**: uses the source from the executing package, **merge**: adds the source of the executing package to the existing source; and **read**: just uses existing source. |

:exclamation: variables starting with `OXART_` are artisan reserved variables.

| folder | description |
|---|---|
| `/app/` | the folder where boot.sh and run.sh are located |
| `/usr/bin/` | the folder where artisan cli is so that it can be accessed from anywhere in the container |
| `/workspace/source/` | the folder where any mounted project source is located, and from where a build.yaml file will be read |
| `/.artisan/` | the artisan local registry folder |
| `/.artisan/keys/` | the root folder for the PGP keys in the artisan registry |
| `/keys/` | the root folder for the PGP keys to be mounted into the runtime image. These keys are moved into the artisan registry by the boot.sh file |

## Mounting Keys

Artisan PGP keys should be mounted on the /keys folder of the runtime image.

The boot.sh script in the runtime moves the keys into the local artisan registry, where they are automatically read by artisan following the following convention:

```sh
/ (root)
 | root_rsa_key.pgp (private key)
 | root_rsa_pub.pgp (public key) 
 / groupName /
      | groupName_rsa_key.pgp (private key)
      | groupName_rsa_pub.pgp (public key)
      / packageName /
                     | groupName_packageName_rsa_key.pgp (private key)
                     | groupName_packageName_rsa_pub.pgp (public key)
```

## Runtime Index

| Image | Description | Tools | Run Script |
|---|---|---|---|
| [java11](art-java11/readme.md) | Build Java applications | *artisan, OpenJDK-11, maven* | no |
| [kube](art-kube/readme.md) | Kubernetes and OpenShift client CLIs | *artisan, kubectl, oc* | no |
| [rhctools](art-kube/readme.md) | Build and sign container images | *artisan, buildah, skopeo* | no |
| [sonar](art-sonar/readme.md) | Scan source code for quality metrics | *artisan, sonar-scanner* | yes |
| [node](art-node/readme.md) | Build JavaScript applications | *artisan, node-js* | no |
| [golang](art-go/readme.md) | Build Go applications | *artisan, golang* | no |
| [python](art-python/readme.md) | Build Python applications | *artisan, python 3* | no |
