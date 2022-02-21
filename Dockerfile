# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jre:11 AS build
LABEL maintainer="137120918@qq.com" version="2.0.3"
ENV SENTINEL_VERSION=1.8.3 SENTINEL_HOME=/usr/local/sentinel JAVA_OPTIONS="-Dfile.encoding=utf-8 -Dserver.port=8080 -Dcsp.sentinel.dashboard.server=localhost:8080 -Dproject.name=sentinel-dashboard"
ENV JAVA_APP_JAR=${SENTINEL_HOME}/sentinel-dashboard.jar
RUN mkdir ${SENTINEL_HOME} && \
    curl -L https://github.com/alibaba/Sentinel/releases/download/${SENTINEL_VERSION}/sentinel-dashboard-${SENTINEL_VERSION}.jar -o ${SENTINEL_HOME}/sentinel-dashboard.jar
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
ENTRYPOINT /usr/local/run-java.sh
