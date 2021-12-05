FROM php:7.4-fpm

# Copy composer.lock and composer.json into the working directory
COPY composer.lock composer.json /usr/share/nginx/html/

# Set working directory
WORKDIR /usr/share/nginx/html

RUN apt-get update

# Install dependencies for the operating system software
RUN apt-get install -y \
    git \
    apt-utils \
    zip \
    curl \
    sudo \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions for php
RUN docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    mbstring \
    pdo_mysql \
    zip

# Install composer (php package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents to the working directory
COPY . /usr/share/nginx/html/

# Assign permissions of the working directory to the www-data user
RUN chown www-data:www-data /usr/share/nginx/html/storage
RUN chown www-data:www-data  /usr/share/nginx/html/bootstrap/cache

# Expose port 9000 and start php-fpm server (for FastCGI Process Manager)
EXPOSE 9000
CMD ["php-fpm"]
