### How to use Java-Quarkus recipe

Ensure you have the following:
- artisan CLI installed
- this recipe is available from an Artisan registry and you know the {{registry-url}}
- oc client installed
- tkn client installed (optional)

Then follow the steps below:

```bash
# create new directory
mkdir java-quarkus

# go inside java-quarkus
cd java-quarkus/

# open java-quarkus recipe
art open -u=<ART_REG_USER>:<ART_REG_PWD> {{registry-url}}/recipe/java-quarkus

# create empty project in gitlab
# then pull java-quarkus recipe from the artefact registry
art pull -u=<ART_REG_USER>:<ART_REG_PWD> {{registry-url}}/recipe/java-quarkus

# now setup .env file. the below command will create .env file in the current folder
art env package {{registry-url}}/recipe/java-quarkus

# open .env & pass appropriate values
vi .env

# create tekton pipeline (make sure that you are logged in to the openshift)
art run setup-quarkus 
```