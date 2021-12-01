# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="2.0.0"
ARG TARGETPLATFORM
ENV ZULU_VERSION_X64=17.30.15 ZULU_VERSION_AARCH64=17.30.15 JAVA_VERSION=17.0.1 JAVA_HOME=/usr/local/java
ENV CLASSPATH=${JAVA_HOME}/lib PATH=${PATH}:${JAVA_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64" && ZULU_VERSION=${ZULU_VERSION_X64}; else DOWNLOAD_ARCH="aarch64" && ZULU_VERSION=${ZULU_VERSION_AARCH64}; fi && \
    mkdir ${JAVA_HOME} && \
    curl -L https://cdn.azul.com/zulu/bin/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}.tar.gz -o ${JAVA_HOME}/jdk.tar.gz && \
    tar -xf ${JAVA_HOME}/jdk.tar.gz -C ${JAVA_HOME} && \
    mv ${JAVA_HOME}/zulu${ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_${DOWNLOAD_ARCH}/* ${JAVA_HOME}/ && \
    ${JAVA_HOME}/bin/jlink --module-path ${JAVA_HOME}/jmods --add-modules java.base,jdk.charsets,jdk.jfr,java.compiler,jdk.compiler,jdk.jlink,java.datatransfer,jdk.crypto.cryptoki,jdk.jpackage,java.desktop,jdk.crypto.ec,jdk.jshell,java.instrument,jdk.dynalink,jdk.jsobject,java.logging,jdk.editpad,jdk.jstatd,java.management,jdk.hotspot.agent,jdk.localedata,java.management.rmi,jdk.httpserver,jdk.management.agent,java.naming,jdk.incubator.foreign,jdk.management.jfr,java.net.http,jdk.incubator.vector,jdk.management,java.prefs,jdk.internal.ed,jdk.naming.dns,java.rmi,jdk.internal.jvmstat,jdk.naming.rmi,java.scripting,jdk.internal.le,jdk.net,java.se,jdk.internal.opt,jdk.nio.mapmode,java.security.jgss,jdk.internal.vm.ci,jdk.random,java.security.sasl,jdk.internal.vm.compiler,jdk.sctp,java.smartcardio,jdk.internal.vm.compiler.management,jdk.security.auth,java.sql,jdk.jartool,jdk.security.jgss,java.sql.rowset,jdk.javadoc,jdk.unsupported.desktop,java.transaction.xa,jdk.jcmd,jdk.unsupported,java.xml.crypto,jdk.jconsole,jdk.xml.dom,java.xml,jdk.jdeps,jdk.zipfs,jdk.accessibility,jdk.jdi,jdk.attach,jdk.jdwp.agent --output /usr/local/jre && \
    rm -rf ${JAVA_HOME} && mv /usr/local/jre ${JAVA_HOME}
CMD ["java", "-version"]
