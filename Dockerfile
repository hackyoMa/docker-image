# syntax=docker/dockerfile:1

ARG JAVA_VERSION

FROM hackyo/jdk:${JAVA_VERSION}

ARG VERSION=3
ARG MAVEN_VERSION=3.9.15

ENV MAVEN_HOME="/usr/share/maven"
ENV PATH="${MAVEN_HOME}/bin:${PATH}"

RUN set -eux; \
    mkdir -p "${MAVEN_HOME}"; \
    curl -fsSL "https://archive.apache.org/dist/maven/maven-${VERSION}/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
      | tar -xzf - -C "${MAVEN_HOME}" --strip-components 1; \
    rm -rf "${MAVEN_HOME}/README.txt"; \
    mvn -v

CMD ["mvn"]
