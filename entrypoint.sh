#!/usr/bin/env bash

/usr/local/bin/ovpn_genconfig -b -u udp://${DOMAIN}:${EXTERNAL_PORT} -C 'AES-256-CBC' -a 'SHA384'
/usr/local/bin/ovpn_initpki nopass
/usr/local/bin/easyrsa build-client-full config nopass
/usr/local/bin/ovpn_getclient config > /configs/config.ovpn

printf "${OPENVPN_USER}:$(openssl passwd -crypt ${OPENVPN_PASSWORD})\n" >> /.htpasswd
sed -i 's#localhost#'${DOMAIN}'#g' /etc/nginx/sites-enabled/openvpn.conf

exec "$@"