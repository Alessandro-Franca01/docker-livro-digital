#!/bin/bash

# Create necessary directories
mkdir -p docker/php

# Create custom PHP configuration file
cat > docker/php/custom.ini << 'EOF'
; Custom PHP configuration for PHP 7.4
; Optimized for Laravel applications

; Maximum memory allocation
memory_limit = 256M

; Maximum upload file size
upload_max_filesize = 20M
post_max_size = 20M

; Maximum execution time
max_execution_time = 60

; Error handling
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = /var/log/php/error.log

; Opcache settings
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=0

; Session
session.gc_maxlifetime = 1440

; Date
date.timezone = UTC
EOF

# Update docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: "3"
services:
    # PHP 7.4 application
    laravel_8:
        build:
            args:
                user: sandro
                uid: 1000
            context: ./
            dockerfile: Dockerfile
        image: laravel-7.4-app
        restart: unless-stopped
        working_dir: /var/www/
        volumes:
            - ./Livro-de-Inspertores/:/var/www
        depends_on:
            - redis
            # - queue
        networks:
            - laravel-eti

    # nginx
    nginx:
        image: nginx:alpine
        restart: unless-stopped
        ports:
            - 8180:80
        volumes:
            - ./Livro-de-Inspertores/:/var/www
            - ./docker/nginx/:/etc/nginx/conf.d/
        networks:
            - laravel-eti

    # redis
    redis:
        image: redis:latest
        networks:
            - laravel-eti

    # queue
    # queue:
    #     build:
    #         args:
    #             user: sandro
    #             uid: 1000
    #         context: ./Livro-de-Inspertores/
    #         dockerfile: Dockerfile
    #     restart: unless-stopped
    #     command: "php artisan queue:work"
    #     volumes:
    #         - ./Livro-de-Inspertores/:/var/www
    #     depends_on:
    #         - redis
    #     networks:
    #         - laravel-eti

    # db mysql
    # mysql:
    #     image: mysql:5.7.22
    #     restart: unless-stopped
    #     environment:
    #         MYSQL_DATABASE: ${DB_DATABASE}
    #         MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
    #         MYSQL_PASSWORD: ${DB_PASSWORD}
    #         MYSQL_USER: ${DB_USERNAME}
    #     volumes:
    #         - ./.docker/mysql/dbdata:/var/lib/mysql
    #     ports:
    #         - 3388:3306
    #     networks:
    #         - laravel-eti

networks:
    laravel-eti:
        driver: bridge
EOF

# Update Dockerfile
cat > Dockerfile << 'EOF'
FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    vi

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions with specific versions for PHP 7.4 compatibility
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# Set recommended PHP configurations for Laravel
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY ./docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# Get latest Composer
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Install redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Set working directory
WORKDIR /var/www

USER $user
EOF

echo "Setup complete! Run 'docker-compose build' to rebuild with PHP 7.4 configuration."