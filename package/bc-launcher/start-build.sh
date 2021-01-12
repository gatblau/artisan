#!/bin/bash

# consuming environment variables which are set in the img-builder pipeline
art merge buildconfig.yaml.tem
if [ "$?" -ne 0 ]; then
  echo "failed to merge buildconfig.yaml.tem"
  exit 1
fi

oc create -f buildconfig.yaml

# run custom build
oc start-build sap-equip-jvm-custom-build -F | tee buildconfig.log

# delete custom build from openshift
oc delete -f buildconfig.yaml

# check for errors before leaving the pipeline
# validating success & error scenarios
success_count=$(grep -c COMMIT buildconfig.log)
error_count=$(grep -c error buildconfig.log)
if [ $error_count -gt 0 ] || [ $success_count -eq 0 ]; then
  echo "Failed to build an image"
  exit 1
fi
