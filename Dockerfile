FROM hackyo/jdk:11
LABEL maintainer="137120918@qq.com"
WORKDIR /root
RUN curl -L https://github.com/alibaba/Sentinel/releases/download/1.8.1/sentinel-dashboard-1.8.1.jar -o /root/sentinel-dashboard.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "sentinel-dashboard.jar"]
