#/bin/bash

# merges OpenShift template
art merge setup/deploy.yaml.tem

# apply template. condition is added because Catalog Template is not available on plain kubernetes
oc apply -f setup/deploy.yaml
if [ $? -ne 0 ]; then
  echo "Failed to create catalog template as it's only available on the openshift platform"
fi
