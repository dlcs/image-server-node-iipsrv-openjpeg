FROM centos
MAINTAINER Adam Christie <adam.christie@digirati.co.uk>

RUN yum update
RUN yum install -y epel-release
RUN yum install -y scl-utils scl-utils-build
RUN yum install -y memcached libjpeg-devel libtiff-devel centos-release-scl git cmake zlib-devel libpng-devel lcms2-devel wget
RUN yum install -y devtoolset-4
RUN scl enable devtoolset-4 bash
COPY ./compile-openjpeg.sh .
RUN ./compile-openjpeg.sh

# library path fixes
RUN cp /usr/include/openjpeg-2.2/*.h /openjpeg/src/lib/openjp2/
RUN mkdir /openjpeg/bin
RUN cp /usr/lib/libopenjp2.so /openjpeg/bin/

# now iipsrv
RUN yum install -y gc gcc++ *gcc-c++*
COPY ./compile-iipsrv.sh .
RUN ./compile-iipsrv.sh
RUN mkdir -p /var/www/localhost/fcgi-bin
RUN cp /iipsrv/src/iipsrv.fcgi /var/www/localhost/fcgi-bin/

# now lighttpd
RUN yum install -y lighttpd-fastcgi
COPY lighttpd/lighttpd-1.conf /etc/lighttpd/lighttpd-1.conf

RUN useradd -M -U www-data
RUN mkdir -p /var/cache/lighttpd/compress

COPY ./operations.sh .

EXPOSE 8080
