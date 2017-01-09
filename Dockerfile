FROM jenkins:2.32.1

# We need to change to root to be able to install with apt-get 
USER root
RUN apt-get update && apt-get install -y gawk wget git-core sudo cpio \
	diffstat unzip texinfo gcc-multilib u-boot-tools rsync cbootimage bc \
	build-essential chrpath socat mtd-utils device-tree-compiler mtools lzop

# We need to add jenkins to sudo and sudoers because we currently have an
# ugly script in hostmobility/mx4 repo that requires some commands to be
# run as sudo (unpack/pack rootfs) and without asking for password to 
# be able to run it in an jenkins environment
RUN adduser jenkins sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to user jenkins
USER jenkins

RUN install-plugins.sh multiple-scms git git-client github ssh-credentials

