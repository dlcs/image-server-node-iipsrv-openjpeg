FROM ubuntu:18.04 as build

# avoid issue with tzdata requiring interaction
ARG DEBIAN_FRONTEND=noninteractive 

# install required packages
RUN apt-get update && apt-get install -y \
    libfcgi0ldbl libjpeg8 zlib1g-dev libstdc++6 libtool cmake wget  \
    libjpeg-dev libtiff-dev libpng-dev liblcms2-2 libmemcached-dev \
    git autoconf pkg-config gettext-base

# install build-essentials
RUN apt-get install build-essential -y

# clone openjpeg
RUN mkdir -p /opt && cd /opt && git clone https://github.com/uclouvain/openjpeg.git && cd openjpeg && git checkout v2.4.0

# build openjpeg
RUN cd /opt/openjpeg && cmake -DCMAKE_BUILD_TYPE=Release . && make && make install && ldconfig

# copy openjpeg headers
RUN cp /usr/local/include/openjpeg-2.4/*.h /opt/openjpeg/src/lib/openjp2/
RUN cp /usr/local/lib/libopenjp2.so /opt/openjpeg/bin/.

FROM ubuntu:18.04
RUN apt-get update && apt-get install -y \
    lighttpd \
    libfcgi \
    libgomp1 \
    groff \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="Donald Gray <donald.gray@digirati.com>"
LABEL org.opencontainers.image.source=https://github.com/dlcs/image-server-node-iipsrv-openjpeg
LABEL org.opencontainers.image.description="IIP Image Server 1.1 with OpenJpeg 2.4"

RUN ldconfig

# dirty way to do it...
RUN ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.4

RUN ln -s /etc/lighttpd/conf-available/10-fastcgi.conf /etc/lighttpd/conf-enabled/.

COPY lighttpd/lighttpd-1.conf.template /etc/lighttpd/lighttpd-1.conf.template

RUN mkdir -p /var/www/localhost && \
    ln -sf /dev/stdout /tmp/iipsrv-1.log

COPY --from=build /opt/openjpeg/bin/opj_compress /usr/bin/
COPY --from=build /opt/openjpeg/bin/opj_decompress /usr/bin/
COPY --from=build /opt/openjpeg/bin/opj_dump /usr/bin/
COPY --from=build /opt/openjpeg/bin/libopenjp2.a /usr/lib/
COPY --from=build /opt/openjpeg/bin/libopenjp2.so /usr/lib/
COPY --from=build /opt/openjpeg/bin/libopenjp2.so.2.4.0 /usr/lib/
COPY --from=build /opt/openjpeg/bin/libopenjp2.so.7 /usr/lib/
COPY --from=build /opt/openjpeg/src/lib/openjp2/openjpeg.h /usr/include/
COPY --from=build /opt/openjpeg/src/lib/openjp2/opj_config.h /usr/include/
COPY --from=build /opt/openjpeg/src/lib/openjp2/opj_stdint.h /usr/include/

COPY ./fcgi-bin.tar.gz /var/www/localhost/
RUN cd /var/www/localhost && tar -xzvf fcgi-bin.tar.gz

COPY ./operations.sh /

ENV IMAGE_CACHE_SIZE 128

EXPOSE 8080

CMD [ "/operations.sh" ]