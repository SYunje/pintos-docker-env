# Pintos Operating System Project Docker Setup

This repository provides a comprehensive Docker-based setup for developing and running the Pintos operating system project on **Ubuntu 24.04**. Designed for educational purposes, **Pintos** is an open-source instructional operating system that helps students understand core OS concepts through hands-on implementation and practical exercises.

This Docker environment delivers a lightweight educational operating system that simplifies the installation process and guarantees a consistent development environment across various host systems. Students and developers can focus on learning operating system concepts without the burden of complex setup procedures.

## Key Features

- **Ubuntu 16.04 Base Image for Pintos Compatibility**
- **Pre-configured Development Tools:**
  - GCC 4.4 Compiler Setup
  - QEMU for OS Simulation
  - SSH Access for Remote Development
- **Streamlined Build and Test Processes**


## Prerequisites and Setup

### 1. Update System Packages
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Docker Installation on Ubuntu 24.04
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

# Verify Docker installation
docker --version
```

### 3. Firewall Configuration (UFW)
```bash
# Allow incoming connections on port 5555
sudo ufw allow 5555/tcp

# Check the firewall status
sudo ufw status
```

### 4. Log Out and Log Back In
```bash
exit  # Log out
# Log back in to apply group changes
```

### 5. Clone the Repository
```bash
git clone https://github.com/SYunje/pintos-docker-env.git
cd pintos-docker-env
```

### 6. Build the Docker Image
```bash
docker build -t pintos-docker-env .
```

### 7. Run the Container
```bash
docker run -d --restart always -p 5555:22 --name pintos-container pintos-docker-env
```

## Accessing the Container

### SSH Access
```bash
ssh user@<host_ip> -p 5555
```
- **User Password:** ihatepintos
- **Root Password:** vlsxhtmtlfgdjdy12!@

## Pintos Test Compilation

### Build Status
The Dockerfile pre-compiles only the threads project by default. To compile and run other tests, you'll need to manually build them.

### Compiling Additional Tests
```bash
# Navigate to the specific project directory
cd ~/pintos/src/<project_name>


# Fix permission issues by changing the ownership of the entire pintos directory
sudo chown -R $(whoami):$(whoami) ~/pintos

# Build the project
make

# Run a specific test
pintos --qemu -- run <test-name>
```

### Alarm Multiple Test Execution
```bash
# Navigate to the threads build directory
cd ~/pintos/src/threads/build

# Run the alarm-multiple test using QEMU
pintos --qemu -- run alarm-multiple
```

### Test Explanation
The `alarm-multiple` test is designed to verify:
- Thread scheduling mechanisms
- Sleep and alarm functionality
- Concurrent thread execution

#### Key Test Characteristics
- Creates 5 threads
- Each thread sleeps for different durations
- Demonstrates how threads with different sleep times interact
- Validates the operating system's thread management capabilities

## Test Execution Result

<img width="575" alt="Pintos Alarm Multiple Test Output" src="https://github.com/user-attachments/assets/61670ff7-6dce-41ce-a5a4-fd6559cf8050" />

### Test Output Explanation
When the test runs successfully, you will see output similar to:
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

## Container Management Commands

### List Containers
```bash
docker ps -a
```

### Stop the Container
```bash
docker stop pintos-container
```

### Start the Container
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

## Acknowledgments
This project was created with reference to the lecture slides of Professor Dae-Young Heo's Operating Systems course at Kookmin University.


---

# Pintos 운영 체제 프로젝트 Docker 설정

이 저장소는 **Ubuntu 24.04** 환경에서 Pintos 운영 체제 프로젝트를 개발하고 실행하기 위한 포괄적인 Docker 기반 설정을 제공합니다.  
교육용으로 설계된 **Pintos**는 개방형 교육용 운영 체제로, 학생들이 실습과 실제 구현을 통해 핵심 운영 체제 개념을 이해할 수 있도록 돕습니다.

이 Docker 환경은 경량화된 교육용 운영 체제를 제공하여 설치 과정을 간소화하고, 다양한 호스트 시스템에서도 일관된 개발 환경을 보장합니다. 학생과 개발자들은 복잡한 설치 절차에 신경 쓰지 않고 운영 체제 개념에 집중할 수 있습니다.

## 주요 특징

- **Pintos 호환성을 위한 Ubuntu 16.04 기본 이미지**
- **사전 구성된 개발 도구**
  - GCC 4.4 컴파일러 설정
  - OS 시뮬레이션을 위한 QEMU
  - 원격 개발을 위한 SSH 접속
- **간소화된 빌드 및 테스트 프로세스**


## 사전 준비 및 설정

### 1. 시스템 패키지 업데이트
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Ubuntu 24.04에 Docker 설치
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
# 그룹 변경 적용을 위해 재로그인
```

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

### SSH 접속
```bash
ssh user@<호스트_IP> -p 5555
```
- **사용자 비밀번호:** ihatepintos
- **루트 비밀번호:** vlsxhtmtlfgdjdy12!@

## Pintos 테스트 컴파일

### 빌드 상태
Dockerfile은 기본적으로 threads 프로젝트만 사전 컴파일합니다. 다른 테스트를 컴파일하고 실행하려면 수동으로 빌드해야 합니다.

### 추가 테스트 컴파일
```bash
# 특정 프로젝트 디렉토리로 이동
cd ~/pintos/src/<프로젝트_이름>

# 프로젝트 컴파일
make

# 특정 테스트 실행
pintos --qemu -- run <테스트-이름>
```

### Alarm Multiple 테스트 실행
```bash
# threads 빌드 디렉토리로 이동
cd ~/pintos/src/threads/build

# QEMU를 사용하여 alarm-multiple 테스트 실행
pintos --qemu -- run alarm-multiple
```

### 테스트 설명
`alarm-multiple` 테스트는 다음을 검증하도록 설계되었습니다:
- 스레드 스케줄링 메커니즘
- Sleep 및 알람 기능
- 병행 스레드 실행

#### 테스트의 주요 특징
- 5개의 스레드 생성
- 각 스레드는 서로 다른 지속 시간으로 sleep
- 다른 sleep 시간을 가진 스레드들의 상호작용 시연
- 운영체제의 스레드 관리 능력 검증

## 테스트 실행 결과

<img width="575" alt="Pintos Alarm Multiple Test Output" src="https://github.com/user-attachments/assets/61670ff7-6dce-41ce-a5a4-fd6559cf8050" />

### 테스트 실행 예시
테스트가 성공적으로 실행되면 다음과 유사한 출력을 볼 수 있습니다:
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

- Docker 그룹에 사용자 추가 후 로그아웃 및 재로그인 확인
- Docker 서비스 상태 확인: `sudo systemctl status docker`
- 컨테이너 실행 상태 확인: `docker ps`

## 호환성 참고 사항

- **호스트 시스템:** Ubuntu 24.04
- **컨테이너 기본 이미지:** Ubuntu 16.04 (Pintos 호환성을 위해)
- 버전 충돌 해결을 위해 추가 구성이 필요할 수 있습니다.

## 감사의 말
이 프로젝트는 국민대학교 허대영 교수님의 운영체제 강의 슬라이드를 참고하여 작성되었습니다.
