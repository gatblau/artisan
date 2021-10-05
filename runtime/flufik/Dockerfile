#
#  Onix Config Manager - Virtual Machine Disk File System Artisan Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM quay.io/artisan/fedora-min

LABEL maintainer="egevorkyan@outlook.com"

ARG UNAME=runtime

ENV PATH="/root/.local/bin":$PATH
ENV container=docker

USER root

COPY repourl/flufik.repo /etc/yum.repos.d/flufik.repo

# deletes a number of unit files which might cause issues - see https://hub.docker.com/_/centos/
RUN microdnf install -y openssl which hostname python3 openssh-clients initscripts flufik\
  && microdnf -y update \
  && microdnf clean all \
  && (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) \
  && rm -f /lib/systemd/system/multi-user.target.wants/* \
  && rm -f /etc/systemd/system/*.wants/* \
  && rm -f /lib/systemd/system/local-fs.target.wants/* \
  && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
  && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
  && rm -f /lib/systemd/system/basic.target.wants/* \
  && rm -f /lib/systemd/system/anaconda.target.wants/* \
  && mkdir -p /.ssh/ && chown $UNAME /.ssh/ && chmod a+rwx /.ssh/ \
  && mkdir -p /.flufik/configs && mkdir /.flufik/keys && mkdir /.flufik/logs && mkdir /.flufik/output \
  && chown $UNAME /.flufik/ && chown -R $UNAME /.flufik/ && chmod a+rwx /.flufik/

USER $UNAME