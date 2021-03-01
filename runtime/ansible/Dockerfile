#
#  Onix Config Manager - Ansible Artisan Package Runtime Image
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
ENV ANSIBLE_VERSION=2.10.5

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
 && dnf -y update \
 && dnf -y install sudo which hostname python3 \
 && dnf clean all

# install and upgrade pip via python
RUN python3 -m pip install -U pip

# install wheel (required by ansible installation), boto3 required by ec2 module and ansible
RUN pip3 install wheel boto3 ansible==${ANSIBLE_VERSION}

# disable requiretty and create default hosts file
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers \
 && mkdir -p /etc/ansible \
 && mkdir -p /.ansible/tmp \
 && mkdir -p /.cache/pip \
 && echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# add the ansible configuration file
COPY ansible.cfg /etc/ansible/ansible.cfg

# ensure ansible folders are accessible by the runtime user
RUN chown -R ${UNAME}:0 /.ansible && chmod -R g+rw /.ansible \
 && chown -R ${UNAME}:0 /etc/ansible && chmod -R g+rw /etc/ansible \
 && chown -R ${UNAME}:0 /.cache/pip && chmod -R g+rw /.cache/pip

USER $UNAME
