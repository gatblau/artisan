#
#  Onix Config Manager - Java OpenJDK-11 Artisan Package Runtime Image
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM centos:7

LABEL author="gatblau"
LABEL maintainer="onix@gatblau.org"
LABEL tools="maven,openjdk-11,artisan"

ARG UNAME=builder

ENV UID=1000
ENV GID=1000
ENV MAVEN_VERSION 3.6.3
ENV JAVA_HOME /usr/lib/jvm/jre-openjdk
ENV MAVEN_HOME /usr/lib/mvn
ENV ARTISAN_HOME /usr/bin
ENV PATH $MAVEN_HOME/bin:$PATH

RUN yum update -y && \
    yum install -y java-11-openjdk-devel && \
    yum install -y wget unzip && \
    groupadd -g $GID -o $UNAME && useradd -M -u $UID -g $GID $UNAME && usermod --home / -u $UID $UNAME && \
    rm -rf /var/cache/yum && \
    yum clean all && \
    mkdir -p /.artisan/keys && \
    chown -R $UNAME /.artisan && chmod -R ug+wr /.artisan && \
    mkdir -p /app && chown $UNAME /app && chmod ug+wr /app

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv apache-maven-$MAVEN_VERSION $MAVEN_HOME

COPY art $ARTISAN_HOME
COPY boot.sh /app/
RUN chmod -R a+rwx /app/

WORKDIR /app

COPY boot.sh ./

RUN chmod ug+x $ARTISAN_HOME/art && \
    chmod ug+rx /app/boot.sh && \
    # folder below to mount keys in container
    mkdir -p /keys

USER $UNAME

ENTRYPOINT ["sh", "/app/boot.sh"]