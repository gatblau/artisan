#!/bin/bash
#
#  Onix Config Manager - Bootstrap for Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#

# copy any mounted keys to the artisan registry in the user home
#echo creating ${HOME}/.artisan/keys folder
mkdir -p ${HOME}/.artisan/keys

#echo copying keys from /keys mount to ${HOME}/.artisan artisan registry
cp -R /keys ${HOME}/.artisan

# if a package name has been provided
if [[ -n "${PACKAGE_NAME+x}" ]]; then
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
    # if a package source has been provided
    if [[ -n "${PACKAGE_SOURCE+x}" ]]; then
       case "$PACKAGE_SOURCE" in
          "create" | "CREATE")
              # remove any existing files in the source folder
              rm -rf /workspace/source/*
              # open package in the source folder and leave files there
              art exe -u=${ART_REG_USER}:${ART_REG_PWD} --path /workspace/source -f ${PACKAGE_NAME} ${FX_NAME}
              ;;
          "merge" | "MERGE")
              # open package in the source folder and leave files there
              art exe -u=${ART_REG_USER}:${ART_REG_PWD} --path /workspace/source -f ${PACKAGE_NAME} ${FX_NAME}
              ;;
          "read" | "READ")
              # run from existing source
              art run ${FX_NAME} /workspace/source/
              ;;
          *)
              printf "invalid PACKAGE_SOURCE value: %s, valid values are either 'new' or 'update'\n" ${PACKAGE_SOURCE}
              ;;
       esac
    else
      # no source type provided then use a transient source
      art exe -u=${ART_REG_USER}:${ART_REG_PWD} ${PACKAGE_NAME} ${FX_NAME}
    fi
  else
      printf "A function name is required for package %s, ensure FX_NAME is provided\n" ${PACKAGE_NAME}
      exit 1
  fi
  # else if only a function has been defined
elif [[ -n "${FX_NAME+x}" ]]; then
  # run the function from the build.yaml in the mounted source
  art run ${FX_NAME} /workspace/source/
else
  # no package and no function have been defined then run the runtime bootstrapping script
  sh /app/run.sh
fi
