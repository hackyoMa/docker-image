# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jre:17 AS build
LABEL maintainer="137120918@qq.com" version="20221109"
ENV ZIPKIN_VERSION=2.23.19 ZIPKIN_HOME=/usr/share/zipkin
ENV JAVA_APP_JAR=${ZIPKIN_HOME}/zipkin.jar
RUN mkdir ${ZIPKIN_HOME} && \
    curl -L https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${ZIPKIN_VERSION}/zipkin-server-${ZIPKIN_VERSION}-exec.jar -o ${ZIPKIN_HOME}/zipkin.jar
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:9411/ || exit 1
EXPOSE 9411
ENTRYPOINT /usr/java/run-java.sh
