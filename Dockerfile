# syntax=docker/dockerfile:1
FROM hackyo/jre:8

LABEL maintainer="137120918@qq.com" version="20250903"

ARG TARGETPLATFORM
ENV JAVA_APP_DIR="/deployments" JAVA_MAJOR_VERSION=8 JAVA_OPTIONS="-Dfile.encoding=utf-8"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="amd64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    sed -i 's#^securerandom.source=.*#securerandom.source=file:/dev/urandom#' /usr/local/openjdk-8/lib/security/java.security; \
    validatorUrl="https://fit2cloud-support.oss-cn-beijing.aliyuncs.com/xpack-license/validator_linux_${arch}"; \
    curl -fL -o "/usr/bin/validator" "${validatorUrl}"; \
    chmod +x /usr/bin/validator; \
    curl -fL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash; \
    mkdir -p "${JAVA_APP_DIR}"
COPY --chmod=755 run-java.sh "${JAVA_APP_DIR}"

CMD ["${JAVA_APP_DIR}/run-java.sh"]
