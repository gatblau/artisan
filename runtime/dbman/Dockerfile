#
#  Onix Config Manager - DbMan Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM quay.io/artisan/ubi-min

USER root

ARG UNAME=runtime

COPY dbman /usr/bin/

WORKDIR /app

USER $UNAME