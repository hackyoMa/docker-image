# syntax=docker/dockerfile:1
FROM hackyo/jre:25

LABEL maintainer="137120918@qq.com" version="20260312"

ENV JAVA_OPTS=""

WORKDIR /opt/app

ADD https://repo1.maven.org/maven2/io/zipkin/zipkin-server/3.5.1/zipkin-server-3.5.1-exec.jar app.jar

RUN chmod 644 /opt/app/app.jar

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -fs -I -o /dev/null http://localhost:9411/ || exit 1

EXPOSE 9411

ENTRYPOINT ["container-init.sh"]
CMD java ${JAVA_OPTS} -jar /opt/app/app.jar
