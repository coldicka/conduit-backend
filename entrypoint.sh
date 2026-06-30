#!/bin/sh
set -e

# collect static files
echo "collect static files..."
python manage.py collectstatic --noinput

# database migrations
echo "apply database migrations..."
python manage.py migrations  || { echo "Makemigrations failed"; exit 1; }
python manage.py migrate  || { echo "Migration failed"; exit 1; }

echo "Creating superuser..."

# Create new superuser
python manage.py createsuperuser --noinput \
  --email "$DJANGO_SUPERUSER_EMAIL" \
  --username "$DJANGO_SUPERUSER_USERNAME"
###

# Check if gunicorn is installed
if [! command -v gunicorn &> /dev/null]; then
    echo "Gunicorn could not be found, installing it."
    pip install --user gunicorn
fi

# Start Django Server with gunicorn
echo "Starting Django Server with gunicorn..."
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:8000