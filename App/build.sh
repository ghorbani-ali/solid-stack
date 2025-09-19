#!/bin/bash

IMAGE_NAME="crypto"
IMAGE_TAG="latest"

docker build -t $IMAGE_NAME:$IMAGE_NAME -f Dockerfile ./src/Exchange