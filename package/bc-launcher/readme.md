# build-config launcher Package

BuildConfig to run custom builds with Buildah in Openshift. 

## Usage

```bash
art exec -u=${BC_ART_REG_USER}:${BC_ART_REG_PWD} ${BC_PACKAGE_NAME} ${BC_FX_NAME} -p=${BC_PUB_KEY_PATH}
```

| Asset | Description |
|---|---|
| BC_APPLICATION_NAME | Openshift app name |
| BC_BUILDER_IMAGE | Image builder name (buildah image) |
| BC_PUSH_IMAGE_REGISTRY | Application image registry name |
| BC_PUSH_IMAGE_REPO | Application image repo name |
| BC_PUSH_IMAGE_NAME | Application image name |
| BC_PUSH_IMAGE_VERSION | Application image version/tag |
| BC_PULL_IMAGE_REGISTRY | Application runtime image registry name |
| BC_ARTEFACT_NAME | Name for the artefact that will be downloaded |
| BC_CRYPTO_KEY_NAME | Cryptography signature secret name |
| BC_PACKAGE_NAME | Docker context artefact name |
| BC_PUB_KEY_PATH | Public key path to open the application artefacts |
| BC_FX_NAME | Function name to build image |
| BC_PRI_KEY_PATH | Private key path to sign the application image |
| BC_CRYPTO_KEY_EMAIL | Email id which is used to genearte crypto signature keys |
| BC_PULL_IMAGE_REGISTRY_UNAME | User name for the container registry where the base image is located |
| BC_PULL_IMAGE_REGISTRY_PWD | Password for the container registry where the base image is located |
| BC_PUSH_IMAGE_REGISTRY_UNAME | User name for the container registry where the application image will be pushed |
| BC_PUSH_IMAGE_REGISTRY_PWD | Password for the container registry where the application image will be pushed |
| BC_ART_REG_USER | Artefact registry user name |
| BC_ART_REG_PWD | Artefact registry user password |
