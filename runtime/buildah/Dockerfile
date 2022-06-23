#
#  Onix Config Manager - Red Hat Container Tools Artisan Package Runtime Image
#  Copyright (c) 2018-Present by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM alpine as builder

ENV OKD_VERSION=4.7.0-0.okd-2021-04-24-103438

WORKDIR /app/

# downloads oc / kubectl clis
RUN wget https://github.com/openshift/okd/releases/download/$OKD_VERSION/openshift-client-linux-$OKD_VERSION.tar.gz && \
    tar -xf openshift-client-linux-$OKD_VERSION.tar.gz && \
    rm openshift-client-linux-$OKD_VERSION.tar.gz

FROM quay.io/artisan/ubi

USER root

ARG UNAME=runtime

# deploy kubectl and oc commands
COPY --from=builder /app/kubectl /app/oc /usr/bin/

# install the kubic repository with latest buildah stable releases
RUN dnf update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && \
    dnf -y install 'dnf-command(copr)' && \
    dnf -y copr enable rhcontainerbot/container-selinux && \
    curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_8/devel:kubic:libcontainers:stable.repo

RUN dnf -y install buildah skopeo fuse-overlayfs && \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

# adjust storage.conf to enable Fuse storage
RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf && \
    mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock && \
    mkdir /.local/ && chown -R $UNAME /.local/ && chmod -R ug+wr /.local/

# set the uid and gid maps for the user
RUN echo "$UNAME:2000:50000" >> /etc/subuid
RUN echo "$UNAME:2000:50000" >> /etc/subgid

# Set up environment variables to note that this is not starting with usernamespace and default to isolate the filesystem with chroot.
ENV _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot

# this runtime runs privileged to allow builds in K8S
# USER $UNAME
