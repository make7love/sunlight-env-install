use mysql;
INSERT INTO `user` SELECT '%','root','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','','N','N','',0.000000 FROM DUAL WHERE NOT EXISTS (SELECT * FROM user WHERE host='%' and user='root');
flush privileges;
