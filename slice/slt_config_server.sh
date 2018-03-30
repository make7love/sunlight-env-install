#!/bin/bash

if [ -f /usr/local/sunlight/conf/server.conf ];then
	sed -i "s/maxscale/$base_maxscale_vip/" /usr/local/sunlight/conf/server.conf
	if [ $? -eq 0 ];then
		send_success "server.conf has been configed..."
		send_info "-----------------------------------------"
	else
		send_error "server.conf config failed..."
	fi
else
	send_info "/usr/local/sunlight/conf/server.conf not found, skipped..."
fi