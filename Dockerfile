# syntax=docker/dockerfile:1
FROM hackyo/node:24

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/openclaw-2026"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git python3 python3-pip \
      at-spi2-common fontconfig fontconfig-config fonts-freefont-ttf fonts-ipafont-gothic \
      fonts-liberation fonts-noto-color-emoji fonts-tlwg-loma-otf fonts-unifont fonts-wqy-zenhei \
      libasound2-data libasound2t64 libatk-bridge2.0-0t64 libatk1.0-0t64 libatomic1 libatspi2.0-0t64 \
      libavahi-client3 libavahi-common-data libavahi-common3 libcairo2 libcups2t64 libdatrie1 libdrm-amdgpu1 \
      libdrm-common libdrm2 libedit2 libfontconfig1 libfontenc1 libfreetype6 libfribidi0 libgbm1 libgl1 \
      libgl1-mesa-dri libglib2.0-0t64 libglvnd0 libglx-mesa0 libglx0 libgraphite2-3 libharfbuzz0b libice6 \
      libllvm19 libnspr4 libnss3 libpango-1.0-0 libpixman-1-0 libpng16-16t64 libsensors-config libsensors5 \
      libsm6 libthai-data libthai0 libunwind8 libvulkan1 libwayland-server0 libx11-6 libx11-data libx11-xcb1 \
      libxau6 libxaw7 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-randr0 libxcb-render0 libxcb-shm0 \
      libxcb-sync1 libxcb-xfixes0 libxcb1 libxcomposite1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxfont2 \
      libxi6 libxkbcommon0 libxkbfile1 libxml2 libxmu6 libxpm4 libxrandr2 libxrender1 libxshmfence1 libxt6t64 \
      libxxf86vm1 libz3-4 mesa-libgallium x11-common x11-xkb-utils xfonts-encodings xfonts-scalable xfonts-utils \
      xkb-data xserver-common xvfb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    echo "appuser ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get" > /etc/sudoers.d/appuser_apt; \
    chmod 440 /etc/sudoers.d/appuser_apt

USER appuser
WORKDIR /home/appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"

RUN set -eux; \
    npm config set prefix "/home/appuser/.local"; \
    npm install -g playwright@1.60.0 openclaw@2026.5.7; \
    npm cache clean --force; \
    playwright install chromium; \
    ln -s /home/appuser/.cache/ms-playwright/chromium-1223/chrome-linux/chrome /home/appuser/.local/bin/chromium; \
    ln -s /home/appuser/.cache/ms-playwright/ffmpeg-1011/ffmpeg-linux  /home/appuser/.local/bin/ffmpeg; \
    openclaw --version

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:18789/
EXPOSE 18789

CMD openclaw gateway --port 18789
