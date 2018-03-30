<?php
	
	error_reporting(E_ALL);
	date_default_timezone_set('PRC');
	set_time_limit(0);
	ignore_user_abort(true);

	$date_tag = date("Y-m-d");
	$description = <<<EOD

		*************************************************************
				备份操作-使用说明：
		1. 需要使用root权限执行；
		2. 日志文件：/var/log/sunlight/weed_replica_backup_{$date_tag}.log；
		3. php5.4+,开启PDO扩展；
		4. 备份的图片位置：./weed_image_backup/{$date_tag};
		*************************************************************
EOD;

	require './vendor/autoload.php';
	require './micjohnson/weed-php/test/autoload.php';

	use Monolog\Logger;
	use Monolog\Handler\StreamHandler;
	use Monolog\Handler\FirePHPHandler;
	

	require './config.php';
	require './tool.php';
	
	fwrite(STDOUT,$description);
    print_r("\r\n");
    sleep(3);
   

	// 创建日志频道
	if(!is_dir("/var/log/sunlight"))
	{
		if(!mkdir("/var/log/sunlight"))
		{
			fwrite(STDOUT,"创建/var/log/sunlight目录失败！");
			exit;
		}
		chmod("/var/log/sunlight",0777);
	}
	$log = new Logger('ReplicaImage');
	$log->pushHandler(new StreamHandler('/var/log/sunlight/'.'weed_replica_backup_'.date('Y-m-d').'.log', Logger::INFO));


	//显示数据摘要；
	$count = $database->count("imageauditlist", [
		"imageurl[~]" => "imgfs/weed"
	]);
	echo "数据库中共有记录：{$count} 条！";
	echo "\r\n";

	$datas = $database->select("imageauditlist", [
	"imageid",
    "imageurl",
    "userid",
	"tag",
	"status",
	"scope",
	"createtime"
	]);
	

	if(!is_dir("./weed_image_backup"))
	{
		if($t = mkdir("./weed_image_backup"))
		{
			chmod("./weed_image_backup",0777);
			if(!is_dir("./weed_image_backup/".date("Y-m-d")))
			{
				if($c = mkdir("./weed_image_backup/".date("Y-m-d")))
				{
					chmod("./weed_image_backup/".date("Y-m-d"),0777);
				}else{
					print_r(". p/".date("Y-m-d")."目录创建失败！");
					exit;
				}
			}
		}else{
			print_r("创建weed_image_backup目录失败！");
			exit;
		}
	}
	
	$record_list 	=	1;
	foreach($datas as $data)
	{
		if(strpos($data['imageurl'],"weed") > 0)
		{
			try{
				$data["imageurl"] = preg_replace("/182.247.239.156/", "192.168.88.192", $data["imageurl"]);

				echo "url:".$data["imageurl"];

				saveImage($data["imageurl"],"./weed_image_backup/".date("Y-m-d"));
				$fid = str_replace("/","",substr($data["imageurl"],strrpos($data["imageurl"],"/")));
				$log->addInfo('****'.$data['imageid'].'|'.$data['imageurl'].'|'.$fid.'|'.$data['userid'].'|'.$data['tag'].'|'.$data['status'].'|'.$data['scope'].'|'.$data['createtime']."****");
				echo "共有记录 {$count} 条，第 ".$record_list." 条：\r\n";
				echo "imageid:".$data['imageid'].'   '.$data['imageurl']."      download...";
				echo "\r\n";
			}catch(Exception $e){
				print_r($e->getMessage);
				exit;
			}
			$record_list++;
		}
	}

	echo "================================\r\n";
	echo "数据更新完毕~！\r\n";
	echo "日志文件:".'/var/log/sunlight/'.'weed_replica.log'.'_'.date('Y-m-d');
	echo date("Y-m-d");

	echo "\r\n";