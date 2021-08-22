#!/bin/bash
#
set -u

# 构建环境
DOCKER_REGISTRY=
PROJECT_NAME=
APP_NAME=
APP_VERSION=

# 构建镜像
docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}/${APP_NAME}:${APP_VERSION} .

# 推送镜像
docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}/${APP_NAME}:${APP_VERSION}
