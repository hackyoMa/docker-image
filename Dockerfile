# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:17 AS build
LABEL maintainer="137120918@qq.com" version="2.0.4"
ENV M2_VERSION=3.8.4 M2_HOME=/usr/local/maven
ENV PATH=${PATH}:${M2_HOME}/bin
RUN mkdir ${M2_HOME} && mkdir ${M2_HOME}/repo && \
    curl -L https://downloads.apache.org/maven/maven-3/${M2_VERSION}/binaries/apache-maven-${M2_VERSION}-bin.tar.gz -o ${M2_HOME}/maven.tar.gz && \
    tar -xf ${M2_HOME}/maven.tar.gz -C ${M2_HOME} && \
    mv ${M2_HOME}/apache-maven-${M2_VERSION}/* ${M2_HOME}/ && \
    rm -r ${M2_HOME}/apache-maven-${M2_VERSION} ${M2_HOME}/maven.tar.gz
COPY settings.xml ${M2_HOME}/conf/settings.xml
CMD ["mvn", "-v"]
