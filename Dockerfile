FROM hackyo/debian:bookworm-slim
LABEL maintainer="137120918@qq.com" version="20250806"
ARG TARGETPLATFORM
ARG JAVA_ARCH="aarch64"
ENV JAVA_VERSION=8u461 JAVA_HOME=/usr/local/openjdk-8
ENV PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then \
      JAVA_ARCH="x64"; \
    else \
      JAVA_ARCH="aarch64"; \
    fi;
ADD jdk-${JAVA_VERSION}-linux-${JAVA_ARCH}.tar.gz ${JAVA_HOME}
RUN mv ${JAVA_HOME}/* ${JAVA_HOME}/tmp/ \
    && mv ${JAVA_HOME}/tmp/* ${JAVA_HOME}/ \
    && rmdir ${JAVA_HOME}/tmp \
    && java -version
CMD ["java", "-version"]
