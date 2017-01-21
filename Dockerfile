FROM php:7.0-alpine
MAINTAINER Dennis de Greef <github@link0.net>

RUN apk update && apk add --no-cache \
	autoconf \
	build-base \
	freetype-dev \
	git \
	icu-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libxml2-dev \
	openldap-dev \
	openssl \
	grep \
;

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# GD needs configuring
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install extensions
RUN docker-php-ext-install -j $(grep processor /proc/cpuinfo | wc -l) \
	dom \
	gd \
	iconv \
	intl \
	ldap \
	mbstring \
	pdo_mysql \
	zip \
;

# Clean up build environment
RUN apk del \
	autoconf \
	build-base \
;

# Install composer
COPY install_composer.sh /root
RUN /bin/sh /root/install_composer.sh && rm /root/install_composer.sh

# Be able to make phars
RUN echo "phar.readonly = 0" > /usr/local/etc/php/conf.d/phar-readonly.ini

# Run underprivileged user
RUN adduser -D -u 1000 php
USER php
WORKDIR /home/php
ENV PATH "/home/php/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Require some global composer packages for convenience
RUN composer global require "hirak/prestissimo:^0.3";
