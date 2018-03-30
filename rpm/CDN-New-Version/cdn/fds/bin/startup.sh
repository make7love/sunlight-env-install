#!/bin/sh
ulimit -c unlimited
app_name=fds_server
app_dir=/usr/local/sunlight/cdn/fds/bin

#######################################
#currdatetime=`date '+%Y%m%d%H%M%S'`
#touch ./startup.$currdatetime
#######################################    

cd $app_dir

ps -ef |grep -v 'grep'|grep ./$app_name > /dev/null
if [ $? -eq 0 ]
  then
    echo $app_name is running. startup.sh should be exited.
    exit 1  
  else
    echo try to run app_daemon.sh
    $app_dir/app_daemon.sh &
    sleep 2
    exit 0
fi  

