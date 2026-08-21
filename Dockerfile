# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

ARG TARGETPLATFORM
ARG VERSION
ARG JAVA_VERSION
ARG ZULU_VERSION

ENV JAVA_HOME="/usr/local/openjdk-${VERSION}"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x64" ;; \
      "linux/arm64") arch="aarch64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    mkdir -p "${JAVA_HOME}"; \
    curl -fsSL "https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${arch}.tar.gz" \
      | tar -xf -C "${JAVA_HOME}" --strip-components 1; \
    rm -rf "${JAVA_HOME}/demo" \
           "${JAVA_HOME}/man" \
           "${JAVA_HOME}/readme.txt" \
           "${JAVA_HOME}/Welcome.html" \
           "${JAVA_HOME}/sample" \
           "${JAVA_HOME}/src.zip"; \
    java -version

CMD ["java"]
