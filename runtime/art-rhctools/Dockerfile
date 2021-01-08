#
#  Onix Config Manager - Red Hat Container Tools Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM registry.access.redhat.com/ubi8/ubi

LABEL author="gatblau"
LABEL maintainer="onix@gatblau.org"
LABEL tools="buildah,skopeo,artisan"

ARG UNAME=builder

ENV UID=100000000
ENV GID=100000000

COPY appstream.repo /etc/yum.repos.d/CentOS-AppStream.repo
COPY repokey  /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

RUN dnf update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && \
    dnf -y install shadow-utils.x86_64 && \
    dnf -y install buildah skopeo fuse-overlayfs --exclude container-selinux && \
    groupadd -g $GID -o $UNAME && useradd -M -u $UID -g $GID $UNAME && \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

# adjust storage.conf to enable Fuse storage
RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock

# set the uid and gid maps for the user
RUN echo "$UNAME:100000:65536" >> /etc/subuid
RUN echo "$UNAME:100000:65536" >> /etc/subgid

# Set up environment variables to note that this is not starting with usernamespace and default to isolate the filesystem with chroot.
ENV _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot

WORKDIR /app

COPY art /usr/bin/art
COPY boot.sh ./

RUN chmod ug+x /usr/bin/art && \
    chmod ug+rx /app/boot.sh && \
    mkdir -p /keys

ENTRYPOINT ["sh", "/app/boot.sh"]