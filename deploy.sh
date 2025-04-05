#!/bin/sh

# Navigate to repo if not already there
cd "$(dirname "$0")"

# Reset and pull latest code
git reset --hard HEAD
git clean -fd
git pull origin dev

# Rebuild containers
echo "Stopping old containers..."
docker-compose down

echo "Deploying the Docker container..."
docker-compose up -d --build
