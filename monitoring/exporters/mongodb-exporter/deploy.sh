#!/bin/bash
#
#===设定变量===

#设定网络
NETWORK=host

#设定主机端口
HOST_PORT=9001

#设定容器名
CONTAINER_NAME=mongodb_exporter

#设定数据库源
DATA_SOURCE="mongodb://admin:password@192.168.2.1:27017"

#设定容器仓库
DOCKER_REGISTRY=

#设定项目名
PROJECT_NAME=monitoring

#设定镜像名
IMAGE_NAME=mongodb_exporter

#设定镜像版本
IMAGE_TAG=latest

docker run -detach \
  --network ${NETWORK} \
  --publish ${HOST_PORT}:9001 \
  --name ${CONTAINER_NAME} \
  --restart always \
  ${DOCKER_REGISTRY}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG} \
  -mongodb.uri ${DATA_SOURCE}

#===脚本结束===
