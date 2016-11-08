#FROM centos
FROM ubuntu
MAINTAINER Adam Christie <adam.christie@digirati.co.uk>

RUN apt-get update
#RUN yum install -y epel-release
#RUN yum install -y scl-utils scl-utils-build
#RUN yum install -y memcached libjpeg-devel libtiff-devel centos-release-scl git cmake zlib-devel libpng-devel lcms2-devel wget
RUN apt-get install -y memcached libjpeg-dev libtiff-dev libpng-dev wget git
#RUN yum install -y devtoolset-4
#RUN scl enable devtoolset-4 bash
COPY ./openjpeg.tar.gz .
RUN tar -xzvf openjpeg.tar.gz
#COPY ./compile-openjpeg.sh .
#RUN ./compile-openjpeg.sh

# library path fixes
RUN mkdir -p /openjpeg/src/lib/openjp2
RUN cp /usr/include/openjpeg-2.2/*.h /openjpeg/src/lib/openjp2/
RUN mkdir /openjpeg/bin
RUN cp /usr/lib/libopenjp2.so /openjpeg/bin/

# now iipsrv
#RUN yum install -y gc gcc++ *gcc-c++*
RUN apt-get install -y libfcgi-dev gcc
COPY ./iipsrv.tar.gz .
RUN tar -xzvf iipsrv.tar.gz
#COPY ./compile-iipsrv.sh .
#RUN ./compile-iipsrv.sh

RUN mkdir -p /var/www/localhost/fcgi-bin
RUN cp /iipsrv/iipsrv.fcgi /var/www/localhost/fcgi-bin/

# now lighttpd
#RUN yum install -y lighttpd-fastcgi
RUN apt-get install -y lighttpd
COPY lighttpd/lighttpd-1.conf /etc/lighttpd/lighttpd-1.conf

#RUN useradd -M -U www-data
#RUN mkdir -p /var/cache/lighttpd/compress

COPY ./operations.sh .

EXPOSE 8080
