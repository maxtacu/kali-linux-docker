FROM kalilinux/kali-rolling

RUN echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list && \
echo "deb http://http.kali.org/kali kali-last-snapshot main non-free contrib" >> /etc/apt/sources.list && \
echo "deb http://http.kali.org/kali kali-experimental main non-free contrib" >> /etc/apt/sources.list && \
echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
#RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

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
        python3-pip python3-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        dbus-x11 x11-utils \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -U pip

# ###############
# https://www.kali.org/docs/containers/official-kalilinux-docker-images/
# https://www.kali.org/blog/kali-linux-metapackages/
#
# kali-linux-full
# When you download a Kali Linux ISO, you are essentially downloading an installation that has the kali-linux-full metapackage installed.
# This package includes all of the tools you are familiar with in Kali.
# Installation Size: 9.0 GB
#
# kali-linux-all
# In order to keep our ISO sizes reasonable, we are unable to include every single tool that we package for Kali
# and there are a number of tools that are not able to be used depending on hardware, such as various GPU tools.
# If you want to install every available Kali Linux package, you can install the kali-linux-all metapackage.
# Installation Size: 15 GB
#
# kali-linux-top10
# In Kali Linux, we have a sub-menu called "Top 10 Security Tools".
# The kali-linux-top10 metapackage will install all of these tools for you in one fell swoop.
# https://www.kali.org/blog/kali-linux-metapackages/images/top10-menu.png
# Installation Size: 3.5 GB
#
# kali-linux-forensic
# If you are doing forensics work, you don’t want your analysis system to contain a bunch of unnecessary tools.
# To the rescue comes the kali-linux-forensic metapackage, which only contains the forensics tools in Kali.
# Installation Size: 3.1 GB
#
# kali-linux-gpu
# GPU utilities are very powerful but need special hardware in order to function correctly.
# For this reason, they are not included in the default Kali Linux installation
# but you can install them all at once with kali-linux-gpu and get cracking.
# Installation Size: 4.8 GB
#
# kali-linux-pwtools
# The kali-linux-pwtools metapackage contains over 40 different password cracking utilities
# as well as the GPU tools contained in kali-linux-gpu.
# Installation Size: 6.0 GB
#
# kali-linux-rfid
# For our users who are doing RFID research and exploitation, we have the kali-linux-rfid metapackage
# containing all of the RFID tools available in Kali Linux.
# Installation Size: 1.5 GB
#
# kali-linux-sdr
# The kali-linux-sdr metapackage contains a large selection of tools for your Software Defined Radio hacking needs.
# Installation Size: 2.4 GB
#
# kali-linux-voip
# Many people have told us they use Kali Linux to conduct VoIP testing and research
# so they will be happy to know we now have a dedicated kali-linux-voip metapackage with 20+ tools.
# Installation Size: 1.8 GB
#
# kali-linux-web
# Web application assessments are very common in the field of penetration testing and for this reason,
# Kali includes the kali-linux-web metapackage containing dozens of tools related to web application hacking.
# Installation Size: 4.9 GB
#
# kali-linux-wireless
# Like web applications, many penetration testing assessments are targeted towards wireless networks.
# The kali-linux-wireless metapackage contains all the tools you’ll need in one easy to install package.
# Installation Size: 6.6 GB
#
#
# To see the list of tools included in a metapackage, you can use simple apt commands.
# For example, to list all the tools included in the kali-linux-web metapackage, we could:
# apt-cache show kali-linux-web | grep Depends
#
# For installing other Kali metapackages check https://tools.kali.org/kali-metapackages
# RUN apt-get update && apt-cache search kali-linux && apt-get install -y   \
#         kali-tools-top10
RUN apt-get update && apt-cache search kali-linux && apt-get install -y   \
        kali-tools-top10

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
# python3 -m pip install --upgrade pip &&
RUN python3 -m pip install --upgrade pip && pip3 install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80
WORKDIR /root
ENV HOME=/root \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]

CMD ["/bin/bash"]
