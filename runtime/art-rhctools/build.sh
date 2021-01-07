#!/bin/bash
# pre-condition health check: all required environment variables have been provided!
if [[ -z "${ART_REG_USER+x}" ]]; then
    echo "ART_REG_USER must be provided"
    exit 1
fi
if [[ -z "${ART_REG_PWD+x}" ]]; then
    echo "ART_REG_PWD must be provided"
    exit 1
fi
if [[ -z "${PACKAGE_NAME+x}" ]]; then
    echo "PACKAGE_NAME must be provided"
    exit 1
fi
if [[ -z "${PUB_KEY_PATH+x}" ]]; then
    echo "PUB_KEY_PATH must be provided"
    exit 1
fi

# open docker context artefacts
art exec -u=${ART_REG_USER}:${ART_REG_PWD} ${PACKAGE_NAME} build-image -p=${PUB_KEY_PATH}