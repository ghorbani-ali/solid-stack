#!/bin/bash

IMAGE_NAME="ghorbaniali/solid-stack-app"
IMAGE_TAG="latest"

docker build -t $IMAGE_NAME:$IMAGE_NAME -f Dockerfile ./src/Exchange