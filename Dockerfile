# syntax=docker/dockerfile:latest
FROM hackyo/debian:bookworm-slim
LABEL maintainer="137120918@qq.com" version="20250721"
ARG TARGETPLATFORM
ENV ZULU_VERSION=21.44.17 JAVA_VERSION=21.0.8 JAVA_HOME=/usr/java/openjdk-21
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="aarch64"; fi && \
    mkdir -p ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    rm -r ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH} ${JAVA_HOME}/jdk.tar.gz
CMD ["java", "-version"]
