# syntax=docker/dockerfile:1
FROM hackyo/jre:21

LABEL maintainer="137120918@qq.com" version="20250903"

ENV JAVA_OPTS=""

RUN set -eux; \
    mkdir -p /opt/app; \
    tarUrl="https://repo1.maven.org/maven2/io/zipkin/zipkin-server/3.5.1/zipkin-server-3.5.1-exec.jar"; \
    curl -fL -o "/opt/app/app.jar" "${tarUrl}"

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:9411/ || exit 1
EXPOSE 9411

ENTRYPOINT ["sh", "-c", "exec java ${JAVA_OPTS} -jar /opt/app/app.jar"]
