# Jenkins SSH Agent 설정 가이드

## 1. SSH 키 생성

### Jenkins 서버에서 SSH 키 생성
```bash
# Jenkins 사용자로 SSH 키 생성
sudo -u jenkins ssh-keygen -t rsa -b 4096 -C "jenkins@your-domain.com"

# 키 파일 위치 확인
ls -la /var/lib/jenkins/.ssh/
```

### 또는 수동으로 키 생성
```bash
# SSH 키 생성
ssh-keygen -t rsa -b 4096 -f ~/.ssh/jenkins_git_key

# 공개키 확인
cat ~/.ssh/jenkins_git_key.pub
```

## 2. Git 서버에 SSH 키 등록

### GitHub
1. GitHub 로그인
2. Settings → SSH and GPG keys
3. New SSH key 클릭
4. Title: `Jenkins CI`
5. Key: 공개키 내용 붙여넣기
6. Add SSH key 클릭

### GitLab
1. GitLab 로그인
2. User Settings → SSH Keys
3. Key: 공개키 내용 붙여넣기
4. Title: `Jenkins CI`
5. Add key 클릭

### 기타 Git 서버
- SSH 공개키를 해당 Git 서버의 사용자 계정에 등록

## 3. Jenkins에서 SSH Credential 설정

### 방법 1: Jenkins 웹 UI 사용
1. Jenkins 관리 → Manage Credentials
2. (global) 클릭
3. Add Credentials 클릭
4. Kind: `SSH Username with private key` 선택
5. ID: `jenkins-git-ssh-key`
6. Username: Git 사용자명
7. Private Key: `Enter directly` 선택 후 개인키 붙여넣기
8. Save 클릭

### 방법 2: Jenkins CLI 사용
```bash
# Jenkins CLI로 credential 추가
java -jar jenkins-cli.jar -s http://jenkins-url/ create-credentials-by-xml system::system::jenkins _ < credential.xml
```

### credential.xml 예시:
```xml
<com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey>
  <id>jenkins-git-ssh-key</id>
  <description>Jenkins Git SSH Key</description>
  <username>git</username>
  <privateKeySource class="com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey$DirectEntryPrivateKeySource">
    <privateKey>-----BEGIN OPENSSH PRIVATE KEY-----
    [여기에 개인키 내용]
    -----END OPENSSH PRIVATE KEY-----</privateKey>
  </privateKeySource>
</com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey>
```

## 4. SSH 연결 테스트

### Jenkins 서버에서 테스트
```bash
# SSH 연결 테스트
ssh -T git@github.com
# 또는
ssh -T git@gitlab.com

# 성공 메시지 예시:
# Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

### Jenkins Pipeline에서 테스트
```groovy
stage('Test SSH Connection') {
    steps {
        sshagent(['jenkins-git-ssh-key']) {
            sh 'ssh -T git@github.com'
        }
    }
}
```

## 5. 필요한 Jenkins 플러그인

### SSH Agent Plugin 설치
1. Jenkins 관리 → Manage Plugins
2. Available 탭에서 "SSH Agent" 검색
3. 설치 후 Jenkins 재시작

### 또는 명령어로 설치
```bash
# Jenkins CLI로 플러그인 설치
java -jar jenkins-cli.jar -s http://jenkins-url/ install-plugin ssh-agent
```

## 6. 권한 설정

### Git 저장소 권한
- Jenkins가 사용하는 SSH 키에 해당 저장소에 대한 **Write** 권한이 있어야 함
- GitHub: Repository Settings → Manage access → Add people
- GitLab: Project Settings → Members → Invite members

### Jenkins 사용자 권한
```bash
# Jenkins 사용자가 Git 명령어를 실행할 수 있도록 설정
sudo -u jenkins git config --global user.name "Jenkins CI"
sudo -u jenkins git config --global user.email "jenkins@your-domain.com"
```

## 7. 트러블슈팅

### 일반적인 문제들:

#### 1. **SSH 키 인증 실패**
```
Permission denied (publickey)
```
**해결방법:**
- SSH 키가 올바르게 등록되었는지 확인
- 개인키 형식이 올바른지 확인
- Git 서버의 SSH 키 목록 확인

#### 2. **Git push 권한 없음**
```
remote: Permission to user/repo.git denied to jenkins
```
**해결방법:**
- 저장소에 Write 권한이 있는지 확인
- SSH 키가 올바른 사용자 계정에 등록되었는지 확인

#### 3. **SSH Agent Plugin 오류**
```
SSH Agent Plugin not found
```
**해결방법:**
- SSH Agent Plugin 설치
- Jenkins 재시작

#### 4. **Git 명령어를 찾을 수 없음**
```
git: command not found
```
**해결방법:**
```bash
# Git 설치
sudo apt-get install git  # Ubuntu/Debian
sudo yum install git      # CentOS/RHEL

# Jenkins에서 Git 경로 확인
which git
```

## 8. 보안 고려사항

### SSH 키 관리
- 정기적으로 SSH 키 로테이션
- 개인키는 안전하게 보관
- 공개키만 Git 서버에 등록

### 권한 최소화
- Jenkins가 필요한 최소한의 저장소 권한만 부여
- 필요시 별도의 Git 사용자 계정 생성

### 로그 관리
- Git 작업 로그 모니터링
- 비정상적인 Git 활동 감지

## 9. 자동화 스크립트

### SSH 키 설정 자동화
```bash
#!/bin/bash
# setup-jenkins-ssh.sh

# SSH 키 생성
sudo -u jenkins ssh-keygen -t rsa -b 4096 -f /var/lib/jenkins/.ssh/jenkins_git_key -N ""

# 공개키 출력
echo "=== SSH Public Key ==="
cat /var/lib/jenkins/.ssh/jenkins_git_key.pub
echo "======================"

# Git 설정
sudo -u jenkins git config --global user.name "Jenkins CI"
sudo -u jenkins git config --global user.email "jenkins@your-domain.com"

echo "SSH 키가 생성되었습니다. 위의 공개키를 Git 서버에 등록하세요."
```

이제 Jenkins에서 SSH agent를 사용하여 Git 작업을 수행할 수 있습니다!
