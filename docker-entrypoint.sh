# docker-entrypoint.sh
#!/bin/bash
set -e

# Attendre que MySQL soit disponible
echo "Attente de MySQL..."
/usr/local/bin/wait-for-it.sh

# Préparation de l'application
echo "Configuration de l'application..."
cd /var/www

# Optimisations pour la production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Migrations de la base de données
echo "Exécution des migrations..."
php artisan migrate --force

# Seeders (si nécessaire)
if [ "${RUN_SEEDER:-false}" = "true" ]; then
    echo "Exécution des seeders..."
    php artisan db:seed --force
fi

# Nettoyage du cache si nécessaire
php artisan cache:clear

# Démarrage d'Apache
echo "Démarrage d'Apache..."
apache2-foreground