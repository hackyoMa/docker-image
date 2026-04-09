# syntax=docker/dockerfile:1
FROM hackyo/node:24

LABEL maintainer="137120918@qq.com" version="20260312"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git python3 python3-pip libnspr4 libnss3 libatk1.0-0t64 libatk-bridge2.0-0t64 libcups2t64 libxcomposite1 libxdamage1 libatspi2.0-0t64; \
    rm -rf /var/lib/apt/lists/*; \
    echo "appuser ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get" > /etc/sudoers.d/appuser_apt; \
    chmod 440 /etc/sudoers.d/appuser_apt

USER appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"

RUN npm config set prefix "/home/appuser/.local"; \
    npm install -g playwright@1.59.1 openclaw@2026.4.8 @larksuiteoapi/node-sdk@1.60.0 @slack/web-api@7.15.0 @buape/carbon@0.14.0 grammy@1.42.0; \
    npm cache clean --force; \
    playwright install chromium; \
    ln -s /home/appuser/.cache/ms-playwright/chromium-1217/chrome-linux/chrome /home/appuser/.local/bin/chromium; \
    ln -s /home/appuser/.cache/ms-playwright/ffmpeg-1011/ffmpeg-linux  /home/appuser/.local/bin/ffmpeg; \
    openclaw --version

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:18789/

EXPOSE 18789

ENTRYPOINT ["openclaw"]
CMD ["gateway", "--port", "18789"]
