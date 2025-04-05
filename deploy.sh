#!/bin/sh

# Navigate to repo if not already there
cd "$(dirname "$0")"

# Reset and pull latest code
git reset --hard HEAD
git clean -fd
git pull origin dev

# Stop old containers
echo "Stopping old containers..."
docker-compose down

# Free up port 80 if needed
echo "Freeing up port 80 if occupied..."
sudo fuser -k 80/tcp || true

# Deploy new containers
echo "Deploying the Docker container..."
docker-compose up -d --build
