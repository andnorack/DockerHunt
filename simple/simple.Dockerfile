FROM debian:latest

ENV GO_VERSION="1.17.2"


RUN apt update -y && apt upgrade -y
RUN apt install -y \
	net-tools \
	dnsutils \
	whois \
	curl \
	wget \
	nmap \
	git \
	make \
	jq \
	nano \
	apt-transport-https \
	python3 \
	python3-pip \
	python3-setuptools \
	default-jdk \
	ruby-dev \
	nmap \
	sqlmap


# pre config
RUN echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" >> ~/.bashrc

# install go
ENV GOPATH="/usr/local/go"
ENV GO="$GOPATH/bin/go"
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
	tar zxvf go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local/ && \
	echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc

# set aliases
RUN echo "alias ll=\"ls -la --color\"" >> ~/.bash_aliases && \
	echo "alias ls=\"ls --color\"" >> ~/.bash_aliases

# clear tmp
RUN rm -rf /tmp/*


# final config
RUN . ~/.bashrc
WORKDIR /root/