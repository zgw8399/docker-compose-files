#!/bin/bash
#
set -u

### 部署环境

# 模板版本
COMPOSE_VERSION=3.8

# 网络名
NETWORK_NAME=test

# 栈名
STACK_NAME=test

# 容器仓库
DOCKER_REGISTRY=172.28.16.155:5000

# 项目名
PROJECT_NAME=test

# 应用名
APP_NAME=testapp

# 应用版本
APP_VERSION=0.0.1

# 配置版本
CONFIG_VERSION=v1

# 镜像名
IMAGE_NAME=${DOCKER_REGISTRY}/${PROJECT_NAME}/${APP_NAME}:${APP_VERSION}

# 服务端口
SERVICE_PORT=30080

# 副本数
REPLICAS=1

## 资源配置

# 内存限制
LIMITS_MEMORY=512M

# CPU限制
LIMITS_CPUS=1

# 内存请求
RESERVATIONS_MEMORY=128M

# CPU请求
RESERVATIONS_CPUS=0.5

## 健康检查

# 检查间隔，默认为1分30秒
INTERVAL=90s

# 检查超时，默认为10秒
TIMEOUT=10s

# 命令失败重试的次数，默认为3次
RETRIES=3

# 应用程序启动的初始化时间，默认40秒
START_PERIOD=40s

### 定义函数

## 创建网络
create_network(){
    echo "--> 如果网络不存在，则创建"
    docker network inspect ${NETWORK_NAME} &>/dev/null
    RETVAL=$?
    if [ ${RETVAL} -ne 0 ];then
        docker network create --attachable -d overlay ${NETWORK_NAME}
        echo "网络 ${NETWORK_NAME} 创建成功。"
    else
        echo "网络 ${NETWORK_NAME} 已存在。"
    fi
}

## 生成部署所需文件
gen_files(){
# 配置文件（可选）
echo "--> 生成配置文件（可选）"
cat <<EOF >config.yaml
# MySQL连接参数
mysql:
  host: '127.0.0.1'
  user: ''
  password: ''
  database: ''

# MongoDB连接参数
mongo:
  host: '127.0.0.1'
  port: 27017
  username: ''
  password: ''
  authSource: 'admin'
  authMechanism: 'SCRAM-SHA-256'
  maxPoolSize: 1024
EOF
cat config.yaml

# 部署模板
echo "--> 生成部署模板"
cat <<EOF >docker-compose.yml
version: '${COMPOSE_VERSION}'

networks:
  app_net:
    external: true
    name: ${NETWORK_NAME}

configs:
  app_config_${CONFIG_VERSION}:
    file: ./config.yaml

services:
  ${APP_NAME}:
    image: ${IMAGE_NAME}
    ports:
      - ${SERVICE_PORT}:80
    networks:
      - app_net
    configs:
      - source: app_config_${CONFIG_VERSION}
        target: /app/configs/config.yaml
    deploy:
      mode: replicated
      replicas: ${REPLICAS}
      resources:
        limits:
          memory: ${LIMITS_MEMORY}
          cpus: '${LIMITS_CPUS}'
        reservations:
          memory: ${RESERVATIONS_MEMORY}
          cpus: '${RESERVATIONS_CPUS}'
    healthcheck:
      test: ["CMD-SHELL", "curl -f -s http://localhost/healthz || exit 1"]
      interval: ${INTERVAL}
      timeout: ${TIMEOUT}
      retries: ${RETRIES}
      start_period: ${START_PERIOD}
EOF
cat docker-compose.yml
}

## 构建容器
build(){
    echo "===构建容器==="
    docker build -t ${IMAGE_NAME} .
    docker push ${IMAGE_NAME}
}

## 部署容器
deploy(){
    echo "===部署容器==="
    create_network
    gen_files
    docker stack deploy -c docker-compose.yml ${STACK_NAME}
}

### 主程序

case $1 in
    build)
        build ;;
    deploy)
        deploy ;;
    *)
        echo "脚本使用方法：$0 {build|deploy}" ;;
esac

### 程序结束
