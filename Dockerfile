# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20250903"

ARG TARGETPLATFORM
ENV NODE_HOME="/usr/local"
ENV PATH="${NODE_HOME}/node_global/bin:${NODE_HOME}/bin:${PATH}"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://nodejs.org/dist/v22.19.0/node-v22.19.0-linux-${arch}.tar.gz"; \
    curl -fL -o "${tempDir}/node.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/node.tar.gz" -C "${NODE_HOME}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    npm config set prefix "${NODE_HOME}/node_global"; \
    npm config set cache "${NODE_HOME}/node_cache"; \
    node -v; \
    npm -v

CMD ["node", "-v"]
