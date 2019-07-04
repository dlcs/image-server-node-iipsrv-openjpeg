#!/bin/sh

envsubst < /etc/lighttpd/lighttpd-1.conf.template > /etc/lighttpd/lighttpd-1.conf

chown www-data:www-data /tmp/iipsrv-1.log

echo starting lighttpd
lighttpd -D -f /etc/lighttpd/lighttpd-1.conf

