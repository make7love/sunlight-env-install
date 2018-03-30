#!/bin/bash
if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/weed"
fi

if [ ! -d /usr/local/sunlight ];then
	mkdir /usr/local/sunlight
	chmod 755 /usr/local/sunlight
fi

weed_number=$(ps -ef| grep weed | grep -v grep | wc -l)
if [ $weed_number -gt 0 ];then
	ps -ef | grep weed | grep -v grep | awk '{print $2}' | xargs kill
fi

if [ $base_server_role -eq 2 ];then
	if [ -d /usr/local/sunlight ];then
		cp "$opt_path/weed/weed" /usr/local/sunlight/
		chmod +x /usr/local/sunlight/weed
	fi

	if [ ! -d /usr/local/sunlight/shell ];then
		mkdir /usr/local/sunlight/shell
		chmod 755 /usr/local/sunlight/shell
	fi

	cp "$opt_path/init_weed.sh"   /usr/local/sunlight/shell/


	sed -i "s/server_private_ip/$app_private_ip/"   /usr/local/sunlight/shell/init_weed.sh
	sed -i "s/server_iptv_ip/$app_iptv_ip/"   /usr/local/sunlight/shell/init_weed.sh

	weed_peer_str=""
	weed_peer_split=""
	for((i=0; i<$base_epg_server_number; i++))
	do
		weed_inct=$(echo "$i+1" | bc)
		current_weed_ip=$(echo $app_cluster_private_ip | cut -d ',' -f $weed_inct)
		if [ "$current_weed_ip" != "$app_private_ip" ];then
			weed_peer_str="$weed_peer_str$weed_peer_split${current_weed_ip}:9333"
			weed_peer_split=","
		fi
	done
	if [ -n  "$weed_peer_str" ];then
		sed -i "s/masterpeers/$weed_peer_str/"   /usr/local/sunlight/shell/init_weed.sh
	fi

	chmod +x /usr/local/sunlight/shell/init_weed.sh
	sh /usr/local/sunlight/shell/init_weed.sh 

	if [ -f /root/.bashrc ];then
		if [ $(grep ckweed /root/.bashrc | wc -l) -lt 1 ];then
			echo "alias ckweed='curl 127.0.0.1:9333/dir/status?pretty=y'" >> /root/.bashrc
		fi
	else
		echo "alias ckweed='curl 127.0.0.1:9333/dir/status?pretty=y'" >> /root/.bashrc
	fi
	
	if [ -f /usr/local/sunlight/proc_list ];then
		sed -i '$a\root /usr/local/sunlight/weed /usr/bin/sh /usr/local/sunlight/shell/init_weed.sh'  /usr/local/sunlight/proc_list
	fi

	send_success "`date "+%Y/%m/%d %H:%M:%S"` weed install finished..."
	send_info "------------------------------------------"

elif [ $base_server_role -eq 4 ]; then
	if [ -d /usr/local/sunlight ];then
		cp "$opt_path/weed/weed" /usr/local/sunlight/
		chmod +x /usr/local/sunlight/weed
	fi

	if [ ! -d /usr/local/sunlight/shell ];then
		mkdir /usr/local/sunlight/shell
		chmod 755 /usr/local/sunlight/shell
	fi

	cp "$opt_path/init_weed.sh"   /usr/local/sunlight/shell/

	sed -i "s/server_private_ip/$epg_private_ip/"   /usr/local/sunlight/shell/init_weed.sh
	sed -i "s/server_iptv_ip/$epg_iptv_ip/"   /usr/local/sunlight/shell/init_weed.sh

	weed_peer_str=""
	weed_peer_split=""
	for((i=0; i<$base_epg_server_number; i++))
	do
		weed_inct=$(echo "$i+1" | bc)
		current_weed_ip=$(echo $epg_cluster_private_ip | cut -d ',' -f $weed_inct)
		if [ "$current_weed_ip" != "$epg_private_ip" ];then
			weed_peer_str="$weed_peer_str$weed_peer_split${current_weed_ip}:9333"
			weed_peer_split=","
		fi
	done
	if [ -n  "$weed_peer_str" ];then
		sed -i "s/masterpeers/$weed_peer_str/"   /usr/local/sunlight/shell/init_weed.sh
	fi

	chmod +x /usr/local/sunlight/shell/init_weed.sh
	sh /usr/local/sunlight/shell/init_weed.sh 

	if [ -f /root/.bashrc ];then
		if [ $(grep ckweed /root/.bashrc | wc -l) -lt 1 ];then
			echo "alias ckweed='curl 127.0.0.1:9333/dir/status?pretty=y'" >> /root/.bashrc
		fi
	else
		echo "alias ckweed='curl 127.0.0.1:9333/dir/status?pretty=y'" >> /root/.bashrc
	fi

	if[ -f /usr/local/sunlight/proc_list ];then
		sed -i '$a\root /usr/local/sunlight/weed /usr/bin/sh /usr/local/sunlight/shell/init_weed.sh'  /usr/local/sunlight/proc_list
	fi
	
	send_success "`date "+%Y/%m/%d %H:%M:%S"` weed install finished..."
	send_info "------------------------------------------"

else
	send_info ">>>> This server need not to install weedfs, skipped..."
fi