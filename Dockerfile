# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="20220715"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=17.34.19 ZULU_VERSION_AARCH64=17.34.19 JAVA_VERSION=17.0.3 JAVA_HOME=/usr/java/openjdk-17 JAVA_OPTIONS=-Dfile.encoding=utf-8
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
COPY run-java.sh /usr/java/run-java.sh
RUN chmod +x /usr/java/run-java.sh && \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    rm -r ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} ${JAVA_HOME}/jdk.tar.gz
CMD ["java", "-version"]
