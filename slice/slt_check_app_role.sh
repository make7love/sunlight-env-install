#!/bin/bash
#检查应用节点的序列；
if [ "$server_role" == "2"];then
	slt_cluster_arr=(${cluster_ip//,/ })
	for((i=0; i<${#slt_cluster_arr[@]}; i++))
	do
		if [ ${slt_cluster_arr[i]}=="$server_ip" ];then
			echo -n "这是第${i+1}个应用节点."
		fi
	done
	echo "以上描述是否正确?"
	echo "The Description Above Is OK ? [y/n]:"
	read des_ok
	if [ $des_ok != "y" ] && [ $des_ok != "Y" ];then
		echo "配置文件错误，安装不能继续！"
		echo $SLT_ERR_SP_01
		Write_Log $SLT_ERR_SP_01
		exit 1
	fi
fi