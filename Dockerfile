FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
    lighttpd \
    libfcgi \
    libgomp1 \
    groff \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# dirty way to do it...
RUN ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.4

RUN ln -s /etc/lighttpd/conf-available/10-fastcgi.conf /etc/lighttpd/conf-enabled/.

COPY lighttpd/lighttpd-1.conf.template /etc/lighttpd/lighttpd-1.conf.template

RUN mkdir -p /var/www/localhost && \
    ln -sf /dev/stdout /tmp/iipsrv-1.log

COPY ./openjpeg.tar.gz /
RUN cd / && tar -xzvf openjpeg.tar.gz

COPY ./fcgi-bin.tar.gz /var/www/localhost/
RUN cd /var/www/localhost && tar -xzvf fcgi-bin.tar.gz

COPY ./operations.sh /

ENV IMAGE_CACHE_SIZE 128

EXPOSE 8080
