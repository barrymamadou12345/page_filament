# 3. docker-entrypoint.sh
#!/bin/bash
set -e

cd /var/www

echo "Attente de la base de données..."
MAX_TRIES=30
COUNTER=0

until mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" -e "SELECT 1;" > /dev/null 2>&1; do
    COUNTER=$((COUNTER+1))
    if [ $COUNTER -gt $MAX_TRIES ]; then
        echo "Impossible de se connecter à MySQL après $MAX_TRIES tentatives."
        exit 1
    fi
    echo "Tentative $COUNTER/$MAX_TRIES - Attente de la base de données..."
    sleep 10
done

echo "Base de données disponible, configuration de l'application..."

# Configuration de l'application
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Exécution des migrations..."
php artisan migrate --force

echo "Démarrage d'Apache..."
apache2-foreground