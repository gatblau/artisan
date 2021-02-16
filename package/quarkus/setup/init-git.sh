#!/bin/bash
cd ../app
git init
git add .
git commit -m "first commit"
git remote add origin ${GIT_URI}
git push -u origin master