# syntax=docker/dockerfile:1
FROM hackyo/jre:25

LABEL maintainer="137120918@qq.com" version="20260204"

ENV JAVA_OPTS=""

WORKDIR /opt/app

ADD https://github.com/alibaba/Sentinel/releases/download/1.8.9/sentinel-dashboard-1.8.9.jar app.jar

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fs -I -o /dev/null http://localhost:8080/ || exit 1

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD java ${JAVA_OPTS} -jar /opt/app/app.jar
