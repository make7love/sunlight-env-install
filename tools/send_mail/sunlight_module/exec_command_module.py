#!/usr/bin/env python
#-*- coding:utf-8 -*-
#

import subprocess

def exec_command(shell_cmd):
	cmd_result = subprocess.check_output(shell_cmd,shell=True)
	return cmd_result

	