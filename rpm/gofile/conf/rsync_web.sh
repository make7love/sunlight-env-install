#!/bin/bash

INOTIFY_EXCLUDE="/usr/local/sunlight/conf/inotify_include.ini"
LOGPATH="/var/log/sunlight/gofile/"
TIMESTAMP=$(date "+%Y-%m-%d_%H:%M:%S")
LOG="${LOGPATH}${TIMESTAMP}.access"
SSHKEY="/usr/local/sunlight/sshkeys/init.pk"
SSHUSER="root"
ssh_port=22
target_ip="192.168.88.134"

#check inotify file scan config file;
if [ ! -f $INOTIFY_EXCLUDE ];then
	echo "Error! GOFILE Config File Does Not Exist!"
	echo "GOFILE Config File : $INOTIFY_EXCLUDE"
	exit 1
fi

if [ ! -f /usr/local/inotify/bin/inotifywait ];then
	echo "Error! Inotify file does not exist."
	echo "Inotify Path: /usr/local/inotify/bin/inotifywait"
	exit 1
fi

#check path configed in INOTIFY_EXCLUDE exist.
cat $INOTIFY_EXCLUDE | while read con_path
do
	if [ $(echo $con_path | grep -P "^@") ];then
		rsync_check_path=${con_path##*@}
	else
		rsync_check_path=${con_path}
	fi
	
	if [ ! -d $rsync_check_path ];then
		echo "Error! $rsync_check_path Does Not Exist!"
		exit 1
	fi
done

if [ ! -d $LOGPATH ];then
	mkdir -p $LOGPATH
	chmod 777 -R $LOGPATH
fi

#kill inotify process
if [ $(ps -ef | grep "/usr/local/inotify/bin/inotifywait" | grep -v grep | wc -l) -gt 0 ];then
	ps -ef | grep "/usr/local/inotify/bin/inotifywait" | grep -v grep | awk '{print $2}' | xargs kill
fi

while true
do
	check_inotifywait=$(ps -ef | grep "/usr/local/inotify/bin/inotifywait" | grep -v grep | wc -l)
	if [ $check_inotifywait -lt 1 ];then
		/usr/local/inotify/bin/inotifywait -mrq -e modify,create,move,delete --timefmt '%Y/%m/%d %H:%M' --format '%T %w%f %e' --exclude "(.swp|.swx|.swpx|.log|~|4913)" --fromfile $INOTIFY_EXCLUDE | while read slt_date slt_time slt_file
		do
			echo "[ MESSAGE ] Files Notifed : ${slt_date} - ${slt_time} - ${slt_file}" >> $LOG
			sync_path_tmp=${slt_file%/*}
			sync_path=$sync_path_tmp"/"
			RSYNC_EXC_FILE=""
			rsync -avzt --progress --chmod=ugo=rwX $RSYNC_EXC_FILE --delete -e "ssh -o StrictHostKeyChecking=no -p ${ssh_port} -i ${SSHKEY}" ${sync_path} ${SSHUSER}@${target_ip}:${sync_path} >> $LOG
			echo "sync action end!" >> $LOG
		done
	fi
done


