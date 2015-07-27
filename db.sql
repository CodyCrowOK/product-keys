-- Adminer 4.1.0 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';

DROP DATABASE IF EXISTS `yearbooks`;
CREATE DATABASE `yearbooks` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `yearbooks`;

DROP TABLE IF EXISTS `product_keys`;
CREATE TABLE `product_keys` (
  `key` int(10) unsigned NOT NULL,
  `used` tinyint(1) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- 2015-07-27 15:40:26
