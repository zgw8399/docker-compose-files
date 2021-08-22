#!/bin/bash
#
#===设定变量===

#设定网络
NETWORK=host

#设定主机端口
HOST_PORT=9115

#设定容器名
CONTAINER_NAME=blackbox_exporter

#设定容器仓库
DOCKER_REGISTRY=

#设定项目名
PROJECT_NAME=monitoring

#设定镜像名
IMAGE_NAME=blackbox-exporter

#设定镜像版本
IMAGE_TAG=v0.17.0

docker run -detach \
  --network ${NETWORK} \
  --publish ${HOST_PORT}:9115 \
  --name ${CONTAINER_NAME} \
  --restart always \
  --volume `pwd`:/config \
  ${DOCKER_REGISTRY}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG} \
  --config.file=/config/blackbox.yml

#===脚本结束===
