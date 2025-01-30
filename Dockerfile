# Utiliser une image de base PHP avec Apache
FROM php:8.2-apache

# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
 && docker-php-ext-install pdo pdo_mysql intl zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers de l'application
COPY . /var/www

# Configurer Apache pour utiliser le répertoire public de Laravel
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i 's|/var/www/html|/var/www/public|g' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's|/var/www/html|/var/www/public|g' /etc/apache2/apache2.conf

# Installer les dépendances
RUN composer install --working-dir=/var/www

# Exécuter les migrations
RUN php /var/www/artisan migrate --force

# Exécuter les seeders
RUN php /var/www/artisan db:seed --force

# Configurer les permissions
RUN chown -R www-data:www-data /var/www

# Exposer le port 80
EXPOSE 80

# Démarrer Apache
CMD ["apache2-foreground"]
