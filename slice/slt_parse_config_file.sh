#!/bin/bash

if [ -z "$base_path/ini/$ini_file" ];then
	send_error "$base_path/ini/$ini_file not found..."
	exit 1
fi

while read line
do
	if [ $(echo $line | grep -E "^${var_prefix}" | wc -l) -eq 1 ];then
		eval "$line"
		echo $line
	fi
done < $base_path/ini/$ini_file

if [ $base_server_role -eq 1 ];then
	if [ -z "$manage_private_ip" ];then
		send_error "manage_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi
	if [ -z "$manage_app_private_ip" ];then
		send_error "manage_app_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi
	
elif [ $base_server_role -eq 2 ]; then

	if [ -z "$app_private_ip" ];then
		send_error "app_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$app_iptv_ip" ];then
		send_error "app_iptv_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$app_cluster_private_ip" ];then
		send_error "app_cluster_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$app_cluster_iptv_ip" ];then
		send_error "app_cluster_iptv_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$app_maxscale_state" ];then
		send_error "app_maxscale_state is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$app_maxscale_weight" ];then
		send_error "app_maxscale_weight is empty!"
		send_error "install stopped..."
		exit 1
	fi

#	if [ -z "$app_epg_state" ];then
#		send_error "app_epg_state is empty!"
#		send_error "install stopped..."
#		exit 1
#	fi

#	if [ -z "$app_epg_weight" ];then
#		send_error "app_epg_weight is empty!"
#		send_error "install stopped..."
#		exit 1
#	fi

	if [ -z "$app_weedfs_state" ];then
		send_error "app_weedfs_state is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$app_weedfs_weight" ];then
		send_error "app_weedfs_weight is empty!"
		send_error "install stopped..."
		exit 1
	fi

elif [ $base_server_role -eq 3 ]; then

	if [ -z "$proxy_private_ip" ];then
		send_error "proxy_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$proxy_backend_private_ip" ];then
		send_error "proxy_backend_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$proxy_maxscale_state" ];then
		send_error "proxy_maxscale_state is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$proxy_maxscale_weight" ];then
		send_error "proxy_maxscale_weight is empty!"
		send_error "install stopped..."
		exit 1
	fi

elif [ $base_server_role -eq 4 ]; then
	
	if [ -z "$epg_private_ip" ];then
		send_error "epg_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

elif [ $base_server_role -eq 5 ]; then
	
	if [ -z "$db_cluster_private_ip" ];then
		send_error "db_cluster_private_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi

	if [ -z "$db_cluster_iptv_ip" ];then
		send_error "db_cluster_iptv_ip is empty!"
		send_error "install stopped..."
		exit 1
	fi
else
	send_error "base_server_role config error...!"
	exit 1
fi

echo "parse variable finished..."
