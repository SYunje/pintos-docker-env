FROM ubuntu:16.04

# 대화식 설치 방지
ENV DEBIAN_FRONTEND=noninteractive

#############################################
# 기본 시스템 준비 및 PPA 추가 (apt-utils 포함)
#############################################
RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update

#############################################
# 일반 사용자 생성 (root에서 진행) 및 비밀번호 설정
#############################################
RUN useradd -m user -s /bin/bash && \
    echo "user:ihatepintos" | chpasswd

#############################################
# gcc-4.4, g++-4.4, build-essential, wget, curl 설치
#############################################
RUN apt-get install -y gcc-4.4 g++-4.4 build-essential wget curl

#############################################
# gcc-4.4를 기본 gcc로 등록 (update-alternatives 사용)
#############################################
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 44 \
      --slave /usr/bin/g++ g++ /usr/bin/g++-4.4 && \
    update-alternatives --set gcc /usr/bin/gcc-4.4

#############################################
# qemu, vim 및 기타 필수 패키지 설치
#############################################
RUN apt-get install -y qemu vim sudo openssh-server gdb git nano make perl python libncurses5 libncurses5-dev zlib1g-dev less && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#############################################
# qemu 심볼릭 링크 생성 (qemu-system-i386를 qemu로 연결)
#############################################
RUN ln -sf /usr/bin/qemu-system-i386 /usr/bin/qemu

#############################################
# 작업 디렉터리 생성 및 설정
#############################################
RUN mkdir -p /home/user
WORKDIR /home/user

#############################################
# Pintos 다운로드 및 압축 해제 + 권한 변경
#############################################
RUN SITE=http://www.stanford.edu/class/cs140/projects && \
    wget $SITE/pintos/pintos.tar.gz && \
    tar xvzf pintos.tar.gz && \
    rm pintos.tar.gz && \
    chown -R user:user /home/user/pintos && \
    chmod -R 755 /home/user/pintos

#############################################
# 환경변수 PATH 설정 (압축 해제 후 Pintos util 경로 추가)
#############################################
ENV PATH="$PATH:/home/user/pintos/src/utils"
RUN echo 'export PATH="$PATH:/home/user/pintos/src/utils"' >> /home/user/.profile

#############################################
# Pintos util 변경 (Makefile 수정: LDFLAGS -> LDLIBS)
# 그리고 util 디렉터리에서 ls → make → ls로 결과 확인
#############################################
RUN sed -i 's/^LDFLAGS/LDLIBS/' /home/user/pintos/src/utils/Makefile && \
    cd /home/user/pintos/src/utils && ls && make && ls

#############################################
# pintos-gdb 수정 (GDBMACROS 경로 수정)
#############################################
RUN sed -i 's|^GDBMACROS *=.*|GDBMACROS = /home/user/pintos/src/misc/gdb/macros|' /home/user/pintos/src/utils/pintos-gdb

#############################################
# THREADS 컴파일 준비: threads 디렉터리로 이동하여 Make.vars 수정 (SIMULATOR = qemu)
# 그리고 threads 디렉터리에서 make 실행 후 결과 확인
#############################################
RUN sed -i 's|^SIMULATOR.*|SIMULATOR = qemu|' /home/user/pintos/src/threads/Make.vars && \
    cd /home/user/pintos/src/threads && make && ls

#############################################
# SSH 서버 설정
#############################################
RUN mkdir /var/run/sshd && \
    echo 'root:vlsxhtmtlfgdjdy12!@' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#############################################
# 일반 user 계정에 sudo 권한 부여
#############################################
RUN adduser user sudo && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#############################################
# 빌드 결과 확인 (build 디렉터리 확인)
#############################################
RUN if [ -d /home/user/pintos/build ]; then cd /home/user/pintos/build && ls; fi

#############################################
# 쉘 프롬프트 컬러, ls alias 및 LS_COLORS 설정 추가 (~/.bashrc 수정)
#############################################
RUN echo "export LS_COLORS='di=1;34:ln=1;36:so=35:pi=40;33:ex=1;32:*.tar=1;31'" >> /home/user/.bashrc && \
    echo "alias ls='ls --color=auto'" >> /home/user/.bashrc && \
    echo "export PS1='\\[\\e[0;32m\\]\\u@\\h:\\w\\$ \\[\\e[m\\] '" >> /home/user/.bashrc && \
    chown user:user /home/user/.bashrc

#############################################
# 작업 디렉터리 설정 및 포트 노출
#############################################
WORKDIR /home/user
EXPOSE 22

#############################################
# 컨테이너 시작 시 SSH 데몬 실행
#############################################
CMD ["/usr/sbin/sshd", "-D"]
