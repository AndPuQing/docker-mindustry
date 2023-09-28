#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

# Get latest beta version
if [ "$1" = "latest" ] || [ "$1" = "beta" ]; then
    TAG=$(wget -qO- -t1 -T2 "https://api.github.com/repos/Anuken/Mindustry/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
    VERSION_TYPE="latest"

    echo "Found latest beta version: \"$TAG\""
fi

# Build command
START_CMD="docker build"
PUSH_ARG="--push"
PLATFORM_ARG="--platform linux/amd64"
DOCKER_VERSION_TAG_ARG="-t anderpuqing/mindustry:$TAG"
END_CMD="--build-arg "VERSION"="$TAG" ."

CMD="$START_CMD $PUSH_ARG $PLATFORM_ARG $DOCKER_VERSION_TAG_ARG"

CMD="$CMD $END_CMD"

# Run command
echo "Running command:"
echo "$CMD"

eval $CMD
