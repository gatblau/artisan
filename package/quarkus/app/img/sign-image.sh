#/bin/bash

#sign the application image & push into the image registry
skopeo copy --sign-by=${CRYPTO_KEY_EMAIL} --dest-tls-verify=false --dest-creds ${PUSH_IMAGE_REGISTRY_UNAME}:${PUSH_IMAGE_REGISTRY_PWD} containers-storage:${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} docker://${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}

# if the exit code of the previous command is not zero then retry to push image
if [ "$?" -ne 0 ]; then

skopeo copy --sign-by=${CRYPTO_KEY_EMAIL} --dest-tls-verify=false --dest-creds ${PUSH_IMAGE_REGISTRY_UNAME}:${PUSH_IMAGE_REGISTRY_PWD} containers-storage:${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} docker://${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}

fi
