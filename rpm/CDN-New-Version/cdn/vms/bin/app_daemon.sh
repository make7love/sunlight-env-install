#!/bin/sh
app_name=vms_server
app_dir=/usr/local/sunlight/cdn/vms/bin
tryCnt=0


echo start app_daemon

while true
do
  ps -ef |grep -v 'grep'|grep ./$app_name > /dev/null
  if [ $? -eq 0 ]
  then
  	if [ $tryCnt -eq 1 ]
  	then
   		echo start $app_name ok !
   	elif [ $tryCnt -gt 1 ]
   	then
    	echo restart $app_name ok !
   	fi
   	
    #let "tryCnt=0" 
    tryCnt=0
    sleep 1
    
  else
  	if [ $tryCnt -eq 0 ]
  	then
  		echo starting $app_name ...
  	else
  	  sleep 60
			echo restart $app_name tryCnt=$tryCnt ...
    fi
    
    pid=$(ps ax |grep ./$app_name |grep -v grep |awk '{print $1}')
    if [ ! -z $pid ]
    then 
    	echo kill -9 $pid
     	kill -9 $pid
  	fi
    
    cd $app_dir
    $app_dir/start_app.sh &
    
    #let "tryCnt+=1" 
    tryCnt=$(($tryCnt+1))
    sleep 1
fi

done
