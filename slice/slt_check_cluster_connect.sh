#!/bin/bash

#检查集群子节点是否能够联通；

if [ -n "$cluster_ip" ];then
	slt_cluster_ip_array=(${cluster_ip//,/ })
	for slt_ip in ${slt_cluster_ip_array[@]}
	do
		ping -c 1 $slt_ip
		if [ $? -ne 0 ];then
			err="[ Error ] $slt_time_stamp Can Not Ping $slt_ip !"
			echo $err
			exit 1
		fi
	done
else
	echo "Error! String cluster_ip Is Empty,Please check!"
	exit 1
fi
