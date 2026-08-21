# syntax=docker/dockerfile:1
FROM hackyo/jre:25

ARG SENTINEL_VERSION=1.8.10

ENV JAVA_OPTS=""

USER appuser
WORKDIR /home/appuser

RUN set -eux; \
    curl -fsSL -o app.jar "https://github.com/alibaba/Sentinel/releases/download/${SENTINEL_VERSION}/sentinel-dashboard-${SENTINEL_VERSION}.jar";

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:8080/
EXPOSE 8080

CMD java ${JAVA_OPTS} -jar app.jar
