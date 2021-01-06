#
#  Onix Config Manager - SonarQube Scanner Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM registry.access.redhat.com/ubi8/ubi-minimal

LABEL author="gatblau"
LABEL maintainer="onix@gatblau.org"
LABEL tools="sonarqube scanner"

ARG UNAME=scanner

ENV UID=1000
ENV GID=1000
ENV SONAR_ZIP_FILE=sonar-scanner-cli-3.3.0.1492-linux.zip
ENV SONAR_FOLDER=sonar-scanner-3.3.0.1492-linux
ENV PATH $PATH:/sonar/bin

RUN microdnf update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && \
    microdnf install shadow-utils.x86_64 zip wget jq -y && \
    groupadd -g $GID -o $UNAME && useradd -M -u $UID -g $GID $UNAME && \
    rm -rf /var/cache/yum && \
    microdnf clean all

WORKDIR /app

RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_ZIP_FILE} && \
    unzip ${SONAR_ZIP_FILE} && \
    mv ${SONAR_FOLDER} sonar

RUN chmod -R a+rwx ./sonar/

USER $UNAME
