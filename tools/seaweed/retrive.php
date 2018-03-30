<?php

	error_reporting(E_ALL);
	date_default_timezone_set('PRC');
	set_time_limit(0);
	ignore_user_abort(true);

	fwrite(STDOUT,"\r\n");
	$date_tag = date("Y-m-d");
	$description = <<<EOD
		*************************************************************
				还原操作-使用说明：
		1. 需要使用root权限执行；
		2. 日志文件：/var/log/sunlight/weed_replica_retrive_{$date_tag}.log；
		3. php5.4+,开启PDO扩展；
		4. 备份的图片位置：./weed_image_backup/;
		*************************************************************
EOD;
	fwrite(STDOUT,$description);
    fwrite(STDOUT,"\r\n");
   	fwrite(STDOUT," one-还原单个fid   all-还原整个目录 请输入操作类型(one 或 all): ");
   	$action = trim(fgets(STDIN));
   	while(!in_array($action,array("one","all")))
   	{
   		fwrite(STDOUT,"\r\n");
   		fwrite(STDOUT," one-还原单个fid   all-还原整个目录 请输入正确的操作类型(one 或 all): ");
   		$action = trim(fgets(STDIN));
   	}

   	if($action == "one")
   	{
   		require "./retrive_one.php";
   	}else{
   		require "./retrive_all.php";
   	}
	