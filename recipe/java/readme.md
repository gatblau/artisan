# Java Recipe - Quarkus & OpenShift Pipelines

This recipe provides a quick start for a Java Web Service using Quarkus

## Getting Started

Ensure you have the following:
- artisan CLI installed
- this recipe is available from an Artisan registry
- oc client installed

Then follow the steps below:

```bash
# open the recipe in a folder where the project files will be located
art open recipe/java-quarkus my-project

# go into the project directory
cd my-project

# customise your project info in build.yaml update the following:
# git_uri: the location of your project git repository
# env.APP_NAME: the name of your app (no blank spaces)

# generate the Quarkus scaffold as follows:
#  NOTE: use art run init if you have maven installed, otherwise art runc init
art run init

# create a flow to build the application using the source to package (s2p) template as follows:
art flow merge _build/flows/s2p_bare.yaml

# create a tekton pipeline definition from the flow as follows:
art tkn gen _build/flows/s2p.yaml > _build/flows/s2p_tkn.yaml

# ensure you are logged in OpenShift using the oc CLI
oc login ...

# create the tekton pipeline in OpenShift as follows:
cat _build/flows/s2p_tkn.yaml | oc apply -f -
``