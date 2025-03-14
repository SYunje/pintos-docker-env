# Pintos Docker Development Environment
This repository provides a Docker-based environment for Pintos operating system development on Ubuntu 24.04.

## Prerequisites
### 1. Update System Packages
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Docker Installation
```bash
# Update package index
sudo apt update
# Install Docker
sudo apt install docker.io -y
# Enable Docker to start on boot
sudo systemctl enable --now docker
# Add current user to docker group
sudo usermod -aG docker $USER
# Ensure Docker service is enabled
sudo systemctl enable docker
# Verify Docker version
docker --version
```

### 3. Firewall Configuration (UFW)
```bash
# Allow port 5555
sudo ufw allow 5555/tcp
# Check firewall status
sudo ufw status
```

### 4. Log Out and Log Back In
```bash
exit  # Log out
# Log back in to apply group changes
```

## Project Setup
### 5. Clone the Repository
```bash
git clone https://github.com/SYunje/pintos-docker-env.git
cd pintos-docker-env
```

### 6. Build Docker Image
```bash
docker build -t pintos-docker-env .
```

### 7. Run the Container
```bash
docker run -d --restart always -p 5555:22 --name pintos-container pintos-docker-env
```

## Container Access
### 8. SSH Connection
```bash
ssh user@<host_IP> -p 5555
```
- **User Password:** ihatepintos
- **Root Password:** vlsxhtmtlfgdjdy12!@

## Pintos Test Execution
### Test Execution Method
```bash
# Navigate to Pintos threads directory
cd ~/pintos/src/threads/build
# Run alarm-multiple test
pintos --qemu -- run alarm-multiple
```

### Test Execution Example
When the test runs successfully, you will see output similar to:
<img width="575" alt="Pintos Alarm Multiple Test Output" src="https://github.com/user-attachments/assets/61670ff7-6dce-41ce-a5a4-fd6559cf8050" />

### Exploring Key Directories
```bash
# Pintos threads source directory
cd ~/pintos/src/threads
# Build directory
cd ~/pintos/src/threads/build
# Check available tests
ls tests
```

### Additional Test Execution Examples
```bash
# Run other tests
pintos --qemu -- run <test-name>
# Some example tests
# pintos --qemu -- run alarm-single
# pintos --qemu -- run priority-change
# pintos --qemu -- run priority-preempt
```

## Additional Information
- Pintos is an educational operating system project
- Tests cover various OS concepts including threads, synchronization, and scheduling
- Each test verifies specific operating system functionalities

## Container Management Commands
### List Containers
```bash
docker ps -a
```

### Stop Container
```bash
docker stop pintos-container
```

### Start Container
```bash
docker start pintos-container
```

### View Container Logs
```bash
docker logs pintos-container
```

## System Cleanup
### Remove Unused Containers
```bash
docker container prune -f
```

### Remove Unused Images
```bash
docker image prune -a -f
```

### Remove Build Cache
```bash
docker builder prune -a -f
```

### Complete System Cleanup
```bash
docker system prune -a -f
```

## Troubleshooting
- Verify log out and log back in after adding user to docker group
- Check Docker service status: `sudo systemctl status docker`
- Verify container running status: `docker ps`

## Compatibility Notes
- **Host System:** Ubuntu 24.04
- **Container Base Image:** Ubuntu 16.04 (for Pintos compatibility)
- Additional configuration may be needed to address potential version conflicts

## Additional Test Commands
```bash
# List available Pintos tests
ls ~/pintos/src/threads/build
# Run other tests
pintos --qemu -- run <test-name>
```


## Acknowledgments

This project was created with reference to the lecture slides of Professor Dae-Young Heo's Operating Systems course at Kookmin University.


----------------------------------------------------------------------------------------------------------------


# Pintos Docker 개발 환경

이 저장소는 Ubuntu 24.04에서 Pintos 운영 체제 개발을 위한 Docker 기반 환경을 제공합니다.

## 사전 준비

### 1. 시스템 패키지 업데이트
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Docker 설치
```bash
# 패키지 인덱스 업데이트
sudo apt update

# Docker 설치
sudo apt install docker.io -y

# 부팅 시 Docker 자동 실행 설정
sudo systemctl enable --now docker

# 현재 사용자를 docker 그룹에 추가
sudo usermod -aG docker $USER

# Docker 서비스 활성화 확인
sudo systemctl enable docker

# Docker 버전 확인
docker --version
```

