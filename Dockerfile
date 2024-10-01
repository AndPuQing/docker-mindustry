FROM alpine:3.20.3

ARG VERSION

ENV SERVER_PATH=/mindustry

RUN mkdir -p ${SERVER_PATH} && \
    apk add --no-cache openjdk11-jre && \
    wget -q https://github.com/Anuken/Mindustry/releases/download/${VERSION}/server-release.jar -O ${SERVER_PATH}/server-release.jar

VOLUME ${SERVER_PATH}/config
WORKDIR ${SERVER_PATH}

ENTRYPOINT ["/usr/bin/java", "-jar", "server-release.jar"]

EXPOSE 6567/tcp 6567/udp
