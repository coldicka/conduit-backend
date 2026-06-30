# Use Python 3.11 slim image as the base
FROM python:3.11-slim

# Prevents Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Prevents Python from buffering stdout/stderr (important for real-time logs in Docker)
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Run the following command to install system dependencies required for building Python packages and running the application.
# Copy the requirements.txt file into the container.
COPY requirements.txt ${WORKDIR}

# install the Python dependencies listed in the container.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY . ${WORKDIR}

RUN useradd -m -r appuser && chown -R appuser:appuser /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown appuser:appuser /entrypoint.sh

USER appuser

# Expose port 8000 to access the backend application. This is the port that the application will listen on inside the container.
EXPOSE 8000

# Make entrypoint.sh executable
RUN chmod +x entrypoint.sh

# Set the entrypoint script to be executed when the container starts. This script will handle any necessary setup before starting the application.
ENTRYPOINT ["sh", "entrypoint.sh"]