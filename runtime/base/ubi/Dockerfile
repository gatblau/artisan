#
#  Onix Config Manager - Base Artisan Runtime Image - ubi8
#  Copyright (c) 2018-Present by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM registry.access.redhat.com/ubi8/ubi

LABEL maintainer="onix@gatblau.org"

ARG UNAME=runtime

ENV UID=1000
ENV GID=1000

# disable any repository that is not
RUN dnf update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos --disableplugin=subscription-manager -y && \
    groupadd -g $GID -o $UNAME && \
    useradd -u $UID -g $GID $UNAME && \
    # app folder
    mkdir -p /app/ && chown $UNAME /app/ && chmod a+rwx /app/ && \
    # files volume mount
    mkdir -p /files/ && chown $UNAME /files/ && chmod a+r /files/

# artisan CLI
COPY art /usr/bin/

# runtime bootstrap script
COPY boot.sh /app/

WORKDIR /app/

# permissions on artisan CLI and bootstrap script
RUN chmod ug+x /usr/bin/art && chmod ug+x /app/boot.sh

CMD ["sh", "/app/boot.sh"]

USER $UNAME