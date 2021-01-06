#
#  Onix Config Manager - Artisan NodeJS 15 Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM quay.io/gatblau/node:15.5.1

LABEL author="gatblau"
LABEL maintainer="onix@gatblau.org"
LABEL tools="node-15,artisan"

ARG UNAME=builder

ENV UID=1000
ENV GID=1000
ENV ARTISAN_HOME=/usr/bin

RUN microdnf update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && \
    microdnf install shadow-utils.x86_64 && \
    groupadd -g $GID -o $UNAME && useradd -M -u $UID -g $GID $UNAME && \
    rm -rf /var/cache/yum && \
    microdnf clean all

WORKDIR /app

COPY art $ARTISAN_HOME/

RUN chmod ug+x $ARTISAN_HOME/art && \
    # folder below to mount keys in container
    mkdir -p /keys

USER $UNAME
