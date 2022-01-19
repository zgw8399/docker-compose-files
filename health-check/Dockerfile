FROM python:3.6.13-alpine3.13

MAINTAINER varden

# 修改安装源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
ENV LANG C.UTF-8
RUN apk update

# 安装必需软件和修改时区
RUN apk add --no-cache ca-certificates tzdata curl bash && rm -rf /var/cache/apk/*
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

# 设定容器工作目录
WORKDIR /app

# 安装程序依赖
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

# 添加程序代码
ADD code/ /app/

# 运行程序
CMD python app.py
