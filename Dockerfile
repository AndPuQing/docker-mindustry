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

RUN apk add --no-cache openjdk11-jre && \
    mkdir -p ${SERVER_PATH}/config &&

WORKDIR ${SERVER_PATH}
COPY --from=builder ${SERVER_PATH}/server-release.jar .
VOLUME ${SERVER_PATH}/config

EXPOSE 6567/tcp 6567/udp

ENTRYPOINT ["/usr/bin/java", "-jar", "server-release.jar"]

CMD ["host"]