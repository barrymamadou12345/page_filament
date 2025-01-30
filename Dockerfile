# 2. Dockerfile
FROM php:8.2-apache

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    default-mysql-client \
    git \
    && docker-php-ext-install pdo pdo_mysql intl zip

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuration d'Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Copie de la configuration Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

# Copie des fichiers de l'application
COPY . /var/www

# Installation des dépendances PHP
WORKDIR /var/www
RUN composer install --no-dev --optimize-autoloader

# Configuration des permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Exposition du port
EXPOSE 80

# Script de démarrage
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
CMD ["/usr/local/bin/docker-entrypoint.sh"]