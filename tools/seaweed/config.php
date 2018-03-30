<?php 
	
	define("BACK_DIR","./weed_image_backup");

	use Medoo\Medoo;
	// 初始化配置
	// 
	$conf = "/usr/local/sunlight/conf/server.conf";
    if(file_exists($conf))
    {
    	$db_read = fopen($conf,'r');
    	$db_content = fread($db_read,filesize($conf));
    	fclose($db_read);
    	$db_conf = explode("\n",$db_content);
    	$db_conf = implode("&", $db_conf);
    	parse_str($db_conf);
    	
    }else{
    	fwrite(STDOUT,"数据库配置文件不存在，请检查！");
    	exit;
    }

    $dbname = "cdb20";
	$database = new Medoo([
		'database_type' => 'mysql',
		'database_name' => $dbname,
		'server' 		=> $dbhost,
		'port'			=> $dbport,
		'username' 		=> $dbuser,
		'password' 		=> $dbpass,
		'charset' 		=> 'utf8'
	]);