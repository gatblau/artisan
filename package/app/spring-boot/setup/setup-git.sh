#!/bin/bash
#Store git Credentials
cat > ${HOME}/.netrc <<EOF

machine $1
login $2
password $3
protocol https

EOF

cd app
git init
git config --global user.email "${GIT_REPO_EMAIL}"
git config --global user.name "${GIT_REPO_UNAME}"
git add .
git commit -m "first commit"
git remote add origin ${GIT_URI}
git push -u origin master