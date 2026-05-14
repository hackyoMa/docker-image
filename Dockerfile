# syntax=docker/dockerfile:1
FROM hackyo/jre:25

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/zipkin-3"

ENV JAVA_OPTS=""

USER appuser
WORKDIR /home/appuser

RUN set -eux; \
    tarUrl="https://repo1.maven.org/maven2/io/zipkin/zipkin-server/3.6.1/zipkin-server-3.6.1-exec.jar"; \
    curl -fL -o app.jar "${tarUrl}"

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:9411/
EXPOSE 9411

CMD java ${JAVA_OPTS} -jar app.jar
