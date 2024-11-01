# syntax=docker/dockerfile:latest
FROM hackyo/jdk:11
LABEL maintainer="137120918@qq.com" version="20241030"
ENV MAVEN_VERSION=3.9.6 MAVEN_HOME=/usr/share/maven
ENV PATH=${PATH}:${MAVEN_HOME}/bin
RUN mkdir ${MAVEN_HOME} && mkdir ${MAVEN_HOME}/repo && \
    curl -L https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -o ${MAVEN_HOME}/maven.tar.gz && \
    tar -xf ${MAVEN_HOME}/maven.tar.gz -C ${MAVEN_HOME} && \
    mv ${MAVEN_HOME}/apache-maven-${MAVEN_VERSION}/* ${MAVEN_HOME}/ && \
    rm -r ${MAVEN_HOME}/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME}/maven.tar.gz
COPY settings.xml ${MAVEN_HOME}/conf/settings.xml
CMD ["mvn", "-v"]
