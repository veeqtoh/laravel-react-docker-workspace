# FROM php:8-fpm-alpine

# ARG UID
# ARG GID

# ENV UID=${UID}
# ENV GID=${GID}

# RUN mkdir -p /var/www/html

# WORKDIR /var/www/html

# COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# # MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
# RUN delgroup dialout

# RUN addgroup -g ${GID} --system laravel
# RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

# RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
# RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
# RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# RUN docker-php-ext-install pdo pdo_mysql

# RUN mkdir -p /usr/src/php/ext/redis \
#     && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
#     && echo 'redis' >> /usr/src/php-available-exts \
#     && docker-php-ext-install redis

# RUN echo 'echo "Welcome to 3d7TechWorkspace!"' >> /root/.bashrc
# RUN echo 'echo -e "\e[1;31m3\e[0m\e[1;32md\e[0m\e[1;33m7\e[0m \e[1;34mTech\e[0m"' >> /root/.bashrc

# USER laravel

# CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]

FROM php:8-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

# Install bash
RUN apk update && \
    apk add --no-cache bash

# Install Node.js and npm
RUN apk update && \
    apk add --no-cache nodejs npm

# Install Git
RUN apk update && apk add --no-cache git

# Install Starship prompt
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system 3d7
RUN adduser -G 3d7 --system -D -s /bin/bash -u ${UID} 3d7

RUN sed -i "s/user = www-data/user = 3d7/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = 3d7/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install pdo pdo_mysql

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

RUN echo 'eval "$(starship init bash)"' >> /home/3d7/.bashrc
RUN echo 'echo -e "Welcome to \e[1;31m3\e[0m\e[1;32md\e[0m\e[1;33m7\e[0m \e[1;34mTech!\e[0m"' >> /home/3d7/.bashrc
RUN echo 'echo "This workspace is the dev environment for DocuHelp AI."' >> /home/3d7/.bashrc
RUN cp /home/3d7/.bashrc /home/3d7/.bash_profile

USER 3d7

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
