FROM freedesktopsdk/flatpak:19.08-x86_64

ADD https://nodejs.org/dist/v10.19.0/node-v10.19.0.tar.gz \
    /var/tmp/build/

ADD https://www.python.org/ftp/python/2.7.17/Python-2.7.17.tar.xz \
    /var/tmp/build/

RUN cd /var/tmp/build/ && \
    tar -xf Python-*.tar.xz && \
    cd  Python-*/ && \
    mkdir -p $(pwd)/tmp && \
    export TMPDIR=$(pwd)/tmp && \
    ./configure \
        --prefix=/usr \
        --disable-shared \
        --with-ensurepip=yes \
        --with-system-expat \
        --with-system-ffi \
        --with-dbmliborder=gdbm \
        --enable-unicode=ucs4 \
        && \
    make -j$(nproc) && \
    make install && \
    strip /usr/bin/python2.7

RUN cd /var/tmp/build/ && \
    tar -xf node-v*.tar.gz && \
    cd  node-v*/ && \
    ./configure \
        --prefix=/usr \
        --openssl-use-def-ca-store \
        --shared-openssl \
        --shared-zlib \
        --with-intl=system-icu \
        && \
    make -j$(nproc) && \
    make install && \
    strip /usr/bin/node

RUN export HOME=/var/tmp/build && \
    npm install -g yarn

RUN rm -rf /var/tmp/build
