##############################################################################################
#  Copyright Accenture. All Rights Reserved.
#
#  SPDX-License-Identifier: Apache-2.0
##############################################################################################
# USAGE: 
# docker build . -t bevel-build
# docker run -v $(pwd):/home/bevel/ bevel-build

FROM ubuntu:20.04
# Create working directory
WORKDIR /home/
ENV OPENSHIFT_VERSION='0.13.1'

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget\
        curl \
        unzip \
        build-essential \
	    openssh-client \
        gcc \
        git \
        libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev \
        jq \
        npm

# Install OpenJDK-14
RUN wget https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz \
    && tar xvf openjdk-14_linux-x64_bin.tar.gz \
    && rm openjdk-14_linux-x64_bin.tar.gz

RUN apt-get update && apt-get install -y \
    python3-pip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install ansible && \
    pip3 install jmespath && \
    pip3 install openshift==${OPENSHIFT_VERSION} && \
    apt-get clean && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# base58 is needed in Substrate to encode nodeids
RUN pip3 install base58

RUN npm install -g ajv-cli
RUN apt-get update && apt-get install -y python3-venv

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN mkdir /etc/ansible/
RUN /bin/echo -e "[ansible_provisioners:children]\nlocal\n[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.27.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

# Install krew for bevel-operator-fabric
RUN (set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew)

# Create local user ubuntu
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} ubuntu \
 && useradd -m -u ${USER_ID} -g ubuntu -s /bin/bash ubuntu
# Copy the provisional script to build container
COPY ./run.sh /home
COPY ./reset.sh /home
RUN chmod 755 /home/run.sh
RUN chmod 755 /home/reset.sh

ENV JAVA_HOME=/home/jdk-14
ENV PATH=~/.krew/bin:/home/jdk-14/bin:/root/bin:/root/.local/bin/:/home/ubuntu/bin:$PATH

# The mounted repo should contain a build folder with the following files
# 1) K8s config file as config
# 2) Network specific configuration file as network.yaml
# 3) Private key file which has write-access to the git repo

#path to mount the repo
VOLUME /home/bevel/
USER ubuntu
CMD ["/home/run.sh"]
