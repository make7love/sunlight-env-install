#!/bin/bash
SSH_PORT_DEFAULT=2222
if [ -z "$ssh_port" ];then
	ssh_port=$SSH_PORT_DEFAULT
fi

if [ -n "$ssh_port" ];then
	if [ -f /etc/ssh/sshd_config ];then
		cp /etc/ssh/ssh_config /etc/ssh/sshd_config.bak
		if [ $(grep -E '^Port[ ]*[0-9]+' /etc/ssh/sshd_config | wc -l) -gt 0 ];then
			sed -i "/^Port[ ]*[0-9]*/c\Port $ssh_port" /etc/ssh/sshd_config
		elif [ $(grep -E '^#Port[ ]*[0-9]+' /etc/ssh/sshd_config | wc -l) -gt 0 ]; then
			sed -i "/^#Port[ ] *[0-9]*/c\Port $ssh_port" /etc/ssh/sshd_config
		fi
		systemctl restart sshd.service
		echo " SSH Port Has Been Set To $ssh_port"
		echo "注意：ssh端口已经被更改,下次ssh连接要更换端口！"
	else
		echo "[ Error ] Error! change ssh port failed."
		Write_Log "[ Error ] /etc/ssh/sshd_config does not exit"
		exit 1
	fi
else
	echo "[ Error ] The variable ssh_port is empty."
	exit 1
fi