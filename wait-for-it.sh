#!/usr/bin/env bash
#   Use this script to test if a given MySQL host/port are available

set -e

host="$1"
shift
cmd="$@"

until mysql -h "$host" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e 'select 1'; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - executing command"
exec $cmd
