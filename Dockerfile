FROM ubuntu:bionic-20190424

# It should be actively discouraged to set the DEBIAN_FRONTEND
# to noninteractive via ENV. The reason is that the environment variable
# persists after the build, e.g. when you run docker exec -it ... bash.
# The setting would not make sense here.
# https://serverfault.com/a/797318
ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm

# Set the locale
RUN apt-get -q update && apt-get -y -q dist-upgrade \
    && apt-get install -y -qq --no-install-recommends  \
    locales \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN apt-get -q update && apt-get -y -q dist-upgrade \
    && apt-get install -y -qq --no-install-recommends  \
    apt-transport-https \
    apt-utils \
    binutils \
    bash \
	bzip2 \
    ca-certificates \
    curl \
    git \
    gnupg \
    gnutls-bin \
    gzip \
    hugo \
    less \
    lsb-release \
	unzip \
	xz-utils \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get remove  -y -qq hugo \
    && curl -L -s https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_extended_0.55.6_Linux-64bit.deb \
    > hugo.deb \
    && ls -la \
    && dpkg -i hugo.deb \
    && rm hugo.deb

### Install Python / Miniconda3

ENV CONDA_DIR=/opt/miniconda3
ENV PATH=$CONDA_DIR/bin:$PATH

RUN curl -s https://repo.continuum.io/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh \
    > /tmp/Miniconda3.sh \
    && echo "718259965f234088d785cad1fbd7de03 /tmp/Miniconda3.sh" | md5sum -c - \
    && /bin/bash /tmp/Miniconda3.sh -b -p $CONDA_DIR \
    && rm /tmp/Miniconda3.sh

RUN conda update -q -y -c conda-forge --all \
    && conda install -q -y -c conda-forge python=3.7 wheel pip setuptools \
    && conda clean -a -f -y

RUN conda update -q -y -c conda-forge --all \
    && conda install -q -y -c conda-forge pygments awscli \
    && conda clean -a -f -y

ARG PRIMARY_TAG=UNDEFINED
ENV PRIMARY_TAG=$PRIMARY_TAG

ENV AWS_ACCESS_KEY_ID=YYYYYYYYYY
ENV AWS_SECRET_ACCESS_KEY=ZZZZZZZZZZ
