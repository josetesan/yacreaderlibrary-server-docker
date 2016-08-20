FROM debian:jessie
MAINTAINER muallin@gmail.com

# Update system
RUN apt-get update && \
    apt-get -y install mercurial qt5-default libpoppler-qt5-dev libpoppler-qt5-1 wget unzip libqt5sql5-sqlite libqt5sql5 sqlite3 libqt5network5 libqt5gui5 libqt5core5a build-essential

WORKDIR /src
WORKDIR hg
    
# Bring yacreader

RUN hg clone https://bitbucket.org/luisangelsm/yacreader . && \
    cd compressed_archive/unarr/ && \
    wget github.com/selmf/unarr/archive/master.zip &&\
    unzip master.zip  &&\
    rm master.zip &&\
    cd unarr-master/lzmasdk &&\
    ln -s 7zTypes.h Types.h 

WORKDIR YACReaderLibraryServer

# Compile yacreader    
RUN qmake YACReaderLibraryServer.pro && \
    make  && \
    make install
    
WORKDIR /    

#Cleanup
RUN rm -rf /src && \
    rm -rf /var/cache/apt &&\
    apt-get purge -y mercurial wget build-essential && \
    apt-get -y autoremove

VOLUME /comics
    
RUN YACReaderLibraryServer create-library MyComics /comics
    
EXPOSE 8080

ENTRYPOINT ["YACReaderLibraryServer","start"]