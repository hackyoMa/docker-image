# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/jre-8"

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
    tarUrl="https://cdn.azul.com/zulu/bin/zulu8.94.0.17-ca-jre8.0.492-linux_${arch}.tar.gz"; \
    curl -fL -o "${tempDir}/jdk.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/jdk.tar.gz" -C "${JAVA_HOME}" --strip-components 1; \
    rm -rf "${tempDir}" \
           "${JAVA_HOME}/ASSEMBLY_EXCEPTION" \
           "${JAVA_HOME}/DISCLAIMER" \
           "${JAVA_HOME}/LICENSE" \
           "${JAVA_HOME}/man" \
           "${JAVA_HOME}/readme.txt" \
           "${JAVA_HOME}/release" \
            "${JAVA_HOME}/THIRD_PARTY_README" \
           "${JAVA_HOME}/Welcome.html"; \
    java -version

CMD ["java"]
