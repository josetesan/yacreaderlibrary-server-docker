FROM debian:buster
MAINTAINER muallin@gmail.com

WORKDIR /src
WORKDIR git

# Update system
# Update system
#RUN add-apt-repository universe
RUN apt-get update && \
    apt-get -y install p7zip-full git dumb-init qt5-default libpoppler-qt5-dev libpoppler-qt5-1 wget unzip libqt5sql5-sqlite libqt5sql5 sqlite3 libqt5network5 libqt5gui5 libqt5core5a build-essential
RUN git clone https://github.com/YACReader/yacreader.git . && \
    git checkout 9.7.1
RUN cd compressed_archive/unarr/ && \
    wget github.com/selmf/unarr/archive/master.zip &&\
    unzip master.zip  &&\
    rm master.zip &&\
    cd unarr-master/lzmasdk &&\
    ln -s 7zTypes.h Types.h
RUN cd compressed_archive/ &&\
    git clone https://github.com/stonewell/lib7zip ./libp7zip
RUN cd /src/git/YACReaderLibraryServer && \
    qmake "CONFIG+=7zip" YACReaderLibraryServer.pro && \
    make  && \
    make install
RUN cd /     && \
    rm -rf /src && \
    rm -rf /var/cache/apt &&\
    apt-get purge -y git wget build-essential && \
    apt-get -y autoremove
ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

#ADD entrypoint.sh /
#RUN /bin/sh -c 'chmod +x /entrypoint.sh'

# add specific volumes: configuration, comics repository, and hidden library data to separate them
VOLUME ["/config", "/comics", "/comics/.yacreaderlibrary"]

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
