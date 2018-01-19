# php-docker

Docker容器化PHP开发环境

> 请确保已安装了[Docker & Docker-Compose](https://www.docker.com/)

## Setup
`make build`

## Start
`make start`

## Stop
`make stop`

## PHP CLI
`make php-cli`
> 此命令使用PHP:fpm镜像创建了一个新的容器。若要在当前运行的PHP:fpm容器中进行操作，请使用`docker exec -it [PHP_CONTAINER] bash`命令（[PHP_CONTAINER]为当前运行的PHP:fpm容器的名称，可用命令`docker-compose ps`查看）

## Down
`make down`
