#
#  Onix Config Manager - K8S Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM alpine as builder

ENV OKD_VERSION=4.5.0-0.okd-2020-10-15-235428

WORKDIR /app/

RUN wget https://github.com/openshift/okd/releases/download/$OKD_VERSION/openshift-client-linux-$OKD_VERSION.tar.gz && \
    tar -xf openshift-client-linux-$OKD_VERSION.tar.gz && \
    rm openshift-client-linux-$OKD_VERSION.tar.gz

FROM quay.io/artisan/ubi-min

ARG UNAME=runtime

WORKDIR /app/

COPY --from=builder /app/kubectl /app/oc /usr/bin/

USER $UNAME