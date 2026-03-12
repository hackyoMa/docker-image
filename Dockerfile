# syntax=docker/dockerfile:1
FROM hackyo/node:24

LABEL maintainer="137120918@qq.com" version="20260312"

ENV SUB_CONTAINER_INIT="/usr/local/bin/openclaw-container-init.sh"

COPY openclaw-container-init.sh /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git; \
    rm -rf /var/lib/apt/lists/*; \
    npm install -g openclaw@2026.3.11; \
    npm cache clean --force; \
    chmod +x /usr/local/bin/openclaw-container-init.sh; \
    openclaw --version

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:18789/

EXPOSE 18789

ENTRYPOINT ["container-init.sh"]
CMD openclaw gateway --port 18789
