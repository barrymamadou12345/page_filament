# Dockerfile
FROM php:8.2-apache

# Définir les variables d'environnement
ENV DB_HOST=mysql-backend-09vk.onrender.com
ENV DB_PORT=3306
ENV DB_DATABASE=my_database
ENV DB_USERNAME=mysql
ENV DB_PASSWORD=RenderMysqlPassword

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
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

# Copie des fichiers de l'application
COPY . /var/www

# Installation des dépendances PHP
RUN composer install --working-dir=/var/www --no-interaction --optimize-autoloader

# Copie des scripts d'attente et de démarrage
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh /usr/local/bin/docker-entrypoint.sh

# Configuration des permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Exposition explicite du port 80
EXPOSE 80

# Point d'entrée
CMD ["/usr/local/bin/docker-entrypoint.sh"]
