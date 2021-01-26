#
#  Onix Config Manager - Ansible Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM quay.io/artisan/python

ARG UNAME=runtime

USER root

RUN mkdir -p /.cache/pip/ && chown -R $UNAME /.cache/pip/ && chmod -R a+wr /.cache/pip/ && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py --user && \
    python3 -m pip install --user ansible

WORKDIR /app

USER $UNAME