#!/bin/bash

# removing https:// substring from the git url
# because in "git remote add origin" command it's already available
URI=${GIT_URI:8}

# call url encoder to handle password special chars
source url_encoder.sh ${GIT_REPO_PWD}

# initialize the git repo & push into the git
cd app
git init
git config user.email "${GIT_REPO_EMAIL}"
git config user.name "${GIT_REPO_UNAME}"
git add .
git commit -m "first commit"
git remote add origin https://${GIT_REPO_UNAME}:${GIT_REPO_PWD}@$URI
git push -u origin master
