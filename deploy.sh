#!/bin/sh

# Deploy new containers
echo "Deploying the Docker container..."
docker-compose up -d --build
