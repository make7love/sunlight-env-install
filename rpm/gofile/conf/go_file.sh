#!/bin/bash

INOTIFY_EXCLUDE="/usr/local/sunlight/conf/inotify_include.ini"
RSYNC_EXCLUDE="/tmp/slt_rsync_exclude.ini"
CONF="/usr/local/sunlight/conf/app_node.ini"
LOGPATH="/var/log/sunlight/gofile/"
TIMESTAMP=$(date "+%Y-%m-%d_%H:%M:%S")
LOG="${LOGPATH}${TIMESTAMP}.access"
SSHKEY="/usr/local/sunlight/sshkeys/init.pk"
SSHUSER="root"
regex="^\d+"

#注意：
#INOTIFY_EXCLUDE中的每一行必须以/结尾

#check process;
CHECK_PRO=$(ps -ef | grep inotify | grep -v grep | wc -l)

if [ $CHECK_PRO -gt 0 ];then
	echo "Error! Inotify Process Is Running,Please Check!"
	exit 1
fi


#check sshkey file;
if [ ! -f $SSHKEY ];then
	echo "Error! SSHKEY-FILE  Does Not Exist!"
	echo "SSHKEY FILE : $SSHKEY"
	exit 1
fi

#check inotify file scan config file;
if [ ! -f $INOTIFY_EXCLUDE ];then
	echo "Error! GOFILE Config File Does Not Exist!"
	echo "GOFILE Config File : $INOTIFY_EXCLUDE"
	exit 1
fi

#check directory in inotify config file 
cat $INOTIFY_EXCLUDE | while read con_path
do
	if [ $(echo $con_path | grep -P "^@") ];then
		rsync_check_path=${con_path##*@}
		if [ ! -d $rsync_check_path ];then
			echo "Error! $rsync_check_path Does Not Exist!"
			exit 1
		fi
	fi
done

#check sync node config file;
if [ ! -f $CONF ];then
	echo "Error! Application Node Config File Does Not Exist!"
	echo "File Path : $CONF"
	exit 1
fi

#check log path;
if [ ! -d $LOGPATH ];then
	mkdir -p $LOGPATH
	chmod 0755 $LOGPATH
fi



echo -e "\n"
echo -e "\n\n" >> $LOG
echo $TIMESTAMP"  GOFILE Start!" >> $LOG
echo "Config Node Info:{"  >> $LOG
cat $CONF | while read line
do
	if [ $(echo $line | grep -P $regex) ];then
		slt_node_ip=$(echo $line | awk -F '|' '{print $1}')
		CHECK_PING=$(ping -c 1 $slt_node_ip | grep ttl | wc -l)
		if [ $CHECK_PING -eq 1 ];then
			
			echo "$slt_node_ip is OK" >> $LOG
		else
			echo "Error! $slt_node_ip is Down!" >> $LOG
			echo "}" >> $LOG
			exit 1
		fi
	fi
done
echo "}" >> $LOG

while true
do
	check_inotifywait=$(ps -ef | grep "/usr/local/inotify/bin/inotifywait" | grep -v grep | wc -l)
	if [ $check_inotifywait -lt 1 ];then
		/usr/local/inotify/bin/inotifywait -mrq -e modify,create,move,attrib,delete --timefmt '%Y/%m/%d %H:%M' --format '%T %w%f %e' --exclude "(.swp|.swx|.swpx|.log|~|4913)" --fromfile $INOTIFY_EXCLUDE | while read slt_date slt_time slt_file
		do
			echo "[ MESSAGE ] Files Notifed : ${slt_date} - ${slt_time} - ${slt_file}" >> $LOG
			cat $CONF | while read line
			do
				sync_path_tmp=${slt_file%/*}
				sync_path=$sync_path_tmp"/"
				if [ -f $RSYNC_EXCLUDE ];then
						rm -rf $RSYNC_EXCLUDE
				fi
				#create exclude tmp file
				cat $INOTIFY_EXCLUDE | while read notifyLine
				do
					if [ $(echo $notifyLine | grep -P "^@") ];then
						rsync_exclude_path=${notifyLine##*@}
						if [ $(echo $rsync_exclude_path | grep $sync_path | wc -l) -eq 1 ];then
							rsync_exclude_d_tmp=${rsync_exclude_path##$sync_path}
							rsync_exclude_d_tmp_sec=${rsync_exclude_d_tmp%/*}
						fi
					fi
				done

				if [ $(echo $line | grep -P $regex) ];then
					node_ip=$(echo $line | awk -F '|' '{print $1}')
					node_type=$(echo $line | awk -F '|' '{print $5}')
					ssh_port=$(echo $line | awk -F '|' '{print $4}')
					
					if [ "$node_type" == "02" ];then
						if [ -f $RSYNC_EXCLUDE ];then
							RSYNC_EXC_FILE="--exclude-from=${RSYNC_EXCLUDE}"
						else
							RSYNC_EXC_FILE=""
						fi
						rsync -avzt --progress --chmod=ugo=rwX $RSYNC_EXC_FILE --delete -e "ssh -o StrictHostKeyChecking=no -p ${ssh_port} -i ${SSHKEY}" ${sync_path} ${SSHUSER}@${node_ip}:${sync_path} >> $LOG
						echo "sync action end!" >> $LOG
					fi
				fi
			done
			
		done
	fi
done
