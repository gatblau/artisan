#!/bin/bash
#
#  Onix Config Manager - Bootstrap for Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#

# fetch user home directory from /etc/passwd file
export PIPELINE_HOME=$(awk -F":" '{print $6}' /etc/passwd | grep -m1 `whoami`)

printf "pipeline home is '%s'\n", "$PIPELINE_HOME"

# copy any mounted keys to the artisan registry in the user home
# folder required for tekton
mkdir -p ${PIPELINE_HOME}/.artisan/keys
mkdir -p ${PIPELINE_HOME}/.artisan/files

#echo copying keys from /keys mount to ${HOME}/.artisan artisan registry
cp -R /keys ${PIPELINE_HOME}/.artisan
cp -R /files ${PIPELINE_HOME}/.artisan

# if a package name has been provided 
if [ -n "${OXART_PACKAGE_NAME+x}" ]; then
  # if a user name is defined
  if [ -n "${OXART_REG_USER+x}" ]; then
    # then requires a corresponding password
    if [ -z "${OXART_REG_PWD+x}" ]; then
      echo "The password for the Artisan Registry user is required: OXART_REG_PWD must be provided"
      exit 1
    fi
  fi
  # if a function has been defined executes the package with the function
  if [ -n "${OXART_FX_NAME+x}" ]; then
    # if a package source has been provided
    if [ -n "${OXART_PACKAGE_SOURCE+x}" ]; then
       case "$OXART_PACKAGE_SOURCE" in
          "create" | "CREATE")
              # remove any existing files in the source folder
              rm -rf /workspace/source/*
              # execute package in the source folder and leave files there
              art exe -u=${OXART_REG_USER}:${OXART_REG_PWD} --path /workspace/source -f ${OXART_PACKAGE_NAME} ${OXART_FX_NAME}
              ;;
          "merge" | "MERGE")
              printf "OXART_PACKAGE_SOURCE=merge is not valid when function name exist OXART_FX_NAME= %s\n" ${OXART_FX_NAME}
              ;;
          "read" | "READ")
              # run from existing source
              art run ${OXART_FX_NAME} /workspace/source/
              ;;
          *)
              printf "invalid OXART_PACKAGE_SOURCE value: %s, valid values are either 'new' or 'update'\n" ${OXART_PACKAGE_SOURCE}
              ;;
       esac
    else
      # no source type provided then use a transient source
      art exe -u=${OXART_REG_USER}:${OXART_REG_PWD} ${OXART_PACKAGE_NAME} ${OXART_FX_NAME}
    fi
  else
    # if a package source has been provided
    if [ -n "${OXART_PACKAGE_SOURCE+x}" ]; then
      case "$OXART_PACKAGE_SOURCE" in
        "merge" | "MERGE")
            # open package in the source folder and leave files there
            art open -u=${OXART_REG_USER}:${OXART_REG_PWD} ${OXART_PACKAGE_NAME} /workspace/source
            ;;
        *)
            printf "only OXART_PACKAGE_SOURCE=merge is allowed when no package name is provided\n"
            ;;
     esac
    else
      printf "A function name is required for package %s, ensure OXART_FX_NAME is provided\n" ${OXART_PACKAGE_NAME}
      exit 1
    fi
  fi
  # else if only a function has been defined
elif [ -n "${OXART_FX_NAME+x}" ]; then
  # run the function from the build.yaml in the mounted source
  art run ${OXART_FX_NAME} /workspace/source/
else
  # no package and no function have been defined then run the runtime bootstrapping script
  sh /app/run.sh
fi
