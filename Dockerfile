# Build environment for LineageOS

FROM debian:buster
MAINTAINER Caleb Xu <calebcenter@live.com>

ENV \
# ccache specifics
    CCACHE_SIZE=50G \
    CCACHE_DIR=/srv/ccache \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1 \
# Configure Jack
    ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G" \
# Extra include PATH, it may not include /usr/local/(s)bin on some systems
    PATH=$PATH:/usr/local/bin/

RUN sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get clean -y \
 && apt-get install -y locales \
 && locale-gen --purge en_US.UTF-8 \
 && echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
      bison \
      build-essential \
      curl \
      flex \
      git \
      gnupg \
      gperf \
      kmod \
      liblz4-tool \
      libncurses5-dev \
      libncursesw6 \
      libsdl1.2-dev \
      libwxgtk3.0-dev \
      libxml2 \
      libxml2-utils \
      lzop \
      maven \
      openjdk-11-jdk-headless \
      pngcrush \
      procps \
      python \
      schedtool \
      squashfs-tools \
      xsltproc \
      zip \
      zlib1g-dev \
# For 64-bit systems
      g++-multilib \
      gcc-multilib \
      lib32ncurses5-dev \
      lib32readline6-dev \
      lib32z1-dev \
# Install additional packages which are useful for building Android
      android-tools-adb \
      android-tools-fastboot \
      bash-completion \
      bc \
      bsdmainutils \
      ccache \
      file \
      git \
      imagemagick \
      nano \
      rsync \
      sudo \
      tig \
      tmux \
      vim \
      wget \
 && rm -rf /var/lib/apt/lists/*

ARG hostuid=1000
ARG hostgid=1000

ADD startup.sh /home/build/startup.sh
RUN groupadd --gid $hostgid --force build \
 && useradd --gid $hostgid --uid $hostuid --non-unique build \
 && rsync -a /etc/skel/ /home/build/ \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo \
 && git config --system protocol.version 2 \
 && echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build \
 && chmod a+x /home/build/startup.sh \
 && chown -R build:build /home/build

VOLUME /home/build/android
VOLUME /srv/ccache

USER build
WORKDIR /home/build/android

CMD /home/build/startup.sh
