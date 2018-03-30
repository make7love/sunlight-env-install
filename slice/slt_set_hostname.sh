#!/bin/bash
if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`; pwd)
	opt_path="$base_path"
else
	opt_path="$base_path"
fi

if [[ $base_server_role -eq 1 && -n "$manage_hostname" ]];then
	hostnamectl set-hostname "$manage_hostname"
fi

if [[ $base_server_role -eq 2 && -n "$app_hostname" ]];then
	hostnamectl set-hostname "$app_hostname"
fi

if [[ $base_server_role -eq 3 && -n "$proxy_hostname" ]];then
	hostnamectl set-hostname "$proxy_hostname"
fi

if [[ $base_server_role -eq 4 && -n "$epg_hostname" ]];then
	hostnamectl set-hostname "$epg_hostname"
fi

if [[ $base_server_role -eq 5 && -n "$db_hostname" ]];then
	hostnamectl set-hostname "$db_hostname"
fi

if [ $? -eq 0 ];then
	send_success "hostname set ok..."
fi