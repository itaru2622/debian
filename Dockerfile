FROM debian:buster

RUN apt-get update; \
    apt-get install -y \
               apt-transport-https ca-certificates curl gnupg lsb-release \
               bash-completion screen vim procps \
               net-tools openssh-client dante-client iputils-ping dnsutils nmap  traceroute  netcat telnet \
               git make jq

RUN cp -pr /etc/skel/.[a-zA-Z]* /root/

# apt repo
#
#   docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
#   kubernetes
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
#   kubernetes helm
RUN curl -fsSL https://helm.baltorepo.com/organization/signing.asc | apt-key add -; \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm-stable-debian.list

RUN apt-get update; \
    apt-get install -y   docker-ce kubectl helm    python3-pip python3-cryptography

RUN pip3 install yq \
                 requests google-auth kubernetes ansible
RUN ansible-galaxy collection install cloud.common kubernetes.core
