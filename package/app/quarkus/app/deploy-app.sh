#/bin/bash

# merges application template
art merge deploy.yaml.tem

# create application
kubectl apply -f deploy.yaml
if [ $? -ne 0 ]; then
  echo "Failed to deploy the app"
  exit 1
fi
