#!/bin/bash
echo -n "Do You Want To Set A Hostname For This Server?[y/n]"
read OKToSetHostName
if [ "$OKToSetHostName" == "y" -o  "$OKToSetHostName" == "Y" ];then
	echo -n "Please Set A Hostname For This Server:"
	while read slthostname
	do
		if [ -n "$slthostname" ];then
			if [ `echo $slthostname | grep -E "^[A-Za-z0-9_-]+$"` ];then
				hostnamectl set-hostname "$slthostname"
				echo $SLT_SET_HOSTNAME_01
				Write_Log $SLT_SET_HOSTNAME_01
				break
			else
				echo "Error! A Hostname Must Match [A-Za-z0-9_-]"
				echo "Do You Want To Continue To Set Hostname?[y/n]"
				read set_host_name_continue
				if [ "$set_host_name_continue" != "y" -a "$set_host_name_continue" != "Y" ];then
					break
				else
					echo -n "Please Set A Hostname For This Server:"
				fi
			fi
		else
			echo "Please Input The Correct Hostname!"
			echo -n "Please Set A Hostname For This Server:"
		fi
	done
else
	echo $SLT_SET_HOSTNAME_02
fi