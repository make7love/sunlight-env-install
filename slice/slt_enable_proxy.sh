#!/bin/bash

if [ ! -d /sunlight/backup ];then
	mkdir /sunlight/backup
	chmod 755 /sunlight/backup
fi

if [ -f /etc/sysconfig/proxy ];then
	cp /etc/sysconfig/proxy  /sunlight/backup
fi

sed -i '/PROXY_ENABLED/c\PROXY_ENABLED="yes"' /etc/sysconfig/proxy
sed -i "/^HTTP_PROXY/c\HTTP_PROXY=\"$manage_server_private_ip\"" /etc/sysconfig/proxy
sed -i "/^HTTPS_PROXY/c\HTTPS_PROXY=\"$manage_server_private_ip\"" /etc/sysconfig/proxy

send_success "proxy set over..."
send_info "------------------------------------------"