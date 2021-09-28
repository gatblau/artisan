#
#  Onix Config Manager - Artisan Runtime Image - Terraform & Ansible combination image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#

# NB. This is a specific image for an edge case where:
#   1. The image needs to be as small as possible (hence Alpine not ubi-min)
#   2. Both Terraform and Ansible installed in the same image (again to cut down on download requirements)
#   3. Allow UID/GID to be over-ridden if required

FROM alpine
ENV TERRAFORM_VERSION=1.0.7
ENV UID=256000
ENV GID=256000

WORKDIR /app/

USER root

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/. && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN apk --no-cache add ansible

ARG UNAME=runtime

RUN addgroup -g $GID -S $UNAME && \
    adduser -u $UID -S $UNAME -G $UNAME

USER $UNAME
