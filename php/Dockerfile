FROM php:7.2-fpm-alpine

# 替换为国内阿里Alpine镜像
COPY ./source.list /etc/apk/repositories

# 安装系统包和PHP扩展(此处以Yii 2.0 Framework所需为例)
RUN apk --update --virtual build-deps add \
        autoconf \
        make \
        gcc \
        g++ \
        libtool \
        icu-dev \
        curl-dev \
        freetype-dev \
        imagemagick-dev \
        pcre-dev \
        postgresql-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev && \
    apk add \
        git \
        curl \
        bash \
        bash-completion \
        icu \
        imagemagick \
        pcre \
        freetype \
        libintl \
        libjpeg-turbo \
        libpng \
        libltdl \
        libxml2 \
        mysql-client \
        postgresql && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-install \
        soap \
        zip \
        curl \
        bcmath \
        exif \
        gd \
        iconv \
        intl \
        mbstring \
        opcache \
        pcntl \
        posix \
        pdo_mysql \
        pdo_pgsql && \
    pecl install \
        imagick && \
    apk del \
        build-deps

RUN echo "extension=imagick.so" > /usr/local/etc/php/conf.d/pecl-imagick.ini

RUN apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS

# 安装PHP Memcached扩展
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && apk del .memcached-deps

# 安装PHP Redis扩展
RUN set -xe \
    && pecl install redis  \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

# 安装PHP Mongodb扩展
RUN set -xe \
    && apk add --no-cache --update openssl-dev \
    && pecl install mongodb  \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini

# 安装PHP Swoole扩展
RUN set -xe \
    && pecl install swoole  \
    && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini

RUN rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    apk del .phpize-deps

# 设置时区
ENV TIME_ZONE Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

COPY ./config/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./config/conf.d/ /usr/local/etc/php/conf.d/

# 允许Composer作为root运行
ENV COMPOSER_ALLOW_SUPERUSER 1

# 安装Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --version=1.10.19 && \
    mv composer.phar /usr/local/bin/composer

# 替换国内镜像
# RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
# 更换为Laravel China 维护的国内镜像
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org

# 安装Composer插件
RUN composer global require --optimize-autoloader \
        hirak/prestissimo && \
    composer global dumpautoload --optimize && \
    composer clear-cache

# 安装NPM
ENV NODE_VERSION 10.9.0
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
  # gpg keys listed at https://github.com/nodejs/node#release-team
  && for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
  ; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

# 替换为国内淘宝NPM镜像
RUN npm config set registry https://registry.npm.taobao.org
# 安装npm-check
RUN npm install --global npm-check

WORKDIR /opt/htdocs

EXPOSE 9000
