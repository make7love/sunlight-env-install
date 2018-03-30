#!/bin/bash
if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/squid"
fi

if [ $base_server_role -eq 1 ];then
	rpm -ivh "$opt_path/*.rpm"
	systemctl start squid.service
	systemctl enable squid.service
	send_success "squid install finished..."
	send_info "------------------------------------------"
else
	send_info ">>>> This server node need not to install squid server, skip..."
fi


