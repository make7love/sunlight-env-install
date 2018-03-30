<?php
	
/*

*CURL获取图片并存储到服务器本地指定目录

*@path 图片的URL地址（必须有jpg png jpeg gif等后缀）

*@file_dir 图片存储在服务器的地址

*/


function saveImage($url,$file_dir) {
	$ch = curl_init ($url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_BINARYTRANSFER,1);
	$img = curl_exec ($ch);
	curl_close ($ch);
	$file_name = str_replace("/","",substr($url,strrpos($url,"/")));
	$fp = fopen($file_dir.'/'.$file_name,'w');
	fwrite($fp, $img);
	fclose($fp);
}




function  write_file($dir,$content)
{
	$myfile = fopen($dir, "a+") or die("Unable to open file!");
	fwrite($myfile, $content);
	fwrite($myfile,"\n");
	fclose($myfile);
}


function send_request($url,$method="GET")
{
	$ch = curl_init();
	curl_setopt($ch,CURLOPT_URL,$url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	$output = curl_exec($ch);
	curl_close($ch);
}