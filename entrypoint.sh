#!/bin/bash
set -e

# Default PORT to 8080 for local Docker (Railway sets this automatically)
export PORT=${PORT:-8080}

echo "Starting on port $PORT..."

echo "Fixing permissions..."
chmod -R 777 /var/www/html/var
chown -R www-data:www-data /var/www/html/var

echo "Installing JS assets..."
php bin/console importmap:install

echo "Clearing and warming up Symfony cache..."
php bin/console cache:clear --env=prod --no-debug

echo "Fixing permissions after cache clear..."
chmod -R 777 /var/www/html/var
chown -R www-data:www-data /var/www/html/var

echo "Running database migrations..."
php bin/console doctrine:migrations:migrate --no-interaction --env=prod

echo "Starting PHP-FPM..."
php-fpm -D

echo "Configuring Nginx port ($PORT)..."
envsubst '${PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

echo "Starting Nginx..."
exec nginx -g "daemon off;"