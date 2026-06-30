#!/bin/sh
set -e

# database migrations
echo "apply database migrations..."
python manage.py makemigrations  || { echo "Makemigrations failed"; exit 1; }
python manage.py migrate  || { echo "Migration failed"; exit 1; }

# collect static files
echo "collect static files..."
python manage.py collectstatic --noinput

echo "Creating superuser..."

if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_EMAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    # Create new superuser
    python manage.py createsuperuser --no-input || true
fi

# Start Django Server with gunicorn
echo "Starting Django Server with gunicorn..."
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:${BACKEND_PORT}