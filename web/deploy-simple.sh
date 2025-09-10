#!/bin/bash

# 간단한 배포 스크립트
# 사용법: ./deploy-simple.sh [image-tag]

IMAGE_TAG=${1:-latest}
IMAGE_NAME="qkfka9045/fdc-dust-web-app"

echo "🚀 Deploying image: ${IMAGE_NAME}:${IMAGE_TAG}"

# 방법 1: kubectl set image (가장 간단)
kubectl set image deployment/fdc-dust-web-app fdc-dust-web-app=${IMAGE_NAME}:${IMAGE_TAG} --record
kubectl rollout status deployment/fdc-dust-web-app

echo "✅ Deployment completed!"

# 방법 2: Kustomize 사용 (대안)
# kubectl kustomize . --images=${IMAGE_NAME}:${IMAGE_TAG} | kubectl apply -f -

# 방법 3: sed로 파일 수정 후 적용 (대안)
# sed -i "s|image: .*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g" deployment.yaml
# kubectl apply -f deployment.yaml
