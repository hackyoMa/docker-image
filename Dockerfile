# syntax=docker/dockerfile:1
FROM hackyo/node:24

LABEL maintainer="137120918@qq.com" version="20260312"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git python3 python3-pip; \
    rm -rf /var/lib/apt/lists/*; \
    echo "appuser ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get" > /etc/sudoers.d/appuser_apt; \
    chmod 440 /etc/sudoers.d/appuser_apt

USER appuser

RUN npm config set prefix "/home/appuser/.local"; \
    npm install -g openclaw@2026.3.13; \
    npm cache clean --force; \
    openclaw --version

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:18789/

EXPOSE 18789

ENTRYPOINT ["openclaw"]
CMD ["gateway", "--port", "18789"]
