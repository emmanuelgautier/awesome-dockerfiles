FROM composer:2 AS vendor

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --no-dev \
    --no-interaction \
    --no-scripts \
    --no-progress \
    --prefer-dist \
    --optimize-autoloader

FROM php:8.5-apache AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
        libicu-dev=76.1-4 \
    && docker-php-ext-install -j"$(nproc)" \
        intl \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

COPY docker/php.prod.ini "$PHP_INI_DIR/conf.d/99-symfony.ini"
COPY docker/apache.conf /etc/apache2/sites-available/000-default.conf

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public \
    APP_ENV=prod \
    APP_DEBUG=0

WORKDIR /var/www/html

COPY --chown=www-data:www-data . .
COPY --from=vendor --chown=www-data:www-data /app/vendor ./vendor

RUN rm -rf docker tests .env.dev .env.test \
    && mkdir -p var/cache var/log \
    && APP_SECRET=build-time-placeholder php bin/console cache:warmup --no-debug \
    && chown -R www-data:www-data var

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
