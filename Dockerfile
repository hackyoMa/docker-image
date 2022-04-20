# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="20220420"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=11.54.25 ZULU_VERSION_AARCH64=11.54.25 JAVA_VERSION=11.0.14.1 JAVA_HOME=/usr/java/openjdk-11 JAVA_OPTIONS=-Dfile.encoding=utf-8
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
COPY run-java.sh /usr/java/run-java.sh
RUN chmod +x /usr/java/run-java.sh && \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then BASE_DOMAIN="zulu" && DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else BASE_DOMAIN="zulu-embedded" && DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/${BASE_DOMAIN}/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    ${JAVA_HOME}/bin/jlink --module-path ${JAVA_HOME}/jmods --add-modules java.base,java.compiler,java.datatransfer,java.desktop,java.instrument,java.logging,java.management,java.management.rmi,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.se,java.security.jgss,java.security.sasl,java.smartcardio,java.sql,java.sql.rowset,java.transaction.xa,java.xml.crypto,java.xml,jdk.accessibility,jdk.attach,jdk.charsets,jdk.compiler,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,jdk.editpad,jdk.hotspot.agent,jdk.httpserver,jdk.internal.ed,jdk.internal.jvmstat,jdk.internal.le,jdk.internal.opt,jdk.internal.vm.ci,jdk.jartool,jdk.javadoc,jdk.jcmd,jdk.jconsole,jdk.jdeps,jdk.jdi,jdk.jdwp.agent,jdk.jfr,jdk.jlink,jdk.jshell,jdk.jsobject,jdk.jstatd,jdk.localedata,jdk.management.agent,jdk.management.jfr,jdk.management,jdk.naming.dns,jdk.naming.ldap,jdk.naming.rmi,jdk.net,jdk.pack,jdk.rmic,jdk.scripting.nashorn,jdk.scripting.nashorn.shell,jdk.sctp,jdk.security.auth,jdk.security.jgss,jdk.unsupported.desktop,jdk.unsupported,jdk.xml.dom,jdk.zipfs --output /usr/local/jre && \
    rm -rf ${JAVA_HOME} && mv /usr/local/jre ${JAVA_HOME}
CMD ["java", "-version"]
