#
#  Onix Config Manager - Base Artisan Runtime Image - Ubuntu 20.04
#  Copyright (c) 2018-Present by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM ubuntu:focal

LABEL maintainer="steve@devcloud.guru"

ARG UNAME=runtime

ENV UID=1000
ENV GID=1000

RUN apt clean all && rm -rf /var/cache/apt && \
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