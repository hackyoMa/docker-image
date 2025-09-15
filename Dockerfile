# syntax=docker/dockerfile:1
FROM hackyo/jre:21

LABEL maintainer="137120918@qq.com" version="20250903"

ENV JAVA_OPTS=""

RUN set -eux; \
    mkdir -p /opt/app; \
    tarUrl="https://github.com/alibaba/Sentinel/releases/download/1.8.8/sentinel-dashboard-1.8.8.jar"; \
    curl -fL -o "/opt/app/app.jar" "${tarUrl}"

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "exec java ${JAVA_OPTS} -jar /opt/app/app.jar"]
