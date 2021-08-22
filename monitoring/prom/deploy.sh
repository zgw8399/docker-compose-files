#!/bin/bash
#
#===设定变量===

#设定部署模板的版本
COMPOSE_FILE_VERSION="3.8"

#设定网络
APP_NETWORK_NAME=monitoring

#设定应用栈名
APP_STACK_NAME=monitoring

#设定容器仓库
DOCKER_REGISTRY=

#设定项目名
PROJECT_NAME=monitoring

#设定使用的镜像
CADDY_IMAGE_NAME=caddy
CADDY_IMAGE_TAG=latest
CADVISOR_IMAGE_NAME=cadvisor
CADVISOR_IMAGE_TAG=v0.36.0
GRAFANA_IMAGE_NAME=grafana
GRAFANA_IMAGE_TAG=7.1.0-ubuntu
ALERTMANAGER_IMAGE_NAME=alertmanager
ALERTMANAGER_IMAGE_TAG=v0.21.0
NODE_EXPORTER_IMAGE_NAME=swarmprom-node-exporter
NODE_EXPORTER_IMAGE_TAG=v0.16.0
PROMETHEUS_IMAGE_NAME=prometheus
PROMETHEUS_IMAGE_TAG=v2.20.0

#设定系统访问用户和密码
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=password
CADDY_ADMIN_USER=admin
CADDY_ADMIN_PASSWORD=password

#设定容器要调度的节点
NODE_NAME=docker-host-2

#设定服务的配置版本
PROMETHEUS_CONFIG_VERSION=v1

#===创建网络===

echo "===创建网络==="
docker network inspect ${APP_NETWORK_NAME} &>/dev/null
RETVAL=$?
if [ ${RETVAL} -ne 0 ];then
    docker network create --attachable -d overlay ${APP_NETWORK_NAME}
    echo "网络 ${APP_NETWORK_NAME} 创建成功。"
else
    echo "网络 ${APP_NETWORK_NAME} 已存在。"
fi

#===生成部署模板===

echo "===生成部署模板==="
eval "cat <<EOF
$(< docker-compose.yml.template)
EOF
" > docker-compose.yml
cat docker-compose.yml

#===部署应用===

echo "===部署应用==="
#给指定节点打标签，使容器调度到该节点
docker node update --label-add monitoring=yes ${NODE_NAME} &>/dev/null
#部署应用
docker stack deploy -c docker-compose.yml ${APP_STACK_NAME}
rm -f docker-compose.yml
echo "部署成功。"

#===脚本结束===
