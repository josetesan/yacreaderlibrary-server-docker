FROM debian:jessie
MAINTAINER muallin@gmail.com

# Update system
RUN apt-get update && \
    apt-get -y install mercurial qt5-default libpoppler-qt5-dev wget unzip

WORKDIR /src
WORKDIR hg
    
# Bring yacreader

RUN hg clone https://bitbucket.org/luisangelsm/yacreader . && \
    cd compressed_archive/unarr/ && \
    wget github.com/selmf/unarr/archive/master.zip &&\
    unzip master.zip  &&\
    rm master.zip &&\
    cd unarr-master/lzmasdk &&\
    ln -s 7zTypes.h Types.h && \
    cd /src/hg/YACReaderLibraryServer/

# Compile yacreader    
RUN qmake YACReaderLibraryServer.pro  && \
    make  && \
    make install

#Cleanup
RUN rm -rf /src && \
    rm -rf /var/cache/apt &&\
    apt-get purge mercurial qt5-default libpoppler-qt5-dev wget && \
    apt-get autoremove

VOLUME /comics
    
RUN YACReaderLibraryServer add-library MyComics /comics
    
EXPOSE 8080

ENTRYPOINT ["YACReaderLibraryServer","start"]