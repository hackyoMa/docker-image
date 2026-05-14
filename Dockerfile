# syntax=docker/dockerfile:1
FROM hackyo/jdk:8

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/maven-3.9-jdk-8"

ENV MAVEN_HOME="/usr/share/maven"
ENV PATH="${MAVEN_HOME}/bin:${PATH}"

RUN set -eux; \
    mkdir -p ${MAVEN_HOME}; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://dlcdn.apache.org/maven/maven-3/3.9.15/binaries/apache-maven-3.9.15-bin.tar.gz"; \
    curl -fL -o "${tempDir}/maven.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/maven.tar.gz" -C "${MAVEN_HOME}" --strip-components 1; \
    rm -rf "${tempDir}" \
           "${MAVEN_HOME}/LICENSE" \
           "${MAVEN_HOME}/NOTICE" \
           "${MAVEN_HOME}/README.txt"; \
    mvn -v

CMD ["mvn"]
