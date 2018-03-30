#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/gofile"
fi



PROC_LIST="/usr/local/sunlight/proc_list"


function outputbr()
{
	if [ ${1} -lt 1 ];then
		echo "Error! Function Use Uncorrect!"
		exit 1
	fi
	
	for (( i=0; i<$1; i++))
	do
		echo -e "\n"
	done
}


function CheckSmon()
{
	if [ ! -f $PROC_LIST ]
	then
		touch $PROC_LIST
		chmod +x $PROC_LIST
		echo "root /usr/local/sunlight/go_file.sh /usr/bin/sh /usr/local/sunlight/go_file.sh &" > $PROC_LIST
	else
		FOUND=`grep '/usr/local/sunlight/go_file.sh' $PROC_LIST | wc -l`
		if [ $FOUND -eq 0 ]
		then
			echo "root /usr/local/sunlight/go_file.sh /usr/bin/sh /usr/local/sunlight/go_file.sh &" >> $PROC_LIST
		fi    
	fi

	pkill -9 smon
	/usr/local/sunlight/smon -f /usr/local/sunlight/proc_list
}

if [ -f "/usr/local/sunlight/conf/app_node.ini" ];then
	rm -rf /usr/local/sunlight/conf/app_node.ini
fi

if [ -f "/usr/local/sunlight/conf/inotify_include.ini" ];then
	rm -rf /usr/local/sunlight/conf/inotify_include.ini
fi

if [ -z "$cluster_ip" ];then
	while True
	do
		echo "Please Input Three Application Node's Ip:"
		echo "Such As 192.168.88.71,192.168.88.72,192.168.88.73"
		echo -n "Please Input:"
		read cluster_ip
		echo -n "Are You Sure?[y/n]"
		read go_sure
		if [ "go_sure" == "y" ] || [ "go_sure" == "Y" ];then
			break
		fi
	done
fi

app_count=0
cluster_ip_array=(${cluster_ip//,/ })
for c_ip in ${cluster_ip_array[@]}
do
	let app_count+=1
	echo "${c_ip}|应用节点${app_count}|${sp_name}|${ssh_port}|${server_role}" >> /usr/local/sunlight/conf/app_node.ini
done

if [ -f /usr/local/sunlight/conf/app_node.ini ];then
	chmod 0755 /usr/local/sunlight/conf/app_node.ini
fi

if [ -d /var/www/html/app/ ];then
	echo "/var/www/html/app/" >> /usr/local/sunlight/conf/inotify_include.ini
fi

if [ -d /var/www/html/iptv/ ];then
	echo "/var/www/html/iptv/" >> /usr/local/sunlight/conf/inotify_include.ini
fi

if [ -d /var/www/html/images/ ];then
	echo "/var/www/html/images/" >> /usr/local/sunlight/conf/inotify_include.ini
fi

if [ -d /var/www/html/slib/ ];then
	echo "/var/www/html/slib/" >> /usr/local/sunlight/conf/inotify_include.ini
fi

if [ -d /var/www/html/epgservice/ ];then
	echo "/var/www/html/epgservice/" >> /usr/local/sunlight/conf/inotify_include.ini
fi

if [ ! -f   /usr/local/sunlight/conf/inotify_include.ini ];then
	echo "/var/www/html/" >> /usr/local/sunlight/conf/inotify_include.ini
fi
chmod 0755  /usr/local/sunlight/conf/inotify_include.ini

echo "Check inotify Directory......"
if [ ! -d /usr/local/inotify ];then
  cp -rf "$opt_path/inotify"   /usr/local/
  chmod 0755 -R /usr/local/inotify
fi

sleep 2
outputbr 1

echo "Copy Ini Files To The Target Directory......"

cp -f "$opt_path/conf/go_file.sh"  /usr/local/sunlight/
cp -f "$opt_path/conf/stop_gofile.sh"  /usr/local/sunlight/

chmod 0755 /usr/local/sunlight/go_file.sh
chmod 0755 /usr/local/sunlight/stop_gofile.sh
chmod 0755 /usr/local/sunlight/conf/app_node.ini
chmod 0755 /usr/local/sunlight/conf/inotify_include.ini

CheckSmon

echo "Inotify And Rsync Modules Have Been Installed....."
echo "Run 'nohup sh /usr/local/sunlight/go_file.sh &'" 


