FROM lslio/nginx-php-fpm:latest

RUN apk add --no-cache libpng libpng-dev \
    zlib-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    bzip2-dev \
    zip \
    libzip-dev

# Add Production Dependencies
RUN apk add --update --no-cache \
    jpegoptim \
    pngquant \
    optipng \
    nano \
    postgresql-dev \ 
    icu-dev \
    freetype-dev

COPY --from=composer /usr/bin/composer /usr/bin/composer
