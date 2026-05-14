# syntax=docker/dockerfile:1
FROM hackyo/jre:25

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/sentinel-1.8"

ENV JAVA_OPTS=""

USER appuser
WORKDIR /home/appuser

RUN set -eux; \
    tarUrl="https://github.com/alibaba/Sentinel/releases/download/1.8.9/sentinel-dashboard-1.8.9.jar"; \
    curl -fL -o app.jar "${tarUrl}"

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:8080/
EXPOSE 8080

CMD java ${JAVA_OPTS} -jar app.jar
