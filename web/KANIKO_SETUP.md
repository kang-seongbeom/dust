# Kaniko를 사용한 Jenkins CI/CD 설정 가이드

## 개요
이 가이드는 `dust/web` Spring Boot 애플리케이션을 Kaniko를 사용하여 Docker 이미지로 빌드하고 레지스트리에 푸시하는 Jenkins 파이프라인 설정 방법을 설명합니다.

## 사전 요구사항
- Kubernetes 클러스터
- Jenkins (Kubernetes 플러그인 설치됨)
- Docker 레지스트리 (Docker Hub, AWS ECR, GCR 등)

## 설정 단계

### 1. Docker 레지스트리 인증 설정

#### Docker Hub 사용 시:
```bash
# Docker Hub 계정 정보로 base64 인코딩
echo -n "username:password" | base64
```

#### AWS ECR 사용 시:
```bash
# AWS CLI로 ECR 로그인 토큰 생성
aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com
```

### 2. Kubernetes 리소스 배포

```bash
# 1. kaniko-setup.yaml 파일 수정
# - DOCKER_REGISTRY를 실제 레지스트리 주소로 변경
# - docker-config ConfigMap에 실제 인증 정보 추가

# 2. 리소스 배포
kubectl apply -f kaniko-setup.yaml

# 3. 배포 확인
kubectl get serviceaccount jenkins-kaniko
kubectl get configmap docker-config
kubectl get secret kaniko-secret
```

### 3. Jenkinsfile 설정 수정

Jenkinsfile에서 다음 환경 변수들을 수정하세요:

```groovy
environment {
    DOCKER_REGISTRY = 'your-registry.com'  // 실제 레지스트리 주소
    DOCKER_REPOSITORY = 'dust-web-app'     // 저장소 이름
    // ... 기타 설정
}
```

### 4. Jenkins 파이프라인 생성

1. Jenkins 웹 인터페이스 접속
2. "New Item" → "Pipeline" 선택
3. Pipeline 설정에서 "Pipeline script from SCM" 선택
4. Git 저장소 URL 입력
5. Script Path를 `dust/web/Jenkinsfile`로 설정

## 빌드 프로세스

### 단계별 설명:
1. **Checkout**: 소스 코드 체크아웃
2. **Maven Build**: Maven을 사용한 컴파일 및 테스트
3. **Build Docker Image**: Kaniko를 사용한 Docker 이미지 빌드
4. **Security Scan**: Trivy를 사용한 보안 스캔 (선택사항)

### Kaniko 빌드 옵션:
- `--cache=true`: 빌드 캐시 사용
- `--cache-ttl=24h`: 캐시 TTL 24시간
- `--compressed-caching=false`: 압축 캐시 비활성화
- `--single-snapshot`: 단일 스냅샷 모드
- `--cleanup`: 빌드 후 정리

## 보안 고려사항

### 1. 권한 최소화
- ServiceAccount는 필요한 최소 권한만 부여
- Secret과 ConfigMap은 적절한 네임스페이스에 배치

### 2. 이미지 보안
- 베이스 이미지는 신뢰할 수 있는 소스 사용
- 정기적인 보안 스캔 수행
- Non-root 사용자로 실행

### 3. 네트워크 보안
- 프라이빗 레지스트리 사용 권장
- TLS 인증서 사용

## 트러블슈팅

### 일반적인 문제들:

1. **인증 실패**
   ```
   Error: failed to push to registry
   ```
   - Docker 레지스트리 인증 정보 확인
   - Secret과 ConfigMap의 base64 인코딩 확인

2. **권한 부족**
   ```
   Error: pods is forbidden
   ```
   - ServiceAccount 권한 확인
   - ClusterRoleBinding 확인

3. **빌드 실패**
   ```
   Error: failed to build image
   ```
   - Dockerfile 문법 확인
   - 빌드 컨텍스트 경로 확인

## 모니터링

### 빌드 로그 확인:
```bash
kubectl logs -f <jenkins-pod-name> -c kaniko
```

### 이미지 확인:
```bash
docker pull your-registry.com/dust-web-app:latest
```

## 추가 최적화

### 1. 멀티스테이지 빌드 최적화
- Maven 의존성 캐싱
- 불필요한 레이어 제거

### 2. 빌드 캐시 활용
- Kaniko 캐시 설정
- Maven 로컬 저장소 캐싱

### 3. 병렬 빌드
- 여러 환경에 대한 병렬 빌드
- 테스트와 빌드의 병렬 실행
