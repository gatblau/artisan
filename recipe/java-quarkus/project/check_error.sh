#!/bin/bash

# check for errors before leaving the pipeline
# validating success & error scenarios
success_count=$(grep -c COMMIT buildconfig.log)
error_count=$(grep -c error buildconfig.log)
if [ $error_count -gt 0 ] || [ $success_count -eq 0 ]; then
  echo "Failed to build an image"
  exit 1
fi
