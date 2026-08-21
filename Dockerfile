# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

ARG TARGETPLATFORM
ARG NODE_VERSION

ENV NODE_HOME="/usr/local"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${arch}.tar.gz" \
      | tar -xzf - -C "${NODE_HOME}" --strip-components 1; \
    rm -rf "${NODE_HOME}/CHANGELOG.md" \
           "${NODE_HOME}/README.md" \
           "${NODE_HOME}/share"; \
    node -v; \
    npm -v

CMD ["node"]
