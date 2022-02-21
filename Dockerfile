# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="2.0.3"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=11.54.23 ZULU_VERSION_AARCH64=11.54.23 JAVA_VERSION=11.0.14 JAVA_HOME=/usr/local/java JAVA_OPTIONS=-Dfile.encoding=utf-8
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
COPY run-java.sh /usr/local/run-java.sh
RUN chmod +x /usr/local/run-java.sh && \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then BASE_DOMAIN="zulu" && DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else BASE_DOMAIN="zulu-embedded" && DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/${BASE_DOMAIN}/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    rm -r ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} ${JAVA_HOME}/jdk.tar.gz
CMD ["java", "-version"]
