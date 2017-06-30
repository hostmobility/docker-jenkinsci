FROM jenkins:2.46.2
MAINTAINER Mirza Krak "mirza.krak@hostmobility.com"

ENV DEBIAN_FRONTEND noninteractive

# We need to change to root to be able to install with apt-get 
USER root

COPY tar_1.26+dfsg-0.1+deb7u1_amd64.deb /

# Downgrade tar to 1.26 since we use a Yocto release that is not
# compatible with 1.27 (build breaks)
RUN apt-get update && dpkg -i /tar_1.26+dfsg-0.1+deb7u1_amd64.deb

RUN apt-get install -y gawk wget git-core sudo cpio \
	diffstat unzip texinfo gcc-multilib u-boot-tools rsync cbootimage bc \
	build-essential chrpath socat mtd-utils device-tree-compiler mtools lzop \
	dosfstools parted kmod python3 locales libsdl1.2-dev file ruby && rm -rf /var/lib/apt/lists/*

# We need to add jenkins to sudo and sudoers because we currently have an
# ugly script in hostmobility/mx4 repo that requires some commands to be
# run as sudo (unpack/pack rootfs) and without asking for password to 
# be able to run it in an jenkins environment
RUN adduser jenkins sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Location where Jenkins workspace is stored and it is the location
# where most of build time will be spent. Preferred if this
# location is on a SSD and if you bind-mount this directory from
# host using -v.
RUN mkdir -p /media/jenkins
RUN chown -R jenkins /media/jenkins

# Location where build history is stored. Usually a large HDD
# bind-mounted from host with -v.
RUN mkdir -p /media/storage/jenkins
RUN chown -R jenkins /media/storage/jenkins

# Jenkins http port
EXPOSE 8888

## Set LOCALE to UTF8
#
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Switch to user jenkins
USER jenkins

RUN git config --global user.email 'builder@hostmobility.com'
RUN git config --global user.name 'Host Mobility Builder'

RUN install-plugins.sh \
	multiple-scms \
	git \
	git-client \
	github \
	ssh-credentials \
	role-strategy \
	blueocean \
        blueocean-pipeline-editor \
        delivery-pipeline-plugin \
	jobConfigHistory \
	email-ext \
	mailer \

