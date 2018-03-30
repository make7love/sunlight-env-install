#!/bin/bash

if [ ! -d /var/weedfs ];then
	mkdir /var/weedfs
	chmod 755 /var/weedfs
fi

if [ ! -d /var/log/sweed ];then
	mkdir /var/log/sweed
	chmod 755 /var/log/sweed
fi
echo "check and kill weed process..."
ps -ef | grep /usr/local/sunlight/weed | grep -v grep | xargs kill
sleep 1

echo "begin to start weed..."
nohup /usr/local/sunlight/weed -log_dir=/var/log/sweed/ server -ip server_private_ip -dataCenter sunlightDataCenter -rack sunlightRack01 \
-master.port=9333 -master.defaultReplicaPlacement=002 -dir=/var/weedfs -volume.port=8180 -volume.max=10 \
-volume.publicUrl=server_iptv_ip:8180  -master.peers=masterpeers >> /var/log/sweed/sweed_init.log 2>&1 &

if [ $? -eq 0 ];then
	echo "weed init success..."
else
	echo "weed init failed..."
fi
exit 0