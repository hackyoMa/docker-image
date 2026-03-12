# syntax=docker/dockerfile:1
FROM hackyo/node:24

LABEL maintainer="137120918@qq.com" version="20260312"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git; \
    rm -rf /var/lib/apt/lists/*; \
    npm install -g openclaw@2026.3.11; \
    npm cache clean --force; \
    openclaw --version

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:18789/

EXPOSE 18789

ENTRYPOINT ["gosu", "appuser"]
CMD ["openclaw", "gateway", "--port", "18789"]
