#
#  Onix Config Manager - Base Artisan Runtime Image - Java + Maven + Gradle
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM alpine as builder

ENV MAVEN_VERSION 3.6.3
#ENV GRADLE_VERSION 6.8

WORKDIR /app/

# downloads maven and gradel
RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    rm apache-maven-$MAVEN_VERSION-bin.tar.gz

#RUN wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
#    unzip gradle.zip && \
#    rm gradle.zip

FROM quay.io/artisan/ubi-min

ARG UNAME=runtime

ENV MAVEN_VERSION 3.6.3
#ENV GRADLE_VERSION 6.8
ENV JAVA_HOME /usr/lib/jvm/jre-openjdk

ENV MAVEN_HOME /usr/lib/mvn
#ENV GRADLE_HOME /usr/lib/gradle
ENV PATH $MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH

# installs JDK 11
RUN microdnf install -y java-11-openjdk-devel git && \
    microdnf clean all && rm -rf /var/cache /var/log/dnf* /var/log/yum.* && \
    mkdir -p /.m2/repository/ && chown -R $UNAME /.m2/ && chmod -R a+wr /.m2/

# copy maven and gradle
COPY --from=builder /app/apache-maven-$MAVEN_VERSION $MAVEN_HOME
#COPY --from=builder /app/gradle-$GRADLE_VERSION $GRADLE_HOME

USER $UNAME