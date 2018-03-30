<?php

	error_reporting(E_ALL);
	date_default_timezone_set('PRC');
	set_time_limit(0);
	ignore_user_abort(true);


	require './vendor/autoload.php';
	require './micjohnson/weed-php/test/autoload.php';
	

	!defined("BACK_DIR") && exit("没有定义备份文件存放目录~！");

	use Monolog\Logger;
	use Monolog\Handler\StreamHandler;
	use Monolog\Handler\FirePHPHandler;

	// 创建日志频道
	$log = new Logger('ReplicaImage');
	$log->pushHandler(new StreamHandler('/var/log/sunlight/'.'weed_replica_retrive_'.date('Y-m-d').'.log', Logger::INFO));



	if(is_dir(BACK_DIR))
	{
		if ($back_dir = opendir(BACK_DIR)) {
			fwrite(STDOUT," 正在检查备份文件目录...............");
			fwrite(STDOUT,"\r\n");
			$i=0;
			$set_dir = array();
			fwrite(STDOUT,"/--------------");
			fwrite(STDOUT,"\r\n");
			while (($date_dir = readdir($back_dir)) !== false) 
			{
				if(preg_match("/\d{4}-\d{2}-\d{2}/",$date_dir))
				{
					$set_dir[] = $date_dir;
					fwrite(STDOUT,$date_dir);
					fwrite(STDOUT,"\r\n");
					$i++;
				}
			}
			fwrite(STDOUT,"--------------/");
			fwrite(STDOUT,"\r\n");
			if($i < 1){
				fwrite(STDOUT,"备份目录内没有符合要求的目录！");
				fwrite(STDOUT,"\r\n");
				fwrite(STDOUT,"即将退出.........");
				exit();
			}
			fwrite(STDOUT,"请输入需要还原的文件目录：");
			$import_dir = trim(fgets(STDIN));
			while(!in_array($import_dir,$set_dir))
			{
				fwrite(STDOUT,"输入错误，请输入上面搜索出的文件目录！");
				fwrite(STDOUT,"\r\n");
				fwrite(STDOUT,"等待输入：");
				$import_dir = trim(fgets(STDIN));
			}
			fwrite(STDOUT,"还原文件目录已选定：".$import_dir);
			fwrite(STDOUT,"\r\n");
			fwrite(STDOUT,"开始处理.............");
			sleep(1);

			fwrite(STDOUT,"请选择seaweedfs-master主节点读取方式,1-数据库,2-手动输入:");
			$input_type = trim(fgets(STDIN));
			while(!in_array($input_type,array(1,2)))
			{
				fwrite(STDOUT,"请输入1或2:");
				$input_type = trim(fgets(STDIN));
			}

			if($input_type == 1)
			{
				require './config.php';
				//读取seaweed服务主节点；
				$seaweed_server = $database->select("systemparameters","paramvalue",["paramname"=>"image_server_service_addr"]);
				if (empty($seaweed_server)){
					throw new Exception("数据库中未能查询到image_server_service_addr值！", 1);
					exit();
				} 
			}else{
				fwrite("\r\n");
				fwrite("请输入seaweedfs-master-IP地址：");
				$master_ip = trim(fgets(STDIN));
				while(!$master_ip)
				{
					fwrite("\r\n");
					fwrite("请输入seaweedfs-master-IP地址：");
					$master_ip = trim(fgets(STDIN));
				}
				$seaweed_server[] = $master_ip;
			}
			
			
			//解析IP
			$patterns = "/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/";
			preg_match($patterns, $seaweed_server[0], $ip);
			if (empty($ip))
			{
				throw new Exception("seaweed主节点IP解析错误,请检查您的输入数据！", 1);
				exit();
			}

			$s_server_ip =  $ip['0'];
			$s_server_service = $s_server_ip.":9333";
			$weedClient = new WeedPhp\Client($s_server_service);

			$file_path = BACK_DIR.'/'.$import_dir;
			
			if (is_dir($file_path)) {

				if ($dh = opendir($file_path)) {
					$count = 0;
					while (($file = readdir($dh)) !== false) {
						if(is_file($file_path.'/'.$file) && preg_match("/^\d{1,},\w{1,}$/",$file))
						{
							$count ++;
							fwrite(STDOUT,"\r\n");
							fwrite(STDOUT,"开始处理第".$count."个文件.....");
							fwrite(STDOUT,"\r\n");
							//根据fid查询publicurl地址；
							$fid = $file;
							$array_tmp = explode(',', $fid);
							$volumeid = $array_tmp['0'];
							$result = $weedClient->lookup($volumeid);
							$result = json_decode($result, true);

							if (!empty($result))
							{
								$weedurl = $result['locations']['0']['publicUrl'];
								
								//上传图片；
								$file = new \CurlFile($file_path.'/'.$file, 'image', $file);
								$result = $weedClient->store($weedurl, $fid, $file);
								$result = json_decode($result, true);
								if (!empty($result))
								{
									print_r($result);
									$log->addInfo(print_r($result,true));
									echo "\r\n";
								}
							}
						}
					} 
					closedir($dh);
				}else{
					echo BACK_DIR.'/'.$import_dir.":  目录不能读取，请检查！";
					exit();
				}
			}
			closedir($back_dir);
		}else{
			echo BACK_DIR.":  目录不能读取，请检查！";
			exit();
		}
	}else{
		echo BACK_DIR.":  文件备份位置不存在，请检查！";
		exit();
	}

