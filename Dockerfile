FROM debian:bullseye

RUN cp -pr /etc/skel/.[a-zA-Z]* /root/

# add apt repo:  docker, kubernetes, helm
RUN apt-get update; apt-get install -y     apt-transport-https ca-certificates curl gnupg lsb-release

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

RUN curl -fsSL https://helm.baltorepo.com/organization/signing.asc | apt-key add -; \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm-stable-debian.list

RUN apt-get update; apt-get install -y \
               docker-ce kubectl helm  \
               bash-completion screen vim procps \
               net-tools openssh-client dante-client iputils-ping dnsutils nmap traceroute netcat telnet \
               git make jq \
               python3-pip python3-cryptography

RUN mkdir -p /etc/bash_completion.d; kubectl completion bash > /etc/bash_completion.d/kubectl
RUN echo "escape ^t^t" > /root/.screenrc

# latest ansible(>=4.x) with k8s module.
RUN pip3 install requests google-auth kubernetes ansible yq
RUN ansible-galaxy collection install cloud.common kubernetes.core
