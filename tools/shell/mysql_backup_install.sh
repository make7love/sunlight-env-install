#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/tools/shell"
fi

if [ ! -d /sunlight/shell ];then
	mkdir /sunlight/shell
	chmod 755 /sunlight/shell
fi

if [ ! -f /sunlight/shell/main.sh ];then
	if [ -f "$opt_path/scripts/main.sh" ];then
		cp "$opt_path/scripts/main.sh"  /sunlight/shell/
		chmod 755 /sunlight/shell/main.sh 
	fi
fi

if [ ! -d /usr/local/sunlight/conf ];then
	mkdir -p /usr/local/sunlight/conf
	chmod 755 /usr/local/sunlight/conf
fi

if [ $base_server_role -eq 1 ];then
	cp "$opt_path/scripts/clusterbackup.sh"  "/root/bin/clusterbackup"
	chmod +x  /root/bin/clusterbackup
	echo "15 9 * * * root flock -xn /tmp/clusterbackup.lock -c '/usr/bin/sh /root/bin/clusterbackup > /dev/null  2>&1'" \
	>> /etc/cron.d/sunlight-backup
	chmod 644 /etc/cron.d/sunlight-backup

elif [[ $base_server_role -eq 2 || $base_server_role -eq 5 ]]; then
	cp "$opt_path/scripts/cluster_backup.sh"  "/root/bin/cluster_backup"
	chmod +x "/root/bin/cluster_backup"
else
	send_info "This server need not to install cluster_backup script, skip..."
	echo "--------------------------------------------------------------------"
	sleep 2
fi