-- MySQL dump 10.13  Distrib 5.6.42, for Linux (x86_64)
--
-- Host: localhost    Database: order_applet
-- ------------------------------------------------------
-- Server version	5.6.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(64) NOT NULL,
  `admin_pass` varchar(64) NOT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (2,'123321','123321','2018-11-21 13:45:38');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(32) NOT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'笔','2018-11-22 01:41:27'),(2,'车','2018-11-22 01:42:22'),(3,'水杯','2018-11-22 01:42:31'),(4,'书包','2018-12-05 07:53:11'),(5,'本子','2018-12-05 07:53:24'),(6,'水果','2018-12-06 14:36:46'),(7,'电脑','2018-12-08 06:33:33'),(8,'面','2018-12-08 06:34:04'),(9,'灯','2018-12-08 06:42:35'),(10,'玩具','2018-12-08 06:42:53');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_table`
--

DROP TABLE IF EXISTS `comment_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_table` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `quality_score` tinyint(3) NOT NULL DEFAULT '5',
  `taste_score` tinyint(3) NOT NULL DEFAULT '5',
  `packing_score` tinyint(3) NOT NULL DEFAULT '5',
  `product_id` varchar(32) NOT NULL,
  `user_openid` varchar(64) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `order_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_table`
--

LOCK TABLES `comment_table` WRITE;
/*!40000 ALTER TABLE `comment_table` DISABLE KEYS */;
INSERT INTO `comment_table` VALUES (3,4,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 01:44:37',35),(4,5,5,5,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 01:44:37',35),(5,5,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 01:55:57',35),(6,5,5,5,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 01:55:57',35),(7,5,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 02:41:14',35),(8,4,4,5,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 02:41:14',35),(9,5,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 02:43:30',35),(10,5,5,5,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 02:43:30',35),(11,5,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 04:45:16',36),(12,5,5,5,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 04:45:16',36),(13,5,5,5,'7','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 04:45:17',36),(14,4,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 05:33:56',38),(15,4,5,5,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 05:33:56',38),(16,4,5,5,'7','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 05:33:56',38),(17,5,4,5,'8','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 05:33:56',38),(18,4,5,5,'3','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 06:58:06',41),(19,5,3,5,'5','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 06:58:06',41),(20,5,2,5,'6','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 06:58:06',41),(21,5,5,5,'9','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 06:59:00',42),(22,5,5,5,'10','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 06:59:00',42),(23,5,5,5,'11','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 06:59:00',42),(24,5,5,5,'1','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 07:47:04',43),(25,5,5,4,'2','obNMb5EyU4uJYC-olxD0V4t8dYH8','2018-12-05 07:47:04',43);
/*!40000 ALTER TABLE `comment_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderDetails`
--

DROP TABLE IF EXISTS `orderDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orderDetails` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(32) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_quantity` int(11) NOT NULL,
  `seller_phone` varchar(32) NOT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `product_icon` varchar(512) NOT NULL,
  PRIMARY KEY (`detail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderDetails`
--

LOCK TABLES `orderDetails` WRITE;
/*!40000 ALTER TABLE `orderDetails` DISABLE KEYS */;
INSERT INTO `orderDetails` VALUES (27,37,1,'黑笔',5.40,1,'11111111111','2018-12-05 01:12:26','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(28,37,2,'红笔',3.50,1,'1111111111','2018-12-05 01:12:26','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(29,37,7,'大书包',45.00,1,'1111111111','2018-12-05 01:12:26','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(30,38,1,'黑笔',5.40,1,'11111111111','2018-12-05 01:27:39','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(31,38,2,'红笔',3.50,1,'1111111111','2018-12-05 01:27:40','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(32,38,7,'大书包',45.00,1,'1111111111','2018-12-05 01:27:40','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(33,38,8,'小书包',45.00,1,'1111111111','2018-12-05 01:27:40','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(34,39,2,'红笔',3.50,1,'1111111111','2018-12-05 01:28:14','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(35,40,1,'黑笔',5.40,1,'11111111111','2018-12-05 02:45:08','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(36,40,2,'红笔',3.50,1,'1111111111','2018-12-05 02:45:08','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(37,41,3,'黑车',200.00,1,'1111111111','2018-12-05 06:57:42','http://m1.auto.itc.cn/c_zoom,w_300/29364500.JPG'),(38,41,5,'大水杯',45.00,1,'1111111111','2018-12-05 06:57:42','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(39,41,6,'小水杯',45.00,1,'1111111111','2018-12-05 06:57:42','http://m1.auto.itc.cn/c_zoom,w_300/29364500.JPG'),(40,42,9,'大本子',45.00,1,'1111111111','2018-12-05 06:58:46','http://m1.auto.itc.cn/c_zoom,w_300/29364500.JPG'),(41,42,10,'小本子',45.00,1,'1111111111','2018-12-05 06:58:46','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(42,42,11,'小本子',45.00,1,'1111111111','2018-12-05 06:58:46','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(43,43,1,'黑笔',5.40,1,'11111111111','2018-12-05 07:46:36','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG'),(44,43,2,'红笔',3.50,1,'1111111111','2018-12-05 07:46:36','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG'),(45,44,10,'小本子',45.00,1,'1111111111','2018-12-05 09:56:05','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG');
/*!40000 ALTER TABLE `orderDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderSummary`
--

DROP TABLE IF EXISTS `orderSummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orderSummary` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_address` varchar(512) DEFAULT NULL,
  `user_openid` mediumtext,
  `user_name` varchar(32) NOT NULL,
  `order_status` tinyint(3) DEFAULT '0',
  `order_amount` int(11) NOT NULL,
  `delivery_time` mediumtext,
  `pay_status` tinyint(3) NOT NULL,
  `user_phone` varchar(32) NOT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment_status` tinyint(3) DEFAULT '0',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderSummary`
--

LOCK TABLES `orderSummary` WRITE;
/*!40000 ALTER TABLE `orderSummary` DISABLE KEYS */;
INSERT INTO `orderSummary` VALUES (37,'高桥','obNMb5EyU4uJYC-olxD0V4t8dYH8','望月',0,54,'1543939932000',0,'111111111111','2018-12-05 01:12:25',0),(38,'高桥','obNMb5EyU4uJYC-olxD0V4t8dYH8','望月',0,99,'1543940832000',1,'111111111111','2018-12-05 05:33:56',1),(39,'高桥','obNMb5EyU4uJYC-olxD0V4t8dYH8','望月',0,4,'1543940832000',0,'111111111111','2018-12-05 01:28:14',0),(40,'高桥','obNMb5EyU4uJYC-olxD0V4t8dYH8','望月',0,9,'1543941852000',0,'111111111111','2018-12-05 02:45:07',0),(41,'q','obNMb5EyU4uJYC-olxD0V4t8dYH8','1',0,290,'1543942632000',1,'qw','2018-12-05 06:58:06',1),(42,'q','obNMb5EyU4uJYC-olxD0V4t8dYH8','1',0,135,'1543942632000',1,'qw','2018-12-05 06:59:00',1),(43,'q','obNMb5EyU4uJYC-olxD0V4t8dYH8','1',0,9,'1543941972000',1,'qw','2018-12-05 07:47:04',1),(44,'q','obNMb5EyU4uJYC-olxD0V4t8dYH8','1',0,45,'1544007312000',1,'qw','2018-12-05 09:56:21',0);
/*!40000 ALTER TABLE `orderSummary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(64) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_sales` int(10) DEFAULT '10',
  `product_description` varchar(512) NOT NULL,
  `seller_phone` varchar(32) NOT NULL,
  `product_status` tinyint(3) DEFAULT '0',
  `category_type` int(10) NOT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `product_icon` varchar(512) NOT NULL,
  `product_score` int(11) DEFAULT '5',
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (5,'大',45.00,10,'圣诞节使得即使对方的方式都是','1111111111',0,1,'2019-01-27 10:34:14','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG',5),(6,'小水',45.00,10,'圣诞节使得即使对方的方式','1111111111',0,6,'2019-01-27 10:34:32','http://m1.auto.itc.cn/c_zoom,w_300/29364500.JPG',1),(8,'小书包',45.00,10,'圣诞节使得即使对方的方式都是','1111111111',0,4,'2018-12-03 14:30:10','http://m1.auto.itc.cn/c_zoom,w_300/29365544.JPG',5),(9,'大本子',8.00,10,'圣诞节使得即使对方的方式都是','1111111111',0,5,'2018-12-05 07:30:29','http://m1.auto.itc.cn/c_zoom,w_300/29364500.JPG',4),(10,'小本子',45.00,10,'圣诞节使得即使对方的方式都是','1111111111',0,5,'2018-12-03 14:30:10','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG',5),(13,'黑笔',5.40,10,'圣诞节使得即使对方的方式','11111111111',0,5,'2018-12-23 06:47:35','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG',5),(14,'黑笔',50.00,10,'圣诞节使得即使对方的方式都是','11111111111',0,1,'2018-12-08 03:25:27','http://m1.auto.itc.cn/c_zoom,w_300/29366936.JPG',5),(16,'小米',3000.00,10,'比较好的牌子','18123781239',0,0,'2019-02-03 01:39:05','http://img.wangtingting.top/Fo0DtyfVzCPoWpdo5hpLWdY9vr7N',5),(17,'神舟',3344.00,10,'很好','21232123123',0,0,'2019-02-03 01:39:30','http://img.wangtingting.top/Fps2QN6Gediow66jqznliIdHea7c',5),(18,'小车',23.00,10,'啊实打实的啊实打实的阿斯顿啊','12321312312',0,2,'2019-02-03 02:05:46','http://img.wangtingting.top/FsYJajvCBEswCoT87JvoxrtUznny',5),(19,'请问',123.00,10,'去问问','请问请问',0,2,'2019-02-03 02:06:27','http://img.wangtingting.top/Fuwb1LoIKwATfEkfTpOUSqkavz0V',5),(20,'qw',213.00,10,'qw','12323213213',0,2,'2019-02-03 02:04:14','http://img.wangtingting.top/FtxD30ZXVDQhR0iEeCtHFd4JzxQP',5),(21,'小水杯',123.00,10,'哈的贺卡上的','123123123123',0,3,'2019-02-03 02:11:24','http://img.wangtingting.top/FtxD30ZXVDQhR0iEeCtHFd4JzxQP',5),(22,'小水杯',123.00,10,'哈的贺卡上的','123123123123',0,7,'2019-02-03 02:12:06','http://img.wangtingting.top/FtxD30ZXVDQhR0iEeCtHFd4JzxQP',5),(24,'灯',123.00,10,'哈的贺卡上的','123123123123',0,9,'2019-02-03 02:13:05','http://img.wangtingting.top/FtxD30ZXVDQhR0iEeCtHFd4JzxQP',5),(25,'玩具',123.00,10,'哈的贺卡上的','123123123123',0,10,'2019-02-03 02:13:15','http://img.wangtingting.top/FtxD30ZXVDQhR0iEeCtHFd4JzxQP',5);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usertable`
--

DROP TABLE IF EXISTS `usertable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usertable` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(512) NOT NULL,
  `user_openid` varchar(512) NOT NULL,
  `user_icon` varchar(512) DEFAULT NULL,
  `user_gender` tinyint(3) NOT NULL,
  `user_address` varchar(512) NOT NULL,
  `user_phone` varchar(32) NOT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usertable`
--

LOCK TABLES `usertable` WRITE;
/*!40000 ALTER TABLE `usertable` DISABLE KEYS */;
INSERT INTO `usertable` VALUES (11,'王婷婷','obNMb5EyU4uJYC-olxD0V4t8dYH8','https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJETicLRoSbVibOW94rDKMoVN4caiaYyRZN3RLF7icYYaiblqDPEeoCBuhNBiaOrhQcOibD3FI5DrI8ky7wA/132',2,'陕西省西安市长安区滦镇高桥泉子头村','18710959261','2019-03-15 07:16:38');
/*!40000 ALTER TABLE `usertable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-19 20:56:29
