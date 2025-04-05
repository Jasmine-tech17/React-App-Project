#!/bin/sh
echo "Stopping old containers..."
docker-compose down

echo "Deploying the Docker container..."
docker-compose up -d --build
