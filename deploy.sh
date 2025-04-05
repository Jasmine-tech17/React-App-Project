#!/bin/sh

# Navigate to repo if not already there
cd "$(dirname "$0")"

# Clean workspace
git reset --hard HEAD
git clean -fd

# Stop old containers
echo "Stopping old containers..."
docker-compose down

# Free up ports
PORTS="80 9090 9093"

echo "Freeing up required ports..."
for PORT in $PORTS; do
  PID=$(sudo lsof -t -i:$PORT)
  if [ -n "$PID" ]; then
    echo "Killing process on port $PORT (PID: $PID)"
    sudo kill -9 $PID
  else
    echo "Port $PORT is not occupied"
  fi
done


# Deploy new containers
echo "Deploying the Docker container..."
docker-compose up -d --build
