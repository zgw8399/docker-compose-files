FROM nginx:1.19.1-alpine

MAINTAINER varden

RUN echo "https://mirrors.aliyun.com/alpine/v3.11/main/" > /etc/apk/repositories
RUN echo "https://mirrors.aliyun.com/alpine/v3.11/community/" >> /etc/apk/repositories
RUN apk update
RUN apk upgrade

RUN apk add --no-cache ca-certificates tzdata curl bash && rm -rf /var/cache/apk/*
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
