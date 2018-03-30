#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/ntpd"
fi


if [ -z "$base_server_role" ];then
	send_error "server's role is empty!"
	exit 1
fi

if [ ! -d /sunlight/backup ];then
	mkdir /sunlight/backup
	chmod 755 /sunlight/backup
fi

mv /etc/ntp.conf  /sunlight/backup/

if [ "$base_server_role" == "1" ];then
	cp "$opt_path/manage.ntp.conf"    /etc/ntp.conf
else
	cp "$opt_path/app.ntp.conf"   /etc/ntp.conf
fi

if [[ $base_server_role -eq 2 && -n "$app_ntp_server" ]];then
	sed -i "s/manageserverip/$app_ntp_server/"  /etc/ntp.conf
fi

if [[ $base_server_role -eq 3 && -n "$proxy_ntp_server" ]];then
	sed -i "s/manageserverip/$proxy_ntp_server/"  /etc/ntp.conf
fi

if [[ $base_server_role -eq 4 && -n "$epg_ntp_server" ]];then
	sed -i "s/manageserverip/$epg_ntp_server/"  /etc/ntp.conf
fi

if [[ $base_server_role -eq 5 && -n "$db_ntp_server" ]];then
	sed -i "s/manageserverip/$db_ntp_server/"  /etc/ntp.conf
fi


if [ -f /etc/ntp.conf ];then
	chmod 640 /etc/ntp.conf
fi

systemctl enable ntpd.service
systemctl start ntpd.service

send_info "ntpd config finished..."
send_info "------------------------------------------"