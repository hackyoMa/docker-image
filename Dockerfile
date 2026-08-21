# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

ARG TARGETPLATFORM
ARG FRP_VERSION=0.71.0

ENV FRP_HOME="/home/appuser/.local"
ENV PATH="${FRP_HOME}/bin:${PATH}"

WORKDIR /home/appuser
USER appuser

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="amd64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    mkdir -p "${FRP_HOME}/bin"; \
    curl -fsSL "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${arch}.tar.gz" \
      | tar -xzf - -C "${FRP_HOME}/bin" --strip-components 1; \
    frps --version

CMD ["frps", "-c", "/home/appuser/.local/bin/frps.toml"]