### 3. 방화벽 설정 (UFW)
```bash
# 5555 포트 허용
sudo ufw allow 5555/tcp

# 방화벽 상태 확인
sudo ufw status
```

### 4. 로그아웃 및 재로그인
```bash
exit  # 로그아웃
# 다시 로그인하여 그룹 변경 적용
```

## 프로젝트 설정

### 5. 저장소 복제
```bash
git clone https://github.com/SYunje/pintos-docker-env.git
cd pintos-docker-env
```

### 6. Docker 이미지 빌드
```bash
docker build -t pintos-docker-env .
```

### 7. 컨테이너 실행
```bash
docker run -d --restart always -p 5555:22 --name pintos-container pintos-docker-env
```

## 컨테이너 접속

### 8. SSH 접속
```bash
ssh user@<호스트_IP> -p 5555
```
- **사용자 비밀번호:** ihatepintos
- **루트 비밀번호:** vlsxhtmtlfgdjdy12!@

## Pintos 테스트 실행

### 테스트 실행 방법
```bash
# Pintos 스레드 디렉토리로 이동
cd ~/pintos/src/threads/build

# alarm-multiple 테스트 실행
pintos --qemu -- run alarm-multiple
```

### 테스트 실행 예시
성공적인 테스트 실행 시 다음과 같은 출력을 볼 수 있습니다:
```
qemu -hda /tmp/8OpMSGMkD2.dsk -m 4 -net none -nographic -monitor null
PiLo hda1
Loading........
Kernel command line: run alarm-multiple
Pintos booting with 3,968 kB RAM...
...
(alarm-multiple) begin
(alarm-multiple) Creating 5 threads to sleep 7 times each.
...
(alarm-multiple) end
Execution of 'alarm-multiple' complete.
```

### 주요 디렉토리 탐색
```bash
# Pintos 스레드 소스 디렉토리
cd ~/pintos/src/threads

# 빌드 디렉토리
cd ~/pintos/src/threads/build

# 사용 가능한 테스트 확인
ls tests
```

### 추가 테스트 실행 예시
```bash
# 다른 테스트 실행 방법
pintos --qemu -- run <테스트-이름>

# 몇 가지 예시 테스트
# pintos --qemu -- run alarm-single
# pintos --qemu -- run priority-change
# pintos --qemu -- run priority-preempt
```

## 추가 정보
- Pintos는 교육용 운영 체제 프로젝트입니다.
- 테스트는 스레드, 동기화, 스케줄링 등 다양한 운영 체제 개념을 다룹니다.
- 각 테스트는 특정 운영 체제 기능을 검증합니다.



## 컨테이너 관리 명령어

### 컨테이너 목록
```bash
docker ps -a
```

### 컨테이너 중지
```bash
docker stop pintos-container
```

### 컨테이너 시작
```bash
docker start pintos-container
```

### 컨테이너 로그 보기
```bash
docker logs pintos-container
```

## 시스템 정리

### 사용하지 않는 컨테이너 제거
```bash
docker container prune -f
```

### 사용하지 않는 이미지 제거
```bash
docker image prune -a -f
```

### 빌드 캐시 제거
```bash
docker builder prune -a -f
```

### 전체 시스템 정리
```bash
docker system prune -a -f
```

## 문제 해결

- 사용자를 docker 그룹에 추가한 후 로그아웃 및 재로그인 확인
- Docker 서비스 상태 확인: `sudo systemctl status docker`
- 컨테이너 실행 상태 확인: `docker ps`

## 호환성 참고사항

- **호스트 시스템:** Ubuntu 24.04
- **컨테이너 기본 이미지:** Ubuntu 16.04 (Pintos 호환성을 위해)
- 버전 충돌 가능성에 대비하여 추가 구성이 필요할 수 있습니다.

## 추가 테스트 명령어

```bash
# 사용 가능한 Pintos 테스트 목록
ls ~/pintos/src/threads/build

# 다른 테스트 실행
pintos --qemu -- run <테스트-이름>
```
