#!/usr/bin/env python
#-*- coding:utf-8 -*-

import logging
import os
import time
from email.mime.text import MIMEText
from email.utils import formataddr
import smtplib

smtp_server='smtp.exmail.qq.com'
smtp_user='SL-zabbix@sunlight-tech.com'
smtp_pass='SLzAbbix@2016'
smtp_receivor=[
					'chao.dong@sunlight-tech.com',
					'yetao.zheng@sunlight-tech.com',
					'tao.lin@sunlight-tech.com',
				#	'gavin.xie@sunlight-tech.com',
					'kang.li@sunlight-tech.com',
					'frank.zhou@sunlight-tech.com',
					'rico.li@sunlight-tech.com',
					'william.zeng@sunlight-tech.com'
				]
smtp_from	=["河南联通-商用环境-监控管理消息",'SL-zabbix@sunlight-tech.com']
smtp_to  	= ["Chao",'chao.dong@sunlight-tech.com']
smtp_title 	= "盛阳科技 - 运营商监控报警系统 - 通知消息"
time_format     =   "%Y-%m-%d %H:%M:%S"


send_mail_log	=	"/var/log/sunlight/monitor/send_mail_history.log"

def fire_email(html_msg):
	
	log_dir = os.path.dirname(send_mail_log)
	if not os.path.isdir(log_dir):
		os.makedirs(log_dir)
	logging.basicConfig(filename=send_mail_log,level=logging.INFO)
	log_time = time.strftime(time_format,time.localtime())
	
	
	send_msg = MIMEText(str(html_msg),'html','utf-8')
	send_msg['From'] = formataddr(smtp_from)
	send_msg['To'] = formataddr(smtp_to)
	send_msg['Subject'] = smtp_title
	try:
		email_server = smtplib.SMTP(smtp_server,25)
		email_server.login(smtp_user,smtp_pass)
		email_server.sendmail(smtp_user,smtp_receivor,send_msg.as_string())
		email_server.quit()
		logging.info("[ success ] - " + log_time + ' - ' + "[ mail content ] - "+str(html_msg))
	except smtplib.SMTPException:
		logging.error("[ failed ] - " + log_time + ' - ' + "[ mail content ] - "+str(html_msg))
		
