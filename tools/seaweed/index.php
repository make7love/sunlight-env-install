<?php
	fwrite(STDOUT,"********seaweedfs备份还原工具**********");
   	fwrite(STDOUT,"\r\n");
   	fwrite(STDOUT," 1-备份   2-还原   3-导入    请输入操作类型(1,2,3): ");
   	$action = trim(fgets(STDIN));
   	while(!in_array($action,array(1,2)))
   	{
   		fwrite(STDOUT,"\r\n");
   		fwrite(STDOUT,"1-备份   2-还原  3-导入   请输入正确的操作类型(1,2,3):");
   		$action = trim(fgets(STDIN));
   	}

   	if($action == 1)
   	{
   		require './backup.php';
   	}else if($action == 2){
   		require './retrive.php';
   	}else{
         require './import.php';
      }


