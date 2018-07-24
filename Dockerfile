# Build environment for LineageOS

FROM debian:stretch
MAINTAINER Caleb Xu <calebcenter@live.com>

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list \
 && echo "deb http://deb.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list \
 && echo "deb http://http.us.debian.org/debian sid main non-free contrib" >> /etc/apt/sources.list \
 && echo "Package: *" >> /etc/apt/preferences \
 && echo "Pin: release a=unstable" >> /etc/apt/preferences \
 && echo "Pin-Priority: 50" >> /etc/apt/preferences \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get clean \
 && apt-get install -y locales \
 && locale-gen --purge en_US.UTF-8 \
 && echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

ENV \
# ccache specifics
    CCACHE_SIZE=50G \
    CCACHE_DIR=/srv/ccache \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1 \
# Extra include PATH, it may not include /usr/local/(s)bin on some systems
    PATH=$PATH:/usr/local/bin/

RUN apt-get upgrade -y \
 && apt-get install -y \
# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
      bison \
      build-essential \
      curl \
      flex \
      git \
      gnupg \
      gperf \
      libesd0-dev \
      liblz4-tool \
      libncurses5-dev \
      libncursesw6 \
      libsdl1.2-dev \
      libwxgtk3.0-dev \
      libxml2 \
      libxml2-utils \
      lzop \
      maven \
      openjdk-8-jdk \
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
      imagemagick \
      nano \
      rsync \
      screen \
      sudo \
      tig \
      vim \
      wget \
 && apt-get -t stretch-backports upgrade -y git \
 && rm -rf /var/lib/apt/lists/*

ARG hostuid=1000
ARG hostgid=1000

RUN groupadd --gid $hostgid --force build \
 && useradd --gid $hostgid --uid $hostuid --non-unique build \
 && rsync -a /etc/skel/ /home/build/ \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo \
 && git config --system protocol.version 2 \

# Add sudo permission
 && echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build

ADD startup.sh /home/build/startup.sh
RUN chmod a+x /home/build/startup.sh \

# Fix ownership
 && chown -R build:build /home/build

VOLUME /home/build/android
VOLUME /srv/ccache

USER build
WORKDIR /home/build/android

CMD /home/build/startup.sh
