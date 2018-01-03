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
        tree \
        tzdata \
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
        pdo_mysql \
        pdo_pgsql && \
    pecl install \
        imagick && \
    apk del \
        build-deps

RUN echo "extension=imagick.so" > /usr/local/etc/php/conf.d/pecl-imagick.ini

# 设置时区
ENV TIME_ZONE Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

COPY ./config/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./config/conf.d/ /usr/local/etc/php/conf.d/

# 允许Composer作为root运行
ENV COMPOSER_ALLOW_SUPERUSER 1

# 安装Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# 替换国内镜像
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 安装Composer插件
RUN composer global require --optimize-autoloader \
        hirak/prestissimo && \
    composer global dumpautoload --optimize && \
    composer clear-cache

WORKDIR /opt/htdocs

EXPOSE 9000
