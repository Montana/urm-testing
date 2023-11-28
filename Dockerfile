FROM ubuntu:16.04
LABEL maintainer="montana@travis-ci.org"

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    software-properties-common \
    build-essential \
    git \
    mercurial \
    apt-transport-https \
    lsb-release \
    gnupg \
    jq \
    sudo && \
    # Add Brightbox PPA for Ruby
    apt-add-repository ppa:brightbox/ruby-ng && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    # Install Ruby, Python, Node.js, Java
    apt-get update && apt-get install -y \
    ruby2.6 \
    ruby2.6-dev \
    nodejs \
    python3-pip \
    openjdk-8-jdk && \
    # Upgrade pip for Python and install bundler for Ruby
    pip3 install --upgrade pip && \
    gem install bundler --no-document && \
    # Clean up to keep the image small
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m -s /bin/bash travis && \
    echo "travis ALL=NOPASSWD: ALL" > /etc/sudoers.d/travis && \
    chmod 0440 /etc/sudoers.d/travis

USER travis

# Setting the working directory 
WORKDIR /home/travis

CMD ["/bin/bash"]
