#!/bin/bash
#
#  Onix Config Manager - Bootstrap for Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#

# if a package name has been provided
if [[ -n "${PACKAGE_NAME+x}" ]]; then
  if [[ -z "${PUB_KEY_PATH+x}" ]]; then
    echo "A full path to the PGP public key used to open the package is required: PUB_KEY_PATH must be provided"
    exit 1
  fi
  # if a user name is defined
  if [[ -n "${ART_REG_USER+x}" ]]; then
    # then requires a corresponding password
    if [[ -z "${ART_REG_PWD+x}" ]]; then
      echo "The password for the Artisan Registry user is required: ART_REG_PWD must be provided"
      exit 1
    fi
  fi
  # if a function has been defined executes the package with the function
  if [[ -n "${FX_NAME+x}" ]]; then
      # pass the function name
      art exec -u=${ART_REG_USER}:${ART_REG_PWD} ${PACKAGE_NAME} ${FX_NAME} -p=${PUB_KEY_PATH} -s
  else
      # executes the default function
      art exec -u=${ART_REG_USER}:${ART_REG_PWD} ${PACKAGE_NAME} -p=${PUB_KEY_PATH} -s
  fi
  # else if only a function has been defined
elif [[ -n "${FX_NAME+x}" ]]; then
  # run the function from the build.yaml in the mounted source
  art run ${FX_NAME}
else
  # no package and no function have been defined then run the runtime bootstrapping script
  sh run.sh
fi
