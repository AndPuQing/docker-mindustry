FROM alpine:3.21 AS builder


ARG VERSION
RUN if [ -z "$VERSION" ]; then echo "VERSION build-arg is required"; exit 1; fi

ENV SERVER_PATH=/mindustry
WORKDIR ${SERVER_PATH}
RUN wget -q https://github.com/Anuken/Mindustry/releases/download/${VERSION}/server-release.jar

FROM alpine:3.21.3

ARG VERSION
LABEL maintainer="AndPuQing <me@puqing.work>" \
      org.opencontainers.image.source="https://github.com/AndPuQing/docker-mindustry" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="Mindustry dedicated server"

ENV SERVER_PATH=/mindustry
ENV USER=mindustry
ENV UID=1001
ENV GID=1001

RUN apk add --no-cache openjdk11-jre && \
    addgroup -g ${GID} ${USER} && \
    adduser -u ${UID} -G ${USER} -h ${SERVER_PATH} -D ${USER} && \
    mkdir -p ${SERVER_PATH}/config && \
    chown -R ${USER}:${USER} ${SERVER_PATH}

WORKDIR ${SERVER_PATH}
COPY --from=builder --chown=${USER}:${USER} ${SERVER_PATH}/server-release.jar .
VOLUME ${SERVER_PATH}/config

USER ${USER}
EXPOSE 6567/tcp 6567/udp

ENTRYPOINT ["/usr/bin/java", "-jar", "server-release.jar"]

CMD ["host"]