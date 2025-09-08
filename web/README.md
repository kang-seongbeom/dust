# Dust Web Application

Spring Boot 3.3.4와 Java 21을 사용한 단순한 JSP 기반 웹 애플리케이션입니다.

## 기술 스택

- **Java**: 21 (LTS) - Amazon Corretto
- **Spring Boot**: 3.3.4
- **View Technology**: JSP + JSTL
- **Build Tool**: Maven
- **Container**: Docker (Amazon Corretto 21 Alpine)

## 프로젝트 구조

```
dust/web/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/
│   │   │       ├── DustWebApplication.java
│   │   │       └── controller/
│   │   │           └── HomeController.java
│   │   ├── resources/
│   │   │   └── application.properties
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── views/
│   │               └── home.jsp
├── pom.xml
├── Dockerfile
├── mvnw
└── README.md
```

## 기능

- **홈페이지**: 백엔드에서 전달받은 환영 메시지와 현재 시간 표시
- **단순한 구조**: 하나의 컨트롤러와 하나의 JSP 페이지로 구성

## 로컬 실행 방법

### 1. Java 21 설치 확인

```bash
java -version
```

### 2. Maven을 사용한 실행

```bash
# 의존성 다운로드 및 빌드
./mvnw clean package

# 애플리케이션 실행
./mvnw spring-boot:run
```

### 3. JAR 파일로 실행

```bash
# JAR 파일 빌드
./mvnw clean package

# JAR 파일 실행
java -jar target/dust-web-app-1.0.0.jar
```

애플리케이션이 실행되면 `http://localhost:8080`에서 접근할 수 있습니다.

## 화면 구성

애플리케이션을 실행하면 다음과 같은 내용이 표시됩니다:

- **제목**: "Dust Web Application"
- **환영 메시지**: "Welcome to Spring Boot with JSP!"
- **현재 시간**: 실시간으로 업데이트되는 현재 시간
- **기술 스택 정보**: Spring Boot 3.3.4 | Java 21 (Amazon Corretto) | JSP | Maven

## Docker를 사용한 실행

### 1. Docker 이미지 빌드

```bash
docker build -t dust-web-app .
```

### 2. Docker 컨테이너 실행

```bash
docker run -p 8080:8080 dust-web-app
```

### 3. Docker Compose 사용 (선택사항)

`docker-compose.yml` 파일을 생성하여 실행할 수도 있습니다:

```yaml
version: '3.8'
services:
  dust-web-app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
```

## API 엔드포인트

- `GET /` - 홈페이지 (환영 메시지와 현재 시간 표시)

## 개발 환경 설정

### IntelliJ IDEA

1. 프로젝트를 IntelliJ IDEA로 열기
2. Maven 프로젝트로 인식되도록 설정
3. Java 21 SDK 설정
4. Spring Boot 플러그인 활성화

### Eclipse

1. File → Import → Existing Maven Projects
2. 프로젝트 디렉토리 선택
3. Java 21 JRE 설정

## 문제 해결

### Java 21 관련 문제

Java 21이 설치되지 않은 경우, 다음 중 하나를 선택하세요:

1. **Amazon Corretto 21 설치**: [Amazon Corretto 공식 사이트](https://aws.amazon.com/corretto/)
2. **OpenJDK 21 설치**: [OpenJDK 공식 사이트](https://openjdk.org/)
3. **pom.xml 수정**: Java 버전을 17로 변경

### JSP 관련 문제

JSP가 제대로 렌더링되지 않는 경우:

1. `application.properties`에서 JSP 설정 확인
2. `pom.xml`에서 JSP 관련 의존성 확인
3. `src/main/webapp` 디렉토리 구조 확인

### Docker 관련 문제

Docker 빌드가 실패하는 경우:

1. Docker가 실행 중인지 확인
2. Amazon Corretto 21 이미지가 사용 가능한지 확인
3. 네트워크 연결 상태 확인
4. Alpine Linux 패키지 업데이트 확인

#### 줄바꿈 문자 오류 (CRLF/LF 문제)

Windows에서 WSL로 Docker 빌드 시 다음과 같은 오류가 발생할 수 있습니다:
```
/bin/sh: ./mvnw: /bin/sh^M: bad interpreter: No such file or directory
```

**해결 방법:**
- Dockerfile에서 `sed -i 's/\r$//' mvnw` 명령어로 자동 변환
- 또는 Git에서 `.gitattributes` 파일로 줄바꿈 문자 자동 변환 설정

## 라이선스

이 프로젝트는 Apache License 2.0 하에 배포됩니다.
