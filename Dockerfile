FROM ubuntu:trusty
MAINTAINER mezz64 <mezz64@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
#ENV HOME /root
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

# Use baseimage-docker's init system
#CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

#RUN apt-get update -qq
# Update ubuntu
RUN apt-mark hold initscripts udev plymouth mountall
RUN apt-get -q update
RUN apt-get dist-upgrade -qy && apt-get -q update

# Install MediaBrowser run dependencies
RUN apt-get install -qy --force-yes libmono-cil-dev Libgdiplus mediainfo wget

# Download latest release from Dropbox
RUN wget https://github.com/MediaBrowser/MediaBrowser.Resources/raw/master/Releases/Server/mediabrowser.deb && dpkg -i mediabrowser.deb && apt-get install -f

# Uncomment for unRAID
RUN chown -R nobody:users /opt/mediabrowser

# Install MediaBrowser
#RUN mkdir mkdir /opt/MediaBrowser && \
#    cd /opt/MediaBrowser && \
#    wget -nv -O MBServer.Mono.zip https://www.dropbox.com/s/07hh1g4x9xo28jb/MBServer.Mono.zip?dl=1 && \
#    unzip MBServer.Mono.zip && \
#    rm MBServer.Mono.zip

# Cleanup
RUN apt-get -y autoremove && rm mediabrowser.deb
RUN mkdir /config && chown -R nobody:users /config

#VOLUMES
VOLUME /config
#RUN rm -rf /opt/MediaBrowser/ProgramData-Server && \
#    ln -sf /config/ /opt/MediaBrowser/ProgramData-Server && \
#    chown -R nobody:users /opt/MediaBrowser

# Add media_browser.sh to runit
#RUN mkdir /etc/service/media_browser
#ADD media_browser.sh /etc/service/media_browser/run
#RUN chmod +x /etc/service/media_browser/run

ADD ./media_browser.sh /media_browser.sh
RUN chmod u+x  /media_browser.sh

# Default MB3 HTTP/tcp server port
EXPOSE 8096/tcp
# UDP server port
EXPOSE 7359/udp
# ssdp port for UPnP / DLNA discovery
EXPOSE 1900/udp

# Run as default unRAID user nobody
USER nobody
ENTRYPOINT ["/media_browser.sh"]


