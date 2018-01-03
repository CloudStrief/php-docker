FROM nginx:alpine

# 替换为国内阿里Alpine镜像
COPY ./source.list /etc/apk/repositories

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/conf.d/ /etc/nginx/conf.d/

RUN  mkdir -p /opt/htdocs && mkdir -p /opt/log/nginx

# 设置时区
ENV TIME_ZONE Asia/Shanghai
RUN apk add --no-cache tzdata \
    && echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

EXPOSE 80
