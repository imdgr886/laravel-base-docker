FROM php:7.4-fpm-alpine

RUN apk add --no-cache libpng libpng-dev \
    zlib-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    bzip2-dev \
    zip \
    libzip-dev \
    nginx

# Add Production Dependencies
RUN apk add --update --no-cache \
    jpegoptim \
    pngquant \
    optipng \
    nano \
    postgresql-dev \ 
    icu-dev \
    freetype-dev

# Configure & Install Extension
RUN docker-php-ext-configure \
    opcache --enable-opcache &&\
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql &&\
    docker-php-ext-configure zip && \
    docker-php-ext-install \
    opcache \
    pdo_pgsql \
    pdo_mysql \
    pgsql \
    pdo \
    sockets \
    json \
    intl \
    gd \
    xml \
    bz2 \
    pcntl \
    bcmath \
    exif \
    zip
    
COPY run.sh /app/run.sh
    
RUN sed -i 's/listen = 9000/listen = /run/php/php7.4-fpm.sock/' /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i 's/user nginx/user www-data/' /etc/nginx/nginx.conf
RUN mkdir /run/nginx && touch /run/nginx/nginx.pid && \
    mkdir /run/php && touch /run/php/php7.4-fpm.sock && \
    chmod +x /app/run.sh
    
COPY opcache.ini $PHP_INI_DIR/conf.d/
COPY nginx.www.conf /etc/nginx/http.d/default.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

EXPOSE 80
EXPOSE 9000

ENTRYPOINT ["/app/run.sh"]


