# FDC Dust Web App - Kubernetes Deployment

이 디렉토리는 Docker Hub에서 빌드된 `fdc-dust-web-app` 이미지를 Kubernetes에 배포하기 위한 파일들을 포함합니다.

## 디렉토리 구조

```
ci/
├── deployment.yaml              # 기본 Kubernetes 리소스
├── kustomization.yaml          # 기본 Kustomize 설정
├── overlay/
│   ├── production/
│   │   ├── kustomization.yaml  # 프로덕션 환경 설정
│   │   └── production-patch.yaml
│   └── staging/
│       ├── kustomization.yaml  # 스테이징 환경 설정
│       └── staging-patch.yaml
└── README.md
```

## 배포 방법

### 1. 기본 배포 (Development)
```bash
# 기본 설정으로 배포
kubectl apply -k .

# 또는 Kustomize 사용
kubectl kustomize . | kubectl apply -f -
```

### 2. 스테이징 환경 배포
```bash
# 스테이징 환경으로 배포
kubectl apply -k overlay/staging/

# 또는 Kustomize 사용
kubectl kustomize overlay/staging/ | kubectl apply -f -
```

### 3. 프로덕션 환경 배포
```bash
# 프로덕션 환경으로 배포
kubectl apply -k overlay/production/

# 또는 Kustomize 사용
kubectl kustomize overlay/production/ | kubectl apply -f -
```

## 환경별 설정

### Development (기본)
- **Replicas**: 2
- **Resources**: 512Mi/250m (requests), 1Gi/500m (limits)
- **Service Type**: ClusterIP
- **Ingress**: fdc-dust-web-app.local

### Staging
- **Replicas**: 1
- **Resources**: 256Mi/100m (requests), 512Mi/250m (limits)
- **Service Type**: ClusterIP
- **Profile**: staging
- **Log Level**: DEBUG

### Production
- **Replicas**: 3
- **Resources**: 1Gi/500m (requests), 2Gi/1000m (limits)
- **Service Type**: LoadBalancer
- **Profile**: production
- **Log Level**: INFO

## 이미지 업데이트

### 특정 태그로 배포
```bash
# 특정 빌드 번호로 배포
kubectl set image deployment/fdc-dust-web-app fdc-dust-web-app=qkfka9045/fdc-dust-web-app:15

# 또는 Kustomize로 이미지 태그 변경
kubectl kustomize . --images=qkfka9045/fdc-dust-web-app:15 | kubectl apply -f -
```

### Kustomization 파일에서 이미지 태그 변경
```yaml
# kustomization.yaml 또는 overlay/*/kustomization.yaml에서
images:
- name: qkfka9045/fdc-dust-web-app
  newTag: "15"  # 원하는 태그로 변경
```

## 헬스 체크

애플리케이션은 Spring Boot Actuator를 사용하여 헬스 체크를 제공합니다:

- **Liveness Probe**: `/actuator/health`
- **Readiness Probe**: `/actuator/health/readiness`

## 보안 설정

- **Non-root User**: 컨테이너는 UID 1000으로 실행
- **Read-only Root Filesystem**: 보안을 위해 활성화
- **Capabilities**: 모든 권한 제거

## 모니터링

### 로그 확인
```bash
# Pod 로그 확인
kubectl logs -f deployment/fdc-dust-web-app

# 특정 환경의 로그 확인
kubectl logs -f deployment/fdc-dust-web-app -n staging
kubectl logs -f deployment/fdc-dust-web-app -n production
```

### 상태 확인
```bash
# Deployment 상태 확인
kubectl get deployment fdc-dust-web-app

# Pod 상태 확인
kubectl get pods -l app=fdc-dust-web-app

# Service 확인
kubectl get service fdc-dust-web-app-service
```

## 트러블슈팅

### 일반적인 문제들:

1. **이미지 Pull 실패**
   ```bash
   # 이미지가 존재하는지 확인
   docker pull qkfka9045/fdc-dust-web-app:latest
   ```

2. **헬스 체크 실패**
   ```bash
   # Pod 로그 확인
   kubectl logs deployment/fdc-dust-web-app
   
   # 헬스 체크 엔드포인트 확인
   kubectl port-forward deployment/fdc-dust-web-app 8080:8080
   curl http://localhost:8080/actuator/health
   ```

3. **리소스 부족**
   ```bash
   # 노드 리소스 확인
   kubectl describe nodes
   
   # Pod 이벤트 확인
   kubectl describe pod <pod-name>
   ```

## CI/CD 통합

Jenkins 파이프라인에서 자동 배포:

```groovy
stage('Deploy to Staging') {
    steps {
        sh """
        kubectl apply -k ci/overlay/staging/
        kubectl rollout status deployment/fdc-dust-web-app -n staging
        """
    }
}

stage('Deploy to Production') {
    when {
        branch 'main'
    }
    steps {
        sh """
        kubectl apply -k ci/overlay/production/
        kubectl rollout status deployment/fdc-dust-web-app -n production
        """
    }
}
```
