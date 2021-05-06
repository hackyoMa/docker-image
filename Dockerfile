# syntax=docker/dockerfile:latest
FROM --platform=$BUILDPLATFORM hackyo/debian:buster-slim AS build
LABEL maintainer="137120918@qq.com"
ARG BUILDPLATFORM
ENV ZULU_VERSION=8.54.0.21 JAVA_VERSION=8.0.292 JAVA_HOME=/usr/local/java
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [[ ${BUILDPLATFORM} == "linux/amd64" ]]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="aarch64"; fi && \
    echo ${DOWNLOAD_ARCH}
RUN if [[ ${BUILDPLATFORM} == "linux/amd64" ]]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="aarch64"; fi && \
    mkdir /usr/local/java && \
    curl -L https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o /usr/local/java/jdk.tar.gz && \
    tar -xf /usr/local/java/jdk.tar.gz -C /usr/local/java && \
    mv /usr/local/java/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* /usr/local/java/ && \
    rm -r /usr/local/java/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} /usr/local/java/jdk.tar.gz
CMD ["java", "-version"]
