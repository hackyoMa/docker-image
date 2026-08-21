# syntax=docker/dockerfile:1
FROM hackyo/jre:25

ARG ZIPKIN_VERSION=3.6.1

ENV JAVA_OPTS=""

USER appuser
WORKDIR /home/appuser

RUN set -eux; \
    curl -fsSL -o app.jar "https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${ZIPKIN_VERSION}/zipkin-server-${ZIPKIN_VERSION}-exec.jar";

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fsI -o /dev/null http://localhost:9411/
EXPOSE 9411

CMD java ${JAVA_OPTS} -jar app.jar
