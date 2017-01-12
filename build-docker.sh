#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: ./build-docker.sh name tag"
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "Usage: ./build-docker.sh name tag"
    exit 1
fi

echo "Starting build..."
docker build -t "$1":"$2" .

echo "✋  Will push in 5 seconds. ^C to abort."
sleep 5
echo "tagging image"

echo "🚀  pushing image"
docker push "$1:$2"
