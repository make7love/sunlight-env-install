create database if not exists `cdn_nm`;
USE `cdn_nm`;

CREATE TABLE `nm_cid` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cid` INT NOT NULL,
  `code` VARCHAR(32) NOT NULL,
  `name` VARCHAR(32) NOT NULL,
  `prior` SMALLINT  NOT NULL,
  `copy` SMALLINT   NOT NULL,
  `duration` INT UNSIGNED DEFAULT 0,
  `accesscnt` INT DEFAULT 0,
  `accesstime` INT DEFAULT 0,
  `createtime` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`cid`),
  INDEX (`copy`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

CREATE TABLE `cid_ms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cid` INT NOT NULL,
  `msid` INT NOT NULL,
  `state` SMALLINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX (msid),
  INDEX (cid, msid)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';
