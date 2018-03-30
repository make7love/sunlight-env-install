#!/bin/bash

if [ -z "$base_path" ];then
	base_path=$(cd `dirname $0`;pwd)
	opt_path="$base_path"
else
	opt_path="$base_path/rpm/app"
fi


APP_BIN_DIR="/usr/local/sunlight"
killall smon sagent
tar zxvf "$opt_path/app/app_pkg.tar.gz" -C $APP_BIN_DIR
chmod +x $APP_BIN_DIR"/smon"
chmod +x $APP_BIN_DIR"/sagent"
PROC_LIST=$APP_BIN_DIR"/proc_list"

if [ ! -f $PROC_LIST ]
then
	touch $PROC_LIST
	chmod +x $PROC_LIST
	echo "root /usr/local/sunlight/sagent /usr/local/sunlight/sagent -d" > $PROC_LIST
else
	FOUND=`grep '/usr/local/sunlight/sagent -d' $PROC_LIST | wc -l`
	if [ $FOUND -eq 0 ]
	then
		echo "root /usr/local/sunlight/sagent /usr/local/sunlight/sagent -d" >> $PROC_LIST
	fi    
fi

ret=$(grep '/usr/local/sunlight/smon' /etc/init.d/after.local |wc -l)
if ( test $ret -lt  1)
then
	echo "sudo /usr/local/sunlight/smon -f /usr/local/sunlight/proc_list" >> /etc/init.d/after.local
fi
echo "Start APP modules......"

sudo /usr/local/sunlight/smon -f /usr/local/sunlight/proc_list

sleep 3

echo "Start APP done!"