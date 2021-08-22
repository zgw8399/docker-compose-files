#!/bin/bash
#
#===设定变量===

#设定部署的环境
NODE_ENV="test"

#设定部署模板的版本
COMPOSE_FILE_VERSION="3.8"

#设定网络
APP_NETWORK_NAME=logging

#设定应用栈名
APP_STACK_NAME=logging

#设定容器仓库
DOCKER_REGISTRY=

#设定项目名
PROJECT_NAME=logging

#设定使用的镜像
ES_IMAGE_NAME=elasticsearch
ES_IMAGE_TAG=7.8.1
KIBANA_IMAGE_NAME=kibana
KIBANA_IMAGE_TAG=7.8.1
LOGSTASH_IMAGE_NAME=logstash
LOGSTASH_IMAGE_TAG=7.8.1
LOGSPOUT_IMAGE_NAME=logspout-logstash
LOGSPOUT_IMAGE_TAG=latest
NGINX_IMAGE_NAME=nginx
NGINX_IMAGE_TAG=1.19.1-alpine

#设定系统访问用户和密码

#设定容器要调度的节点
NODE_NAME=docker-host-2

#设定服务的配置版本

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
docker node update --label-add logging=yes ${NODE_NAME} &>/dev/null
#部署应用
docker stack deploy -c docker-compose.yml ${APP_STACK_NAME}
rm -f docker-compose.yml
echo "部署成功。"

#===脚本结束===
