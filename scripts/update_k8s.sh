#!/usr/bin/env bash
set -e

# ---- Detect TAG from CI ----
if [ ! -z "$BUILD_NUMBER" ]; then
    TAG=$BUILD_NUMBER
elif [ ! -z "$GITHUB_RUN_NUMBER" ]; then
    TAG=$GITHUB_RUN_NUMBER
else
    echo "ERROR: No build number found!"
    exit 1
fi

DOCKER_USER="prav1619"

echo "Deploying images with TAG: $TAG"

# ---------- APPLY NAMESPACE ----------
kubectl apply -f k8s/namespace.yaml

# ---------- APPLY CONFIGS ----------
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml

# ---------- APPLY BASE K8S MANIFESTS ----------
kubectl apply -f k8s/user-deployment.yaml
kubectl apply -f k8s/user-service.yaml

kubectl apply -f k8s/product-deployment.yaml
kubectl apply -f k8s/product-service.yaml

kubectl apply -f k8s/order-deployment.yaml
kubectl apply -f k8s/order-service.yaml

kubectl apply -f k8s/ingress.yaml

# ---------- UPDATE IMAGES WITH NEW TAG ----------
kubectl set image deployment/user-service \
  user-service=$DOCKER_USER/quickart-user-service:$TAG -n quickart

kubectl set image deployment/product-service \
  product-service=$DOCKER_USER/quickart-product-service:$TAG -n quickart

kubectl set image deployment/order-service \
  order-service=$DOCKER_USER/quickart-order-service:$TAG -n quickart

echo "==== Waiting for deployment rollouts ===="

kubectl rollout status deployment/user-service -n quickart
kubectl rollout status deployment/product-service -n quickart
kubectl rollout status deployment/order-service -n quickart

echo "==== Kubernetes updated successfully with TAG $TAG ===="
