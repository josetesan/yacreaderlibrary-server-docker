FROM debian:bullseye as builder
LABEL maintainer="muallin@gmail.com"

WORKDIR /src/git

ENV YACREADER_VERSION 9.13.1

# Update system
RUN apt-get update && \
    apt-get -y install git build-essential p7zip-full sqlite3 libunarr-dev qtdeclarative5-dev qt5-image-formats-plugins libpoppler-qt5-dev libpoppler-qt5-1 libqt5sql5 libqt5sql5-sqlite libqt5network5 libqt5gui5 libqt5core5a

RUN git clone https://github.com/YACReader/yacreader.git . && \
    git checkout ${YACREADER_VERSION}

RUN cd /src/git/YACReaderLibraryServer && \
    qmake PREFIX=/app "CONFIG+=server_standalone" YACReaderLibraryServer.pro && \
    make -j4 && \
    make install

FROM debian:bullseye as runner

RUN apt-get update && \
    apt-get -y install p7zip-full \
    sqlite3 \
    libunarr-dev \
    qt5-image-formats-plugins \
    libpoppler-qt5-1 \
    libqt5sql5 \
    libqt5sql5-sqlite \
    libqt5network5 \
    libqt5gui5 \
    libqt5core5a

COPY --from=builder --chown=root:root /app /usr

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

# add specific volumes: configuration, comics repository, and hidden library data to separate them
VOLUME ["/comics"]

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
