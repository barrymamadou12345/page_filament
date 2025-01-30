#!/usr/bin/env bash

set -e

MAX_TRIES=30
COUNTER=0

echo "Vérification de la connexion à MySQL..."
until mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e 'SELECT 1;' > /dev/null 2>&1; do
    COUNTER=$((COUNTER+1))
    if [ $COUNTER -gt $MAX_TRIES ]; then
        echo "Impossible de se connecter à MySQL après $MAX_TRIES tentatives. Arrêt."
        exit 1
    fi
    echo "MySQL n'est pas encore disponible - tentative $COUNTER sur $MAX_TRIES..."
    sleep 10
done

echo "MySQL est disponible !"
exit 0
