# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bookworm-slim AS build
LABEL maintainer="137120918@qq.com" version="20231013"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=8.72.0.17 ZULU_VERSION_AARCH64=8.72.0.17 JAVA_VERSION=8.0.382 JAVA_HOME=/usr/java/openjdk-8 JAVA_OPTIONS=-Dfile.encoding=utf-8
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then BASE_DOMAIN="zulu" && DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else BASE_DOMAIN="zulu-embedded" && DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir -p ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/${BASE_DOMAIN}/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    rm -r ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} ${JAVA_HOME}/jdk.tar.gz
CMD ["java", "-version"]
