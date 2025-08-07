# syntax=docker/dockerfile:1
FROM hackyo/jre:8

LABEL maintainer="137120918@qq.com" version="20250806"

ENV JAVA_APP_DIR="/deployments" JAVA_MAJOR_VERSION=8 JAVA_OPTIONS="-Dfile.encoding=utf-8"


RUN set -eux; \
    mkdir -p "${JAVA_APP_DIR}"
COPY --chmod=755 run-java.sh "${JAVA_APP_DIR}"

CMD ["${JAVA_APP_DIR}/run-java.sh"]
