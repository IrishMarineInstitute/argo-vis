FROM node:15.3.0

# Set Locale

# RUN locale-gen en_US.UTF-8  
#ENV LANG en_US.UTF-8  
#ENV LANGUAGE en_US:en  
#ENV LC_ALL en_US.UTF-8



# Enable Universe and Multiverse and install dependencies.

#RUN echo deb http://archive.ubuntu.com/ubuntu precise universe multiverse >> /etc/apt/sources.list; \
RUN  apt-get update; \
    apt-get -y install autoconf automake build-essential git mercurial cmake libass-dev libgpac-dev libtheora-dev libtool libvdpau-dev libvorbis-dev pkg-config texi2html zlib1g-dev libmp3lame-dev wget yasm openssl libssl-dev; \
    apt-get clean


WORKDIR /usr/local/src
RUN git clone --depth 1 https://github.com/l-smash/l-smash 
RUN cd l-smash && ./configure
RUN cd l-smash && make -j $(nproc)
RUN cd l-smash && make install

RUN wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2
RUN tar xjvf nasm-2.13.01.tar.bz2
RUN cd nasm-2.13.01 && ./autogen.sh
RUN cd nasm-2.13.01 && ./configure
RUN cd nasm-2.13.01 && make
RUN cd nasm-2.13.01 && make install

RUN git clone --depth 1 http://git.videolan.org/git/x264.git
RUN cd x264 && ./configure --enable-static
RUN cd x264 && make -j 8
RUN cd x264 && make install

RUN git clone https://github.com/videolan/x265 
RUN cd x265/build/linux && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../../source
RUN cd x265/build/linux && make -j 8
RUN cd x265/build/linux && make install

RUN git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
RUN cd fdk-aac && autoreconf -fiv
RUN cd fdk-aac && ./configure --disable-shared 
RUN cd fdk-aac && make -j 8
RUN cd fdk-aac && make install

RUN git clone --depth 1 https://chromium.googlesource.com/webm/libvpx
RUN cd libvpx && ./configure --disable-examples
RUN cd libvpx && make -j 8
RUN cd libvpx && make install

RUN git clone https://github.com/xiph/opus.git
RUN cd opus && ./autogen.sh
RUN cd opus && ./configure --disable-shared
RUN cd opus && make -j 8
RUN cd opus && make install

RUN git clone https://github.com/FFmpeg/FFmpeg.git
RUN mv FFmpeg ffmpeg
RUN cd ffmpeg && \
    ./configure --extra-libs="-ldl" --enable-gpl --enable-libass \
                --enable-libfdk-aac --enable-libmp3lame \
                --enable-libopus --enable-libtheora --enable-libvorbis \
                --enable-libvpx --enable-libx264 --enable-libx265 \
                --enable-nonfree --enable-openssl --pkg-config-flags="--static"
RUN cd ffmpeg && make -j 8
RUN cd ffmpeg && make install

RUN git clone -n https://github.com/dgilman/aacgain.git
RUN cd aacgain && git checkout 93440798a533ea101ff178689fa6ce6724b253b7  && ./build.sh

RUN npm install -g timecut

RUN apt-get install -y libxcomposite1 libxcursor1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libasound2 libatk1.0-0 libatk-bridge2.0-0 libpangocairo-1.0-0 libgtk-3-0

RUN useradd -ms /bin/bash timecut

USER timecut
WORKDIR /home/timecut
