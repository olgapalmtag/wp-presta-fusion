#!/bin/bash
echo "⏳ Warte auf Datenbankverbindung zu $DB_SERVER ..."
until mysqladmin ping -h"$DB_SERVER" --silent; do
  sleep 2
done
echo "✅ Datenbank ist erreichbar. Starte PrestaShop..."
docker-php-entrypoint apache2-foreground
