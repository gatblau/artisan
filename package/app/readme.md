# Application Setup Packages

This sections provides packages to setup and build a variety of projects in Kubernetes as follows:

| type | description |
|---|---|
| [quarkus](quarkus) | create a quarkus project and pipeline |
| [spring-boot](spring-boot) | create a spring-boot project and pipeline |

# How to build the packages

Use the below commands to create artisan packages. Please refer build.yaml file for available profiles.

```bash
# build package using art cli
art build -t <PACKAGE_NAME> -p <ART_PROFILE>

# push package into the repository
art push -u=<ART_REG_USER>:<ART_REG_PWD> <PACKAGE_NAME>
```

# How to run the packages

If the package is already available in the repository then use the below commands to use them

```bash
# Pull package from repository
art pull -u=<ART_REG_USER>:<ART_REG_PWD> <PACKAGE_NAME>

# Generate configuration file & populate configuration
art env package <PACKAGE_NAME>

# Update corresponding environment variable values
vi .env

# Execute package
art exec -u=<ART_REG_USER>:<ART_REG_PWD> <PACKAGE_NAME> setup

```

