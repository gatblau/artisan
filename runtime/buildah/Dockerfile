#
#  Onix Config Manager - Red Hat Container Tools Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM quay.io/artisan/ubi

USER root

ARG UNAME=runtime

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
