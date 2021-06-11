# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="1.0.1"
ARG TARGETPLATFORM
ENV ZULU_VERSION=8.54.0.21 JAVA_VERSION=8.0.292 JAVA_HOME=/usr/local/java
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then BASE_DOMAIN="zulu" && DOWNLOAD_ARCH="x64"; else BASE_DOMAIN="zulu-embedded" && DOWNLOAD_ARCH="aarch64"; fi && \
    mkdir /usr/local/java && \
    curl -L https://cdn.azul.com/${BASE_DOMAIN}/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o /usr/local/java/jdk.tar.gz && \
    tar -xf /usr/local/java/jdk.tar.gz -C /usr/local/java && \
    mv /usr/local/java/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* /usr/local/java/ && \
    rm -r /usr/local/java/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} /usr/local/java/jdk.tar.gz
CMD ["java", "-version"]
