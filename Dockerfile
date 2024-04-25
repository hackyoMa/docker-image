# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bookworm-slim AS build
LABEL maintainer="137120918@qq.com" version="20240425"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=11.72.19 ZULU_VERSION_AARCH64=11.72.19 JAVA_VERSION=11.0.23 JAVA_HOME=/usr/java/openjdk-11 JAVA_OPTIONS=-Dfile.encoding=utf-8
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir -p ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    ${JAVA_HOME}/bin/jlink --module-path ${JAVA_HOME}/jmods --add-modules ALL-MODULE-PATH --output /usr/local/jre && \
    rm -rf ${JAVA_HOME} && mv /usr/local/jre ${JAVA_HOME}
CMD ["java", "-version"]
