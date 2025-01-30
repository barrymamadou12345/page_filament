# wait-for-it.sh
#!/usr/bin/env bash
# Script pour attendre que MySQL soit disponible

set -e

echo "Vérification de la connexion à MySQL..."
until mysql -h "$DB_HOST" -P "${DB_PORT:-3306}" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e 'SELECT 1;' > /dev/null 2>&1; do
  echo "MySQL n'est pas encore disponible - nouvelle tentative dans 5 secondes..."
  sleep 5
done

echo "MySQL est disponible !"
exit 0
