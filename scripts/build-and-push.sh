#!/bin/sh

set -eu

IMAGE_NAME="anderpuqing/mindustry"
REPO_API_URL="https://api.github.com/repos/Anuken/Mindustry/releases"

usage() {
    echo "Usage: $0 <version | latest | beta>"
    echo "  <version>: 指定具体的 Mindustry 版本号 (如 v146)"
    echo "  latest   : 自动发现并使用最新的 '稳定版' release"
    echo "  beta     : 自动发现并使用最新的 release (包括 '预发布版/beta')"
    exit 1
}

if ! command -v jq > /dev/null; then
    echo "错误: 未找到 'jq' 命令。请先安装 jq"
    echo "  - Ubuntu/Debian: sudo apt-get install jq"
    echo "  - CentOS/Fedora: sudo yum install jq"
    echo "  - macOS: brew install jq"
    exit 1
fi

if ! command -v docker > /dev/null; then
    echo "错误: 未找到 'docker' 命令。请确保 Docker 已安装并正在运行。"
    exit 1
fi

if [ -z "${1:-}" ]; then
    usage
fi

INPUT_VERSION="$1"
TAG=""
FLOATING_TAG=""

echo "--- 1. 版本发现 ---"

case "$INPUT_VERSION" in
    latest|stable)
        echo "正在从 GitHub 获取最新的 '稳定版' release..."
        TAG=$(curl -sSL "$REPO_API_URL/latest" | jq -r '.tag_name')
        FLOATING_TAG="latest"
        ;;

    beta|prerelease)
        echo "正在从 GitHub 获取最新的 'beta/预发布' release..."
        TAG=$(curl -sSL "$REPO_API_URL" | jq -r '.[0].tag_name')
        FLOATING_TAG="beta"
        ;;

    *)
        echo "使用指定的版本号: $INPUT_VERSION"
        TAG="$INPUT_VERSION"
esac

if [ -z "$TAG" ] || [ "$TAG" = "null" ]; then
    echo "错误: 无法为 '$INPUT_VERSION' 找到有效的版本标签。"
    echo "请检查你的网络或 GitHub 仓库 '$REPO_API_URL' 的状态。"
    exit 1
fi

echo "成功发现 Mindustry 版本: $TAG"

echo "\n--- 2. 构建并推送 Docker 镜像 ---"

DOCKER_TAGS="-t ${IMAGE_NAME}:${TAG}"

if [ -n "$FLOATING_TAG" ]; then
    DOCKER_TAGS="$DOCKER_TAGS -t ${IMAGE_NAME}:${FLOATING_TAG}"
    echo "将为镜像打上标签: '$TAG' 和 '$FLOATING_TAG'"
else
    echo "将为镜像打上标签: '$TAG'"
fi

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --build-arg "VERSION=$TAG" \
    $DOCKER_TAGS \
    --push \
    .

echo "\n✅ 成功！镜像已为版本 $TAG 构建并推送。"