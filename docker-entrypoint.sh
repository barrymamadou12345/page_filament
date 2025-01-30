#!/bin/bash
set -e

cd /var/www

# Vérifier la connexion à MySQL
echo "Attente de MySQL..."
/usr/local/bin/wait-for-it.sh

echo "Débogage : Connexion à MySQL..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e 'SELECT 1;'

echo "Configuration de l'application..."

# Nettoyage du cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Génération de la clé si nécessaire
if [ -z "$APP_KEY" ]; then
    php artisan key:generate
fi

# Optimisations pour la production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Migrations de la base de données
echo "Exécution des migrations..."
php artisan migrate --force

# Configuration des permissions
chown -R www-data:www-data /var/www/storage
chmod -R 755 /var/www/storage

# Démarrage d'Apache avec le bon utilisateur
echo "Démarrage d'Apache..."
apache2-foreground

# Vérifier que le port  est ouvert et en écoute
echo "Vérification de la connexion à MySQL..."
until nc -z -v -w30 "$DB_HOST" "$DB_PORT"; do
  echo "En attente de la base de données MySQL..."
  sleep 5
done
echo "Base de données accessible !"

