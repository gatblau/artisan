#
#  Onix Config Manager - Base Artisan Runtime Image - Java + Gradle + Spring-Boot-CLI
#  Copyright (c) 2018-2021 by www.gatblau.org
#  Licensed under the Apache License, Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0
#
#  Contributors to this project, hereby assign copyright in this code to the project,
#  to be licensed under the same terms as the rest of the code.
#
FROM alpine as builder

ENV GRADLE_VERSION 6.8
ENV SPRING_VERSION 2.4.5

WORKDIR /app/

# downloads gradle
RUN wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip gradle.zip && \
    rm gradle.zip

# download springboot cli
RUN wget --output-document=springboot.zip https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/${SPRING_VERSION}/spring-boot-cli-${SPRING_VERSION}-bin.zip && \
    unzip springboot.zip && \
    rm springboot.zip

FROM quay.io/artisan/ubi-min

USER root

ARG UNAME=runtime

ENV GRADLE_VERSION 6.8
ENV SPRING_VERSION 2.4.5
ENV JAVA_HOME /usr/lib/jvm/jre-openjdk

ENV GRADLE_HOME /usr/lib/gradle
ENV GRADLE_USER_HOME /app
ENV PATH $GRADLE_HOME/bin:$PATH
ENV SPRING_HOME /usr/lib/spring
ENV PATH $SPRING_HOME/bin:$PATH

# installs JDK 11
RUN microdnf install -y java-11-openjdk-devel git && \
    microdnf clean all && rm -rf /var/cache /var/log/dnf* /var/log/yum.* && \
    mkdir -p /.m2/repository/ && chown -R $UNAME /.m2/ && chmod -R a+wr /.m2/

# copy gradle
COPY --from=builder /app/gradle-$GRADLE_VERSION $GRADLE_HOME
# copy springboot
COPY --from=builder /app/spring-$SPRING_VERSION $SPRING_HOME

# springboot cli add symlinks to the appropriate location for your environment
RUN ln -s $SPRING_HOME/shell-completion/bash/spring /etc/bash_completion.d/spring && \
    mkdir -p /usr/local/share/zsh/site-functions && \
    ln -s $SPRING_HOME/shell-completion/zsh/_spring /usr/local/share/zsh/site-functions/_spring

USER $UNAME

