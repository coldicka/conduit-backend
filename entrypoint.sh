#!/bin/sh
set -e

echo "Warte auf die Datenbank..."
sleep 3

# database migrations
echo "apply database migrations..."
# python manage.py makemigrations  || { echo "Makemigrations failed"; exit 1; }
python manage.py migrate  || { echo "Migration failed"; exit 1; }

# collect static files
echo "collect static files..."
python manage.py collectstatic --noinput

echo "Creating superuser..."

if [ -n "$DJANGO_SUPERUSER_USERNAME" ]; then
    python manage.py createsuperuser --no-input --username "$DJANGO_SUPERUSER_USERNAME" --email "$DJANGO_SUPERUSER_EMAIL" || true
fi

# Start Django Server with gunicorn
echo "Starting Django Server with gunicorn..."
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:${BACKEND_PORT}