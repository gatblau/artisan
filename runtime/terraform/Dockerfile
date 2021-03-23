#
#  Onix Config Manager - Artisan Runtime Image - Terraform
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM alpine as builder
ENV TERRAFORM_VERSION=0.14.7
WORKDIR /app/
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

FROM quay.io/artisan/ubi-min
USER root
ARG TERRAFORM_VERSION
ARG UNAME=runtime
COPY --from=builder /app/terraform /usr/local/bin/
RUN ls -l /usr/local/bin/
RUN chmod +x /usr/local/bin/terraform
USER $UNAME
