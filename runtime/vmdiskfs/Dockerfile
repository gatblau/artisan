#  Onix Config Manager - iConverter Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM quay.io/artisan/ubi

ARG UNAME=runtime

ENV PATH="/root/.local/bin":$PATH
ENV container=docker

USER root

COPY CentOS.repo /etc/yum.repos.d/CentOS.repo

RUN dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-2.el8.noarch.rpm \
 && dnf install -y libguestfs-tools-c

# silence bogus subscription messages
RUN echo "enabled=0" >> /etc/yum/pluginconf.d/subscription-manager.conf

# deletes a number of unit files which might cause issues - see https://hub.docker.com/_/centos/
RUN dnf -y update; dnf clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# install pre-requisites
RUN dnf makecache --timer \
 && dnf -y install initscripts \
 && dnf -y install sudo which hostname python3 openssh-clients \
 && dnf clean all \
 && mkdir -p /.ssh/ && chown $UNAME /.ssh/ && chmod a+rwx /.ssh/

USER $UNAME