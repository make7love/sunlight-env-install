#!/bin/bash

if [ ! -d /usr/local/sunlight/conf ];then
	mkdir -p /usr/local/sunlight/conf
	chmod 755 /usr/local/sunlight/conf
fi


if [ -n "$base_sp_name" ];then
	echo "[spinfo]" >> /usr/local/sunlight/conf/spinfo.ini
	echo "spname=$base_sp_name"  >> /usr/local/sunlight/conf/spinfo.ini
fi

if [[ $base_server_role -eq 1 && -n "$manage_app_private_ip" ]];then
	echo "cluster=\"${manage_app_private_ip}\"" >> /usr/local/sunlight/conf/spinfo.ini
fi

if [[ $base_server_role -eq 2 && -n "$app_cluster_private_ip" ]];then
	echo "cluster=\"${app_cluster_private_ip}\"" >> /usr/local/sunlight/conf/spinfo.ini
fi

if [[ $base_server_role -eq 3 && -n "$proxy_backend_private_ip" ]];then
	echo "cluster=\"${proxy_backend_private_ip}\"" >> /usr/local/sunlight/conf/spinfo.ini
fi


if [[ $base_server_role -eq 4 && -n "$epg_cluster_private_ip" ]];then
	echo "cluster=\"${epg_cluster_private_ip}\"" >> /usr/local/sunlight/conf/spinfo.ini
fi

if [[ $base_server_role -eq 5 && -n "$db_cluster_private_ip" ]];then
	echo "cluster=\"${db_cluster_private_ip}\"" >> /usr/local/sunlight/conf/spinfo.ini
fi



