# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="20220330"
ARG TARGETPLATFORM
ENV TEMURIN_VERSION="8u322-b06" JAVA_VERSION="8u322b06" JAVA_HOME=/usr/local/java JAVA_OPTIONS=-Dfile.encoding=utf-8
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
COPY run-java.sh /usr/local/run-java.sh
RUN chmod +x /usr/local/run-java.sh && \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="aarch64"; fi && \
    mkdir ${JAVA_HOME} && \
    curl -L https://github.com/adoptium/temurin8-binaries/releases/download/jdk${TEMURIN_VERSION}/OpenJDK8U-jdk_${DOWNLOAD_ARCH}_linux_hotspot_${JAVA_VERSION}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/jdk${TEMURIN_VERSION}/* ${JAVA_HOME}/ && \
    rm -r ${JAVA_HOME}/jdk${TEMURIN_VERSION} ${JAVA_HOME}/jdk.tar.gz
CMD ["java", "-version"]
