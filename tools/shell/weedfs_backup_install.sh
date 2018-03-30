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

if [ -f "$opt_path/scripts/main.sh" ];then
	cp "$opt_path/scripts/main.sh"  /sunlight/shell/
	chmod 755 /sunlight/shell/main.sh 
fi

if [ ! -d /usr/local/sunlight/conf ];then
	mkdir -p /usr/local/sunlight/conf
	chmod 755 /usr/local/sunlight/conf
fi

if [ $base_server_role -eq 1 ];then
	cp "$opt_path/scripts/weedfs_backup.sh"  "/root/bin/weedfs_backup"
	chmod +x /root/bin/weedfs_backup
	echo "35 9 * * * root flock -xn /tmp/weedfsbackup.lock -c '/usr/bin/sh /root/bin/weedfs_backup > /dev/null  2>&1'" \
	>> /etc/cron.d/sunlight-backup
	chmod 644 /etc/cron.d/sunlight-backup
else
	send_info ">>>>>>>> This server need not to install weedfs_backup script, skip..."
	echo "-----------------------------------------------------------------------------"
	sleep 2
fi