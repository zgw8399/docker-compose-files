#!/bin/bash
#
#===设定变量===

#设定部署模板的版本
COMPOSE_FILE_VERSION="3.8"

#设定网络
APP_NETWORK_NAME=mes

#设定应用栈名
APP_STACK_NAME=exporter

#设定容器仓库
DOCKER_REGISTRY=

#设定项目名
PROJECT_NAME=monitoring

#设定使用的镜像
BLACKBOX_IMAGE_NAME=blackbox-exporter
BLACKBOX_IMAGE_TAG=v0.17.0

#设定服务端口
BLACKBOX_SERVICE_PORT=9116

#设定服务的配置版本
BLACKBOX_CONFIG_VERSION=v1

#===生成部署模板===

echo "===生成部署模板==="
eval "cat <<EOF
$(< docker-compose.yml.template)
EOF
" > docker-compose.yml
cat docker-compose.yml

#===部署应用===

echo "===部署应用==="
#docker stack deploy -c docker-compose.yml ${APP_STACK_NAME}
rm -f docker-compose.yml
echo "部署成功。"

#===脚本结束===
