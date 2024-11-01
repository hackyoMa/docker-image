# syntax=docker/dockerfile:latest
FROM hackyo/jre:21
LABEL maintainer="137120918@qq.com" version="20241030"
ENV ZIPKIN_VERSION=3.4.2
RUN mkdir /opt/app && \
    curl -L https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${ZIPKIN_VERSION}/zipkin-server-${ZIPKIN_VERSION}-exec.jar -o /opt/app/app.jar
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:9411/ || exit 1
EXPOSE 9411
ENTRYPOINT ["java", "-jar", "/opt/app/app.jar"]
