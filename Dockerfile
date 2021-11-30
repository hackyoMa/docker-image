# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:8 AS build
LABEL maintainer="137120918@qq.com" version="1.0.5"
ENV M2_VERSION=3.8.4 M2_HOME=/usr/local/maven
ENV PATH=${PATH}:${M2_HOME}/bin
RUN mkdir /usr/local/maven && mkdir /usr/local/maven/repo && \
    curl -L https://downloads.apache.org/maven/maven-3/${M2_VERSION}/binaries/apache-maven-${M2_VERSION}-bin.tar.gz -o /usr/local/maven/maven.tar.gz && \
    tar -xf /usr/local/maven/maven.tar.gz -C /usr/local/maven && \
    mv /usr/local/maven/apache-maven-${M2_VERSION}/* /usr/local/maven/ && \
    rm -r /usr/local/maven/apache-maven-${M2_VERSION} /usr/local/maven/maven.tar.gz
COPY settings.xml /usr/local/maven/conf/settings.xml
CMD ["mvn", "-v"]
