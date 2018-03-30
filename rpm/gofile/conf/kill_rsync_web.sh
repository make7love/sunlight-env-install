#!/bin/bash

function CheckSelf()
{
	CHECK_GO_FILE=$(ps -ef | grep "rsync_web" | grep -v grep | wc -l)
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

CheckSelf
CheckInotify

