#!/bin/bash
#管理节点上的cluster_backup命令封装；


if [ -f /usr/local/sunlight/conf/spinfo.ini ];then
	while read line
	do
		if [ $(echo $line | grep "=" | wc -l) -eq 1 ];then
			eval "$line"
		fi
	done < /usr/local/sunlight/conf/spinfo.ini
else
	echo "[Error] /usr/local/sunlight/conf/spinfo.ini not found..."
	exit 1
fi

if [ -z "$cluster" ];then
	echo "[Error] cluster information is empty!"
	exit 1
fi

target_node=$(echo $cluster | cut -d ',' -f 1)
if [ -z "$target_node" ];then
	echo "[Error] target_node information is empty!"
	exit 1
fi

if [ ! -d /home/mysql ];then
	mkdir /home/mysql
	chown mysql:mysql /home/mysql
fi

ssh -o StrictHostKeyChecking=no -p 2222 -i /usr/local/sunlight/sshkeys/init.pk ${target_node} "cluster_backup"
if [ $? -eq 0 ];then
	rsync -avztgo -e "ssh -o StrictHostKeyChecking=no -p 2222 -i /usr/local/sunlight/sshkeys/init.pk"  ${target_node}:/home/mysql/   /home/mysql/
	chmod 755 -R /home/mysql
	if [ $? -eq 0 ];then
		echo "rsync success!"
		exit 0
	fi
fi

