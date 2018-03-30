#!/bin/bash

function CheckSelf()
{
	CHECK_GO_FILE=$(ps -ef | grep "go_file" | grep -v grep | wc -l)
	if [ $CHECK_GO_FILE -gt 0 ];then
		ps -ef|grep "go_file" | grep -v grep | awk '{print $2}' | while read go_pid
		do
			kill $go_pid
		done
	fi
}


function CheckInotify()
{
	#check process;
	CHECK_PRO=$(ps -ef | grep "inotifywait" | grep -v grep | wc -l)
	if [ $CHECK_PRO -gt 0 ];then
		ps -ef | grep "inotifywait" | grep -v grep | awk '{print $2}' | while read inotify_pid
		do
			kill $inotify_pid
		done
	fi
}

function CheckInotifyConf()
{
	#check inotify file scan config file;
	if [ ! -f $INOTIFY_EXCLUDE ];then
		echo "Error! GOFILE Config File Does Not Exist!"
		echo "GOFILE Config File : $INOTIFY_EXCLUDE"
		exit 1
	else
		cat $INOTIFY_EXCLUDE | while read fyLine
		do
			if [ $(echo $fyLine | grep -P "^@") ];then
				check_path=${fyLine##*@}
			else 
				check_path=$fyLine
			fi
			if [ ! -d $check_path ];then
					echo "Error! $check_path Does Not Exist!......"
					exit 1
			fi	
		done
	fi
}


CheckSelf
CheckInotify
