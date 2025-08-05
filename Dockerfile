# syntax=docker/dockerfile:latest
FROM hackyo/jre:8
LABEL maintainer="137120918@qq.com" version="20250721"
RUN mkdir -p /deployments
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh
ENV JAVA_APP_DIR=/deployments JAVA_MAJOR_VERSION=8 JAVA_OPTIONS=-Dfile.encoding=utf-8
CMD ["/deployments/run-java.sh"]
