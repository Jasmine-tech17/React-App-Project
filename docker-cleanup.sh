#!/bin/bash

echo "Stopping all running containers..."
docker ps -q | xargs -r docker stop

echo "Removing all containers..."
docker ps -aq | xargs -r docker rm

echo "Pruning all unused Docker data (images, networks, volumes)..."
docker system prune -af --volumes

echo "Restarting Docker service..."
sudo systemctl restart docker

echo "Verifying if required ports are free..."

PORTS=(80 9090 9093)
for PORT in "${PORTS[@]}"; do
  if sudo lsof -i :$PORT; then
    echo "Port $PORT is still in use!"
  else
    echo "Port $PORT is free."
  fi
done

echo "Docker cleanup completed successfully."
