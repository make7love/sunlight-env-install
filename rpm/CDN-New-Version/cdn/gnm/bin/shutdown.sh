#!/bin/sh
app_name=gnm_server
app_dir=/usr/local/sunlight/cdn/gnm/bin

#######################################
#currdatetime=`date '+%Y%m%d%H%M%S'`
#touch ./shutdown.$currdatetime
#######################################    

# try to kill the app_daemon process
app_daemon_id=$(ps -ef |grep $app_dir/app_daemon.sh |grep -v grep |awk '{print $2}')
echo try to stop the app_daemon process: kill -9 $app_daemon_id
kill -9 $app_daemon_id

# try to stop the start_app.sh
#start_app_id=$(ps -ef |grep $app_name |grep -v grep |awk '{print $3}')
#echo try to stop the start_app.sh : kill -9 $start_app_id
#kill -9 $start_app_id

echo try to stop the $app_name. kill -9 $(ps -ef |grep $app_name |grep -v grep |awk '{print $2}')
kill -9 $(ps -ef |grep ./$app_name |grep -v grep |awk '{print $2}')


