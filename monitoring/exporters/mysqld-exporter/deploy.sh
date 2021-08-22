#!/bin/bash
#
#===设定变量===

#设定网络
NETWORK=host

#设定主机端口
HOST_PORT=9104

#设定容器名
CONTAINER_NAME=mysqld_exporter

#设定数据库源
DATA_SOURCE="root:password@(192.168.2.1:3306)/"

#设定容器仓库
DOCKER_REGISTRY=

#设定项目名
PROJECT_NAME=monitoring

#设定镜像名
IMAGE_NAME=mysqld-exporter

#设定镜像版本
IMAGE_TAG=v0.12.1

docker run -detach \
  --network ${NETWORK} \
  --publish ${HOST_PORT}:9104 \
  --name ${CONTAINER_NAME} \
  --restart always \
  --env DATA_SOURCE_NAME="${DATA_SOURCE}" \
  ${DOCKER_REGISTRY}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG}

#===脚本结束===
