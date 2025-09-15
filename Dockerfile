# syntax=docker/dockerfile:1
FROM hackyo/jdk:11

LABEL maintainer="137120918@qq.com" version="20250903"

ENV MAVEN_HOME="/usr/share/maven"
ENV PATH="${MAVEN_HOME}/bin:${PATH}"

RUN set -eux; \
    mkdir -p ${MAVEN_HOME}; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://downloads.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz"; \
    curl -fL -o "${tempDir}/maven.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/maven.tar.gz" -C "${MAVEN_HOME}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    mvn -v
COPY settings.xml "${MAVEN_HOME}/conf/settings.xml"

CMD ["mvn", "-v"]
