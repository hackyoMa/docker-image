# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jre:21 AS build
LABEL maintainer="137120918@qq.com" version="20231013"
ENV SPRING_BOOT_ADMIN_HOME=/usr/share/spring-boot-admin
ENV JAVA_APP_JAR=${SPRING_BOOT_ADMIN_HOME}/spring-boot-admin.jar
COPY target/spring-boot-admin-3.1.5.jar ${SPRING_BOOT_ADMIN_HOME}/spring-boot-admin.jar
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:8080/actuator/health || exit 1
EXPOSE 8080
ENTRYPOINT java -jar ${JAVA_APP_JAR} ${JAVA_OPTIONS}
