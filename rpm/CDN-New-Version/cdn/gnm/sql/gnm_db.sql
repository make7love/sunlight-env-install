
create database if not exists `cdn_gnm`;

USE `cdn_gnm`;


CREATE TABLE `gnm_cid` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cid` INT NOT NULL,
  `code` VARCHAR(32)  NOT NULL,
  `name` VARCHAR(32) NOT NULL,
  `url` VARBINARY(1024) NOT NULL,
  `prior` SMALLINT  NOT NULL,
  `copy` SMALLINT   NOT NULL,
  `duration` INT UNSIGNED DEFAULT 0,
  `relationid` VARCHAR(32) NOT NULL,
  `createtime` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`cid`),
  INDEX (`copy`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

CREATE TABLE `cid_nm` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cid` INT NOT NULL,
  `nmid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX (nmid),
  INDEX (cid, nmid)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

