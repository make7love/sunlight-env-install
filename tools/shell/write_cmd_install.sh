#!/bin/bash

#生成快捷命令；
#
#

#d2u
echo "function d2u()" >> /root/.profile
echo "{"  >> /root/.profile
echo "   find . \\( -name \"*.sh\" -o -name \"*.py\" -o -name \"*.ini\" -o -name \"*.conf\" -o -name \"*.cnf\" -o -name \"*.sql\" \\) | xargs dos2unix" \
 >> /root/.profile
echo "}"  >> /root/.profile
echo "export d2u" >> /root/.profile


if [ "$base_server_role" == "1" ];then
	for((i=0; i<$base_epg_server_number; i++))
	do
		in_ct=$(echo "$i+1" | bc)
		app_ng=$(echo $manage_app_private_ip | cut -d ',' -f $in_ct)
		if [ $(grep "app${in_ct}" /root/.bashrc | wc -l) -ne 1 ];then
			echo "alias app${in_ct}='ssh -o StrictHostKeyChecking=no -p 2222 -i /usr/local/sunlight/sshkeys/init.pk ${app_ng}'" >> /root/.bashrc
		fi
	done
fi



