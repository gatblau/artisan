#/bin/bash

# check if img is available in the registry
skopeo inspect docker://${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} > .log 2>&1
if [ $? -ne 0 ]; then
   touch app-deploy-flag.txt
fi

buildah login -u ${PULL_IMAGE_REGISTRY_UNAME} -p ${PULL_IMAGE_REGISTRY_PWD} ${PULL_IMAGE_REGISTRY}
#build image
buildah bud --format=docker --isolation=chroot -t ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} .
# import gpg key to sign & push image
gpg --import ${PIPELINE_HOME}/.artisan/keys/root_rsa_key.pgp

#sign the application image & push into the image registry
skopeo copy --sign-by=${CRYPTO_KEY_EMAIL} --dest-tls-verify=false --dest-creds ${PUSH_IMAGE_REGISTRY_UNAME}:${PUSH_IMAGE_REGISTRY_PWD} containers-storage:${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} docker://${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}

# if the exit code of the previous command is not zero then retry to push image
if [ "$?" -ne 0 ]; then
    skopeo copy --sign-by=${CRYPTO_KEY_EMAIL} --dest-tls-verify=false --dest-creds ${PUSH_IMAGE_REGISTRY_UNAME}:${PUSH_IMAGE_REGISTRY_PWD} containers-storage:${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} docker://${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}
fi

# deploy the app if flag file is present else skip app deployment
if [ -e app-deploy-flag.txt ]; then
   oc new-app --template=quarkus-app
fi

# delete flag file
rm -f app-deploy-flag.txt