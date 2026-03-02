#!/usr/bin/env bash
set -e

# -------- DETECT TAG FROM CI --------
if [ ! -z "$BUILD_NUMBER" ]; then
    TAG=$BUILD_NUMBER
elif [ ! -z "$GITHUB_RUN_NUMBER" ]; then
    TAG=$GITHUB_RUN_NUMBER
else
    echo "ERROR: No build number found! Set BUILD_NUMBER or GITHUB_RUN_NUMBER"
    exit 1
fi

DOCKER_USER="prav1619"

echo "Using TAG: $TAG"

# ---------- FUNCTION ----------
build_and_push() {
    SERVICE_NAME=$1
    SERVICE_PATH=$2

    echo "------ Building $SERVICE_NAME:$TAG ------"
    docker build -t $DOCKER_USER/$SERVICE_NAME:$TAG $SERVICE_PATH

    echo "------ Pushing $SERVICE_NAME:$TAG to Docker Hub ------"
    docker push $DOCKER_USER/$SERVICE_NAME:$TAG
}

# ---------- MAIN ----------
build_and_push "quickart-user-service" "./user-service"
build_and_push "quickart-product-service" "./product-service"
build_and_push "quickart-order-service" "./order-service"

echo "==== All images built & pushed successfully with TAG $TAG ===="
