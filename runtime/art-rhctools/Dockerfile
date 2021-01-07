#
#  Onix Config Manager - Red Hat Container Tools Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM docker.io/centos:7

LABEL author="gatblau"
LABEL maintainer="onix@gatblau.org"
LABEL tools="buildah,skopeo,artisan"

RUN yum update -y && \
    yum install buildah skopeo -y && \
    rm -rf /var/cache/yum && \
    yum clean all

WORKDIR /app

COPY art /usr/bin/art
COPY build.sh ./

RUN chmod ug+x /usr/bin/art && \
    chmod ug+rx /app/build.sh && \
    mkdir -p /keys

CMD ["sh", "/app/build.sh"]