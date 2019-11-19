-- MySQL dump 10.13  Distrib 5.6.42, for Linux (x86_64)
--
-- Host: localhost    Database: lingYunJunShi
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (9,'行军干粮','2019-03-03 10:18:28'),(10,'酷炫男表','2019-03-03 10:18:45'),(12,'衣物品饰','2019-03-03 10:21:24'),(13,'军品模型','2019-03-03 10:21:45'),(14,'军事背包','2019-03-03 10:22:00'),(25,'测试类目','2019-03-20 07:22:23'),(26,'测试类目2','2019-03-20 10:27:58');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
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
  PRIMARY KEY (`detail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderDetails`
--

LOCK TABLES `orderDetails` WRITE;
/*!40000 ALTER TABLE `orderDetails` DISABLE KEYS */;
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
  `user_openid` varchar(512) DEFAULT NULL,
  `user_name` varchar(32) NOT NULL,
  `order_status` tinyint(3) DEFAULT '1',
  `send_status` tinyint(3) DEFAULT '0',
  `comment_status` tinyint(3) DEFAULT '0',
  `order_amount` int(11) NOT NULL,
  `delivery_time` mediumtext,
  `pay_status` tinyint(3) NOT NULL DEFAULT '0',
  `user_phone` varchar(32) NOT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderSummary`
--

LOCK TABLES `orderSummary` WRITE;
/*!40000 ALTER TABLE `orderSummary` DISABLE KEYS */;
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
  `product_total` int(10) NOT NULL DEFAULT '1000',
  `category_type` int(10) NOT NULL,
  `limit_discounts` tinyint(3) NOT NULL DEFAULT '0',
  `product_carousel` tinyint(3) NOT NULL DEFAULT '0',
  `product_good` tinyint(3) NOT NULL DEFAULT '0',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (51,'钱包',10.00,10,'【纯手工纯皮】超薄真皮驾照夹零钱包','13891316148',0,1000,14,0,0,0,'2019-03-03 10:23:14'),(52,'腰包',99.00,10,'【小背包大智慧】轻翼双肩包','13891316148',0,1000,14,0,0,0,'2019-03-03 10:25:45'),(53,'四倍镜',3.00,10,'【吃鸡同款】固定4倍真光纤海螺观察镜','13891316148',0,1000,13,0,0,0,'2019-03-03 10:28:16'),(54,'铁铲模型',20.00,10,'【户外必备】多功能折叠锰钢铲','13891316148',0,1000,13,0,0,0,'2019-03-03 10:30:26'),(55,'酷炫牛仔',59.90,10,'【牛仔也战术】蝰蛇 IX7战术牛仔裤','13891316148',0,1000,12,0,0,0,'2019-03-03 10:32:03'),(56,'西部上衣',99.00,10,'【轻装上阵 防水防晒】UPF50+防晒，4级防泼水背包运动外套','13891316148',0,1000,12,0,0,0,'2019-03-03 10:34:04'),(57,'海鸥表',19.90,10,'【中国制造】海鸥飞行员系列皮带自动机械男表','13891316148',0,1000,10,0,0,0,'2019-03-03 10:36:29'),(58,'新时代军粮',23.30,10,'【新时代军粮】13式自发热食品','13891316148',0,1000,9,0,0,0,'2019-03-03 10:37:29');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_pic`
--

DROP TABLE IF EXISTS `product_pic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_pic` (
  `productId` int(11) NOT NULL,
  `pic1` varchar(512) DEFAULT NULL,
  `pic2` varchar(512) DEFAULT NULL,
  `pic3` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_pic`
--

LOCK TABLES `product_pic` WRITE;
/*!40000 ALTER TABLE `product_pic` DISABLE KEYS */;
INSERT INTO `product_pic` VALUES (51,'http://lyjs.wangtingting.top/FhWazhrOaLHdsHqfgzT-Njeppe_6','http://lyjs.wangtingting.top/FveV0xBuY6L-9arIqeao6o4zFLr7','http://lyjs.wangtingting.top/FiE8bC_9aDCCuVJTQQIMWGxhxZ9Q'),(52,'http://lyjs.wangtingting.top/FhXHfku_wSXYTYgx0L-FYDgY6SB7','http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG','http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV'),(53,'http://lyjs.wangtingting.top/Fn1dRctZITfBdE5mJWwL-8mG_6e1','http://lyjs.wangtingting.top/FucXxqQrSE8FWxczXBcU0VGXMVsX','http://lyjs.wangtingting.top/FrQ_n9Ct3PlPTM3LrrWXQ_0InW79'),(54,'http://lyjs.wangtingting.top/FgA9VphI78DpciCddwcIJLuP4quk','http://lyjs.wangtingting.top/FlR0hIYgKdMWI_uuVi0xgMm8mvqx','http://lyjs.wangtingting.top/FjExnULpMRSz0CEaQHjl3MuR9auF'),(55,'http://lyjs.wangtingting.top/FsWEw5n3azkOS8ZhbS7dEhKC7svj','http://lyjs.wangtingting.top/Fr7YJ2fpLKbMgp86UOsSfw2n5DI4','http://lyjs.wangtingting.top/Fj0vRd7UPE_rHfX5aFIRlCrI245B'),(56,'http://lyjs.wangtingting.top/FshtFT5uEvpDjEwJGUdzqg2zFla7','http://lyjs.wangtingting.top/FpYT5XFh6AIbkPyUqMG07zyqR9YO','http://lyjs.wangtingting.top/FgFOS3_8II-dXjoGgpZxLGLtodtk'),(57,'http://lyjs.wangtingting.top/FkWbDamxYM0UazX3QyYjkAtklFh5','http://lyjs.wangtingting.top/Fuwo_GAmwWSKUG-wwCacqy7kJJUT','http://lyjs.wangtingting.top/FjIXqBbLePpnyxUqhFZqQnJwuoOd'),(58,'http://lyjs.wangtingting.top/FjmgAWS2oarmMxyxfevPndZ1faiv','http://lyjs.wangtingting.top/FgyVi1wQD7VJf9XpKz1ThsYPNZOn','http://lyjs.wangtingting.top/Fl56PeSbTyXg-WpA-_ZGKxlHK6_q'),(59,'http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG','http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV','http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG'),(60,'http://lyjs.wangtingting.top/FsYJajvCBEswCoT87JvoxrtUznny','http://lyjs.wangtingting.top/Fo0DtyfVzCPoWpdo5hpLWdY9vr7N','http://lyjs.wangtingting.top/Fps2QN6Gediow66jqznliIdHea7c'),(61,'http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV','http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG','http://lyjs.wangtingting.top/FsYJajvCBEswCoT87JvoxrtUznny'),(62,'http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV','http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG','http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV'),(63,'http://lyjs.wangtingting.top/FsYJajvCBEswCoT87JvoxrtUznny','http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG','http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV'),(64,'http://lyjs.wangtingting.top/Fps2QN6Gediow66jqznliIdHea7c','http://lyjs.wangtingting.top/FrwGUG87Z64mC1eFd3QkiqkLTTgV','http://lyjs.wangtingting.top/FmYvvBS8xcz1vJ-ZhCbIGk0p9AzG'),(65,'http://lyjs.wangtingting.top/Fo5VNEMYjebVympOVgP_ZtQGfdU4','http://lyjs.wangtingting.top/FgT3XrC3LX65DGLFdvM3qM-wxrvw','http://lyjs.wangtingting.top/FjFsa9-sA7PMwh7O0V-sT1XNzxyB'),(66,'http://lyjs.wangtingting.top/Fo5VNEMYjebVympOVgP_ZtQGfdU4','http://lyjs.wangtingting.top/FgT3XrC3LX65DGLFdvM3qM-wxrvw','http://lyjs.wangtingting.top/FjFsa9-sA7PMwh7O0V-sT1XNzxyB');
/*!40000 ALTER TABLE `product_pic` ENABLE KEYS */;
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
  `user_address` varchar(512) DEFAULT NULL,
  `user_phone` int(20) DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usertable`
--

LOCK TABLES `usertable` WRITE;
/*!40000 ALTER TABLE `usertable` DISABLE KEYS */;
INSERT INTO `usertable` VALUES (3,'Curtin','omQFp5EPX4IPZm5o3DtqNV8gqJEY','https://wx.qlogo.cn/mmopen/vi_32/pktZLy8B9gBkcPBC1fO3D5IZUqvBYPrEicof1lYcyOPFyGjkEsv53ITiar7R0oruX5IYZCszwHXtMlJSmjBoCRzA/132',1,NULL,NULL,'2019-02-27 06:21:34'),(4,'不畏将来，不念过往','omQFp5E6hvaGFtOnL3C9oqJtgKFA','https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKZ32eNX0lgYxhUbJibpt0DmiapIdjFepicbLhB01icG47Yt80RA6N6np9NX8fRq58rddqyjglxCLnxRA/132',2,NULL,NULL,'2019-02-27 09:43:22'),(5,'开朗的男子','omQFp5OGB6sA1n_mGxXFoQqg4y0A','https://wx.qlogo.cn/mmopen/vi_32/IvvhKU2nGSeCRKqSMUJlGaco2GRgjrFM5LLiblfgncZ7qTghQBcSiaeice7eibngd4Fc8eE3gx6dicdbUglOWMClSWw/132',1,NULL,NULL,'2019-03-04 08:54:06'),(6,'cifici','omQFp5J1nO_qXXwYXNuaL10aHuQ4','https://wx.qlogo.cn/mmopen/vi_32/mXfY7bITuX1BkwL21t3wK9ljeSgiapJYEPFDE6a1waJsRZNzwZicX22xKSzicyLstLOHoicrST6SjdcJWDicTQBnM1Q/132',2,NULL,NULL,'2019-03-05 13:15:33'),(7,'老街男孩','omQFp5AnrkF__T_kKfD_masFJ21U','https://wx.qlogo.cn/mmopen/vi_32/qR378Aa3K9muCQQ6PqI0kQumnb6XWufE7GQbLuPfOlKAm5gdkN91IaG7Lbma0vuHDtibV2yT6nHh0VEoazcQ4eg/132',1,NULL,NULL,'2019-03-08 10:42:15'),(8,'Wisky Zh','omQFp5PPtUrkJ1J5X4tE8j2ZYB7Y','https://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqg55TOb6GHicNhakA8xK1YC2UlUEr7SU5G1QK9KSmWopZ6JeODwVVC8pkLP6KPFSJCM6BlZzObLag/132',1,NULL,NULL,'2019-03-19 12:37:36'),(9,'番茄','omQFp5LA_rDAfXETFoOGlE2iEWx4','https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIW8flaice5y3cJtBcmusKuDFztKrlYxUwuo8z71th8S5c2emTeiaTRQM7tGEjXskDyco3aDAY0htQQ/132',2,NULL,NULL,'2019-03-25 07:51:07'),(10,'taleyoung','omQFp5B9jMbJKfFkjp7eZu5ou5CI','https://wx.qlogo.cn/mmopen/vi_32/HtQQREzvoC0lmqltXe6qiaxo5pAH2yZMPJhzf6Nc5IdrNVibYn8vvrnoibbOicKEGibqTCTbpCic0ELf8xSMsyg48nlg/132',1,NULL,NULL,'2019-07-06 06:51:04'),(11,'沧桑','omQFp5GHO_KLUzXqTK0cNq_6LUUo','https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJuTqHbOvdF18YOwubT5FWKUECflibNbzxh5sQjmqY0O997g63OsUWWN9fvaRP1MibZCeag2aSIW6tA/132',1,NULL,NULL,'2019-07-19 03:41:01'),(12,'张怡君','omQFp5PISg731wZtp17P3uNVQFyE','https://wx.qlogo.cn/mmhead/Q2215ekjRb3dYXc3voOlnwTooNDeM0s0kBibHsph2aMA/132',0,NULL,NULL,'2019-10-31 08:53:02'),(13,'陈彦霞','omQFp5KVeGzHNxCzJDrWbs5yt-8k','https://wx.qlogo.cn/mmhead/FIXyyk7kSRh2FLYFibAceibaiaNMelkmlus6L0OTpDVRicM/132',0,NULL,NULL,'2019-11-16 06:51:30');
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

-- Dump completed on 2019-11-19 20:55:51
