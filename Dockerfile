# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20260312"

ARG TARGETPLATFORM
ENV NODE_HOME="/usr/local"
ENV PATH="${NODE_HOME}/bin:${PATH}"
ENV SUB_CONTAINER_INIT="/usr/local/bin/node-container-init.sh"

COPY node-container-init.sh /usr/local/bin/

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://nodejs.org/dist/v24.14.0/node-v24.14.0-linux-${arch}.tar.gz"; \
    curl -fL -o "${tempDir}/node.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/node.tar.gz" -C "${NODE_HOME}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    chmod +x /usr/local/bin/node-container-init.sh; \
    node -v; \
    npm -v

CMD ["node"]
