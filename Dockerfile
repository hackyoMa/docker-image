# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="1.0.4"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=17.28.13 ZULU_VERSION_AARCH64=17.28.13 JAVA_VERSION=17.0.0 JAVA_HOME=/usr/local/java
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir /usr/local/java && \
    curl -L https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o /usr/local/java/jdk.tar.gz && \
    tar -xf /usr/local/java/jdk.tar.gz -C /usr/local/java && \
    mv /usr/local/java/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* /usr/local/java/ && \
    rm -r /usr/local/java/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} /usr/local/java/jdk.tar.gz
CMD ["java", "-version"]
