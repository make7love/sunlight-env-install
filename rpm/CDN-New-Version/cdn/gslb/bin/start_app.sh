#!/bin/sh
app_name=gslb_server
app_dir=/usr/local/sunlight/cdn/gslb/bin

# add private library path
HlsLibPath=/opt/starview/cdn/hls/lib; export HlsLibPath
LD_LIBRARY_PATH=$HlsLibPath:$LD_LIBRARY_PATH;export LD_LIBRARY_PATH

# The execute file

cd $app_dir

EXEC_CMD=./$app_name

PARAM=$1
APP_PID=`ps -e -o pid,args | grep ./$app_name | grep -v grep | grep -v startup.sh | cut -b 1-6`

# Execute the program
if [ -n "$PARAM" ]; then
        if [ $PARAM = "-v" ]; then
        	$EXEC_CMD $1
        	exit 0
        else
			echo "Usage: start.sh  [-v]"
			exit 0
		fi        
else
		if [ ! -z "${APP_PID}" ]; then
			echo "hls has already started: " ${APP_PID}. " Please stop it first."
			exit 1
		fi
		
		ulimit -c unlimited
		nohup $EXEC_CMD &

fi

