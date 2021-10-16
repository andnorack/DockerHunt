FROM debian:latest

MAINTAINER Andnorack

# Set ENV
ENV APKTOOL_VERSION="2.6.0"
ENV D2J_VERSION="2.0"
ENV JD_GUI_VERSION="1.6.6"
ENV JADX_VERSION="1.2.0"
ENV FRIDA_SERVER_VERSION="15.1.4"

RUN apt update -y && apt upgrade -y
RUN apt install -y \
	net-tools \
	dnsutils \
	usbutils \
	nano \
	git \
	curl \
	wget \
	python3 \
	python3-pip \
	unzip \
	default-jdk

WORKDIR /tmp/

# install apktool
RUN wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${APKTOOL_VERSION}.jar && \
	wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && \
	mv apktool /usr/local/bin/ && \
	mv apktool_${APKTOOL_VERSION}.jar /usr/local/bin/apktool.jar && \
	chmod +x /usr/local/bin/apktool

# install d2j
RUN wget https://github.com/pxb1988/dex2jar/releases/download/${D2J_VERSION}/dex-tools-${D2J_VERSION}.zip && \
	unzip dex-tools-${D2J_VERSION}.zip -d /opt/ && \
	chmod +x /opt/dex2jar-${D2J_VERSION}/*.sh && \
	for file in `ls /opt/dex2jar-${D2J_VERSION}/ | grep "\.sh" | cut -d'.' -f1`;do ln -sf /opt/dex2jar-${D2J_VERSION}/${file}.sh /usr/local/bin/${file};done

# install frida
RUN pip3 install colorama prompt-toolkit pygments && \
	pip3 install frida && \
	pip3 install frida-tools

# install objection
RUN pip3 install objection

# install adb
RUN curl -fsSL https://dl.google.com/android/repository/platform-tools-latest-linux.zip -o /tmp/adb.zip && \
	unzip /tmp/adb.zip -d /opt/ && \
	echo "export PATH=\$PATH:/opt/platform-tools" >> ~/.bashrc

# install jd-gui
RUN wget https://github.com/java-decompiler/jd-gui/releases/download/v${JD_GUI_VERSION}/jd-gui-${JD_GUI_VERSION}-min.jar && \
	mv jd-gui-${JD_GUI_VERSION}-min.jar /usr/local/bin

# install jadx
RUN mkdir /opt/jadx-${JADX_VERSION} && \
	wget https://github.com/skylot/jadx/releases/download/v${JADX_VERSION}/jadx-${JADX_VERSION}.zip && \
	unzip jadx-${JADX_VERSION}.zip -d /opt/jadx-${JADX_VERSION} && \
	rm /opt/jadx-${JADX_VERSION}/bin/*.bat && \
	echo "export PATH=\$PATH:/opt/jadx-$JADX_VERSION/bin" >> ~/.bashrc

# download frida server
RUN mkdir /opt/frida-servers
WORKDIR /opt/frida-servers

RUN wget https://github.com/frida/frida/releases/download/${FRIDA_SERVER_VERSION}/frida-server-${FRIDA_SERVER_VERSION}-android-arm.xz
RUN wget https://github.com/frida/frida/releases/download/${FRIDA_SERVER_VERSION}/frida-server-${FRIDA_SERVER_VERSION}-android-x86.xz

RUN for file in `ls | grep "\.xz"`; do unxz $file; done
#

RUN rm -rf /tmp/*
WORKDIR /root/