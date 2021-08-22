#!/bin/bash
#
set -u

# ===部署环境===

# 设定模板版本
COMPOSE_FILE_VERSION="3.8"
# 设定网络名
APP_NETWORK_NAME=
# 设定应用名
APP_STACK_NAME=
# 设定容器镜像
DOCKER_REGISTRY=
PROJECT_NAME=
APP_NAME=
APP_VERSION=
# 设定服务暴露端口
SERVICE_PORT=30080
# 设定副本数
REPLICAS=1
# 资源配置
LIMITS_MEMORY=512M
LIMITS_CPUS=1
RESERVATIONS_MEMORY=128M
RESERVATIONS_CPUS=0.5
# 健康检查
INTERVAL=15s
TIMEOUT=10s
RETRIES=3
START_PERIOD=40s

# ===创建网络===

echo "===如果网络不存在，则创建==="
docker network inspect ${APP_NETWORK_NAME} &>/dev/null
RETVAL=$?
if [ ${RETVAL} -ne 0 ];then
    docker network create --attachable -d overlay ${APP_NETWORK_NAME}
    echo "网络 ${APP_NETWORK_NAME} 创建成功。"
else
    echo "网络 ${APP_NETWORK_NAME} 已存在。"
fi

# ===生成部署模板===

echo "===生成部署模板==="
eval "cat <<EOF
$(< docker-compose.yml.template)
EOF
" > docker-compose.yml
cat docker-compose.yml

# ===部署应用===

echo "===部署应用==="
docker stack deploy -c docker-compose.yml ${APP_STACK_NAME}
rm -f docker-compose.yml
echo "部署成功。"

# ===脚本结束===
