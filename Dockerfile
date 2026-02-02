# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20260202"

ARG TARGETPLATFORM
ENV JAVA_HOME="/usr/local/openjdk-8"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x64" ;; \
      "linux/arm64") arch="aarch64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    mkdir -p "${JAVA_HOME}"; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://cdn.azul.com/zulu/bin/zulu8.92.0.19-ca-jre8.0.482-linux_${arch}.tar.gz"; \
    curl -fL -o "${tempDir}/jdk.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/jdk.tar.gz" -C "${JAVA_HOME}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    java -version

CMD ["java", "-version"]
