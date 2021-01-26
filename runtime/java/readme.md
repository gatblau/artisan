# Java Artisan Runtime

Runtime for building Java applications using Apache Maven.

# Usage

1) create a build.yaml with a function that uses the runtime as follows:

```yaml
---
functions:
  - name: version
    description: prints the versions for the tools in this runtime
    runtime: java
    run:
      - >-
          java --version
      - >-
          mvn -version
...
```

2) execute the function within the runtime as follows:

```sh
art runc version
```
