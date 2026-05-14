# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/node-24"

ARG TARGETPLATFORM

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://nodejs.org/dist/v24.15.0/node-v24.15.0-linux-${arch}.tar.gz"; \
    curl -fL -o "${tempDir}/node.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/node.tar.gz" -C "/usr/local" --strip-components 1; \
    rm -rf "${tempDir}" \
           "${JAVA_HOME}/CHANGELOG.md" \
           "${JAVA_HOME}/LICENSE" \
           "${JAVA_HOME}/README.md" \
           "${JAVA_HOME}/share"; \
    node -v; \
    npm -v

CMD ["node"]
