FROM ubuntu:16.04

# Prevent interactive installation
ENV DEBIAN_FRONTEND=noninteractive

#############################################
# Prepare basic system and add PPA (including apt-utils)
#############################################
RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update

#############################################
# Create general user (proceed as root) and set password
#############################################
RUN useradd -m user -s /bin/bash && \
    echo "user:ihatepintos" | chpasswd

#############################################
# Install gcc-4.4, g++-4.4, build-essential, wget, curl
#############################################
RUN apt-get install -y gcc-4.4 g++-4.4 build-essential wget curl

#############################################
# Register gcc-4.4 as default gcc (using update-alternatives)
#############################################
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 44 \
      --slave /usr/bin/g++ g++ /usr/bin/g++-4.4 && \
    update-alternatives --set gcc /usr/bin/gcc-4.4

#############################################
# Install qemu, vim, and other essential packages
#############################################
RUN apt-get install -y qemu vim sudo openssh-server gdb git nano make perl python libncurses5 libncurses5-dev zlib1g-dev less && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#############################################
# Create symbolic link for qemu (link qemu-system-i386 to qemu)
#############################################
RUN ln -sf /usr/bin/qemu-system-i386 /usr/bin/qemu

#############################################
# Create and configure working directory
#############################################
RUN mkdir -p /home/user
WORKDIR /home/user

#############################################
# Download Pintos, extract + change permissions
#############################################
RUN SITE=http://www.stanford.edu/class/cs140/projects && \
    wget $SITE/pintos/pintos.tar.gz && \
    tar xvzf pintos.tar.gz && \
    rm pintos.tar.gz && \
    chown -R user:user /home/user/pintos && \
    chmod -R 755 /home/user/pintos

#############################################
# Set PATH environment variable (add Pintos util path after extraction)
#############################################
ENV PATH="$PATH:/home/user/pintos/src/utils"
RUN echo 'export PATH="$PATH:/home/user/pintos/src/utils"' >> /home/user/.profile

#############################################
# Modify Pintos util (Makefile: LDFLAGS -> LDLIBS)
# Check results with ls → make → ls in util directory
#############################################
RUN sed -i 's/^LDFLAGS/LDLIBS/' /home/user/pintos/src/utils/Makefile && \
    cd /home/user/pintos/src/utils && ls && make && ls

#############################################
# Modify pintos-gdb (update GDBMACROS path)
#############################################
RUN sed -i 's|^GDBMACROS *=.*|GDBMACROS = /home/user/pintos/src/misc/gdb/macros|' /home/user/pintos/src/utils/pintos-gdb

#############################################
# Prepare THREADS compilation: move to threads directory, modify Make.vars (SIMULATOR = qemu)
# Run make in threads directory and check results
#############################################
RUN sed -i 's|^SIMULATOR.*|SIMULATOR = qemu|' /home/user/pintos/src/threads/Make.vars && \
    cd /home/user/pintos/src/threads && make && ls

#############################################
# Configure SSH server
#############################################
RUN mkdir /var/run/sshd && \
    echo 'root:vlsxhtmtlfgdjdy12!@' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#############################################
# Grant sudo privileges to regular user account
#############################################
RUN adduser user sudo && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#############################################
# Check build results (verify build directory)
#############################################
RUN if [ -d /home/user/pintos/build ]; then cd /home/user/pintos/build && ls; fi

#############################################
# Add shell prompt color, ls alias, and LS_COLORS settings (~/.bashrc modification)
#############################################
RUN echo "export LS_COLORS='di=1;34:ln=1;36:so=35:pi=40;33:ex=1;32:*.tar=1;31'" >> /home/user/.bashrc && \
    echo "alias ls='ls --color=auto'" >> /home/user/.bashrc && \
    echo "export PS1='\\[\\e[0;32m\\]\\u@\\h:\\w\\$ \\[\\e[m\\] '" >> /home/user/.bashrc && \
    chown user:user /home/user/.bashrc

#############################################
# Set working directory and expose port
#############################################
WORKDIR /home/user
EXPOSE 22

#############################################
# Start SSH daemon when container launches
#############################################
CMD ["/usr/sbin/sshd", "-D"]
