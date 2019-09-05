FROM kalilinux/kali-linux-docker

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean \
    && apt-get install -y --no-install-recommends software-properties-common curl
RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
        openssh-server pwgen sudo vim-tiny \
	    supervisor \
        net-tools \
        lxde x11vnc xvfb autocutsel \
	    xfonts-base lwm xterm \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        dbus-x11 x11-utils \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# For installing Kali metapackages uncomment needed lines
RUN apt-get update && apt-cache search kali-linux && apt-get install -y   \
#        kali-linux  \               # Kali Linux base system
#        kali-linux-all  \           # Kali Linux - all packages
#        kali-linux-forensic \       # Kali Linux forensic tools
#        kali-linux-full \           # Kali Linux complete system
#        kali-linux-gpu  \           # Kali Linux GPU tools
#        kali-linux-nethunter    \   # Kali Linux Nethunter tools
#        kali-linux-pwtools  \       # Kali Linux password cracking tools
#        kali-linux-rfid \           # Kali Linux RFID tools
#        kali-linux-sdr  \           # Kali Linux SDR tools
        kali-linux-top10    \       # Kali Linux Top 10 tools
#        kali-linux-voip \           # Kali Linux VoIP tools
#        kali-linux-web  \           # Kali Linux webapp assessment tools
#        kali-linux-wireless \       # Kali Linux wireless tools

ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80
WORKDIR /root
ENV HOME=/root \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]

CMD ["/bin/bash"]
