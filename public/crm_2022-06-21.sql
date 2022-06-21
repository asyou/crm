# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.27)
# Database: crm
# Generation Time: 2022-06-21 06:38:13 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table cr_admin
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_admin`;

CREATE TABLE `cr_admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '昵称',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `salt` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码盐',
  `client_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '会话标识',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '电子邮箱',
  `loginfailure` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `logintime` int(10) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录IP',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(59) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Session标识',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';

LOCK TABLES `cr_admin` WRITE;
/*!40000 ALTER TABLE `cr_admin` DISABLE KEYS */;

INSERT INTO `cr_admin` (`id`, `username`, `nickname`, `password`, `salt`, `client_id`, `avatar`, `email`, `loginfailure`, `logintime`, `loginip`, `createtime`, `updatetime`, `token`, `status`)
VALUES
	(1,'admin','Admin','8afbf25a33b99f5301363a9f6a5ac157','7dfebd','7f0000010b5400000001','/assets/img/avatar.png','admin@admin.com',0,1655782430,'127.0.0.1',1491635035,1655782430,'195bc381-1ba8-456a-a01e-4c6d0636a5f8','online');

/*!40000 ALTER TABLE `cr_admin` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_admin_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_admin_log`;

CREATE TABLE `cr_admin_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `username` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '管理员名字',
  `url` varchar(1500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作页面',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '日志标题',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `ip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'User-Agent',
  `createtime` int(10) DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `name` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员日志表';



# Dump of table cr_area
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_area`;

CREATE TABLE `cr_area` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(10) DEFAULT NULL COMMENT '父id',
  `shortname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简称',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `mergename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '全称',
  `level` tinyint(4) DEFAULT NULL COMMENT '层级:1=省,2=市,3=区/县',
  `pinyin` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '拼音',
  `code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '长途区号',
  `zip` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮编',
  `first` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '首字母',
  `lng` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '经度',
  `lat` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '纬度',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='地区表';



# Dump of table cr_attachment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_attachment`;

CREATE TABLE `cr_attachment` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '类别',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '物理路径',
  `imagewidth` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '宽度',
  `imageheight` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '高度',
  `imagetype` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片类型',
  `imageframes` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '图片帧数',
  `filename` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '文件名称',
  `filesize` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文件大小',
  `mimetype` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'mime类型',
  `extparam` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '透传数据',
  `createtime` int(10) DEFAULT NULL COMMENT '创建日期',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `uploadtime` int(10) DEFAULT NULL COMMENT '上传时间',
  `storage` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '存储位置',
  `sha1` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '文件 sha1编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='附件表';

LOCK TABLES `cr_attachment` WRITE;
/*!40000 ALTER TABLE `cr_attachment` DISABLE KEYS */;

INSERT INTO `cr_attachment` (`id`, `category`, `admin_id`, `user_id`, `url`, `imagewidth`, `imageheight`, `imagetype`, `imageframes`, `filename`, `filesize`, `mimetype`, `extparam`, `createtime`, `updatetime`, `uploadtime`, `storage`, `sha1`)
VALUES
	(1,'',1,0,'/assets/img/qrcode.png','150','150','png',0,'qrcode.png',21859,'image/png','',1491635035,1491635035,1491635035,'local','17163603d0263e4838b9387ff2cd4877e8b018f6');

/*!40000 ALTER TABLE `cr_attachment` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_auth_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_auth_group`;

CREATE TABLE `cr_auth_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父组别',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '组名',
  `rules` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则ID',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分组表';

LOCK TABLES `cr_auth_group` WRITE;
/*!40000 ALTER TABLE `cr_auth_group` DISABLE KEYS */;

INSERT INTO `cr_auth_group` (`id`, `pid`, `name`, `rules`, `createtime`, `updatetime`, `status`)
VALUES
	(1,0,'Admin group','*',1491635035,1491635035,'normal'),
	(2,1,'普通管理组','1,6,8,9,13,14,15,16,17,18,19,20,21,22,29,30,31,32,33,34,35,47,48,49,50,51,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,149,151,2,5,150',1491635035,1654849180,'normal'),
	(3,2,'客服组','1,8,13,14,15,16,17,29,30,123,126,2',1654153920,1654849180,'normal'),
	(4,2,'销售组','1,8,13,14,15,16,17,35,92,93,102,103,104,112,113,149,151,2,150',1654483568,1654849221,'normal');

/*!40000 ALTER TABLE `cr_auth_group` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_auth_group_access
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_auth_group_access`;

CREATE TABLE `cr_auth_group_access` (
  `uid` int(10) unsigned NOT NULL COMMENT '会员ID',
  `group_id` int(10) unsigned NOT NULL COMMENT '级别ID',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限分组表';

LOCK TABLES `cr_auth_group_access` WRITE;
/*!40000 ALTER TABLE `cr_auth_group_access` DISABLE KEYS */;

INSERT INTO `cr_auth_group_access` (`uid`, `group_id`)
VALUES
	(1,1),
	(2,3),
	(3,4),
	(4,4);

/*!40000 ALTER TABLE `cr_auth_group_access` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_auth_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_auth_rule`;

CREATE TABLE `cr_auth_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('menu','file') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'file' COMMENT 'menu为菜单,file为权限节点',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父ID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规则名称',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图标',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规则URL',
  `condition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '条件',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `ismenu` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否为菜单',
  `menutype` enum('addtabs','blank','dialog','ajax') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '菜单类型',
  `extend` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '扩展属性',
  `py` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '拼音首字母',
  `pinyin` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '拼音',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `pid` (`pid`),
  KEY `weigh` (`weigh`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='节点表';

LOCK TABLES `cr_auth_rule` WRITE;
/*!40000 ALTER TABLE `cr_auth_rule` DISABLE KEYS */;

INSERT INTO `cr_auth_rule` (`id`, `type`, `pid`, `name`, `title`, `icon`, `url`, `condition`, `remark`, `ismenu`, `menutype`, `extend`, `py`, `pinyin`, `createtime`, `updatetime`, `weigh`, `status`)
VALUES
	(1,'file',0,'dashboard','主页','fa fa-dashboard','','','用于展示当前系统中的统计数据、统计报表及重要实时数据',1,'addtabs','','zy','zhuye',1491635035,1654854235,143,'normal'),
	(2,'file',0,'general','General','fa fa-cogs','','','',1,NULL,'','cggl','changguiguanli',1491635035,1491635035,137,'normal'),
	(3,'file',0,'category','Category','fa fa-leaf','','','Category tips',0,NULL,'','flgl','fenleiguanli',1491635035,1654499114,119,'normal'),
	(4,'file',0,'addon','Addon','fa fa-rocket','','','Addon tips',0,NULL,'','cjgl','chajianguanli',1491635035,1654416555,0,'normal'),
	(5,'file',0,'auth','权限管理','fa fa-key','','','',1,'addtabs','','qxgl','quanxianguanli',1491635035,1654583263,99,'normal'),
	(6,'file',2,'general/config','Config','fa fa-cog','','','Config tips',1,NULL,'','xtpz','xitongpeizhi',1491635035,1491635035,60,'normal'),
	(7,'file',2,'general/attachment','Attachment','fa fa-file-image-o','','','Attachment tips',1,NULL,'','fjgl','fujianguanli',1491635035,1491635035,53,'normal'),
	(8,'file',2,'general/profile','Profile','fa fa-user','','','',0,NULL,'','grzl','gerenziliao',1491635035,1654842132,34,'normal'),
	(9,'file',5,'auth/admin','Admin','fa fa-user','','','Admin tips',1,NULL,'','glygl','guanliyuanguanli',1491635035,1491635035,118,'normal'),
	(10,'file',5,'auth/adminlog','Admin log','fa fa-list-alt','','','Admin log tips',1,NULL,'','glyrz','guanliyuanrizhi',1491635035,1491635035,113,'normal'),
	(11,'file',5,'auth/group','Group','fa fa-group','','','Group tips',1,NULL,'','jsz','juesezu',1491635035,1491635035,109,'normal'),
	(12,'file',5,'auth/rule','Rule','fa fa-bars','','','Rule tips',1,NULL,'','cdgz','caidanguize',1491635035,1491635035,104,'normal'),
	(13,'file',1,'dashboard/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,136,'normal'),
	(14,'file',1,'dashboard/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,135,'normal'),
	(15,'file',1,'dashboard/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,133,'normal'),
	(16,'file',1,'dashboard/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,134,'normal'),
	(17,'file',1,'dashboard/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,132,'normal'),
	(18,'file',6,'general/config/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,52,'normal'),
	(19,'file',6,'general/config/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,51,'normal'),
	(20,'file',6,'general/config/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,50,'normal'),
	(21,'file',6,'general/config/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,49,'normal'),
	(22,'file',6,'general/config/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,48,'normal'),
	(23,'file',7,'general/attachment/index','View','fa fa-circle-o','','','Attachment tips',0,NULL,'','','',1491635035,1491635035,59,'normal'),
	(24,'file',7,'general/attachment/select','Select attachment','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,58,'normal'),
	(25,'file',7,'general/attachment/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,57,'normal'),
	(26,'file',7,'general/attachment/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,56,'normal'),
	(27,'file',7,'general/attachment/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,55,'normal'),
	(28,'file',7,'general/attachment/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,54,'normal'),
	(29,'file',8,'general/profile/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,33,'normal'),
	(30,'file',8,'general/profile/update','Update profile','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,32,'normal'),
	(31,'file',8,'general/profile/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,31,'normal'),
	(32,'file',8,'general/profile/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,30,'normal'),
	(33,'file',8,'general/profile/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,29,'normal'),
	(34,'file',8,'general/profile/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,28,'normal'),
	(35,'file',8,'general/profile/online','在线状态','fa fa-circle-o','','','',0,'addtabs','','zxzt','zaixianzhuangtai',1654396233,1654396233,0,'normal'),
	(36,'file',2,'general/crontab','定时任务','fa fa-tasks','','','按照设定的时间进行任务的执行,目前支持三种任务:请求URL、执行SQL、执行Shell。',1,NULL,'','dsrw','dingshirenwu',1654416537,1654416537,0,'normal'),
	(37,'file',36,'general/crontab/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1654416537,1654416537,0,'normal'),
	(38,'file',36,'general/crontab/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1654416537,1654416537,0,'normal'),
	(39,'file',36,'general/crontab/edit','编辑 ','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1654416537,1654416537,0,'normal'),
	(40,'file',36,'general/crontab/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1654416537,1654416537,0,'normal'),
	(41,'file',36,'general/crontab/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1654416537,1654416537,0,'normal'),
	(42,'file',3,'category/index','View','fa fa-circle-o','','','Category tips',0,NULL,'','','',1491635035,1491635035,142,'normal'),
	(43,'file',3,'category/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,141,'normal'),
	(44,'file',3,'category/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,140,'normal'),
	(45,'file',3,'category/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,139,'normal'),
	(46,'file',3,'category/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,138,'normal'),
	(47,'file',9,'auth/admin/index','View','fa fa-circle-o','','','Admin tips',0,NULL,'','','',1491635035,1491635035,117,'normal'),
	(48,'file',9,'auth/admin/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,116,'normal'),
	(49,'file',9,'auth/admin/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,115,'normal'),
	(50,'file',9,'auth/admin/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,114,'normal'),
	(51,'file',9,'auth/admin/getAdmins','加载用户','fa fa-circle-o','','','',0,'addtabs','','jzyh','jiazaiyonghu',1654505309,1654505309,0,'normal'),
	(52,'file',10,'auth/adminlog/index','View','fa fa-circle-o','','','Admin log tips',0,NULL,'','','',1491635035,1491635035,112,'normal'),
	(53,'file',10,'auth/adminlog/detail','Detail','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,111,'normal'),
	(54,'file',10,'auth/adminlog/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,110,'normal'),
	(55,'file',11,'auth/group/index','View','fa fa-circle-o','','','Group tips',0,NULL,'','','',1491635035,1491635035,108,'normal'),
	(56,'file',11,'auth/group/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,107,'normal'),
	(57,'file',11,'auth/group/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,106,'normal'),
	(58,'file',11,'auth/group/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,105,'normal'),
	(59,'file',12,'auth/rule/index','View','fa fa-circle-o','','','Rule tips',0,NULL,'','','',1491635035,1491635035,103,'normal'),
	(60,'file',12,'auth/rule/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,102,'normal'),
	(61,'file',12,'auth/rule/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,101,'normal'),
	(62,'file',12,'auth/rule/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,100,'normal'),
	(63,'file',4,'addon/index','View','fa fa-circle-o','','','Addon tips',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(64,'file',4,'addon/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(65,'file',4,'addon/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(66,'file',4,'addon/del','Delete','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(67,'file',4,'addon/downloaded','Local addon','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(68,'file',4,'addon/state','Update state','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(69,'file',4,'addon/config','Setting','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(70,'file',4,'addon/refresh','Refresh','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(71,'file',4,'addon/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(72,'file',0,'user','User','fa fa-user-circle','','','',0,NULL,'','hygl','huiyuanguanli',1491635035,1653380303,0,'normal'),
	(73,'file',72,'user/user','User','fa fa-user','','','',1,NULL,'','hygl','huiyuanguanli',1491635035,1491635035,0,'normal'),
	(74,'file',73,'user/user/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(75,'file',73,'user/user/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(76,'file',73,'user/user/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(77,'file',73,'user/user/del','Del','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(78,'file',73,'user/user/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(79,'file',72,'user/group','User group','fa fa-users','','','',1,NULL,'','hyfz','huiyuanfenzu',1491635035,1491635035,0,'normal'),
	(80,'file',79,'user/group/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(81,'file',79,'user/group/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(82,'file',79,'user/group/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(83,'file',79,'user/group/del','Del','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(84,'file',79,'user/group/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(85,'file',72,'user/rule','User rule','fa fa-circle-o','','','',1,NULL,'','hygz','huiyuanguize',1491635035,1491635035,0,'normal'),
	(86,'file',85,'user/rule/index','View','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(87,'file',85,'user/rule/del','Del','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(88,'file',85,'user/rule/add','Add','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(89,'file',85,'user/rule/edit','Edit','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(90,'file',85,'user/rule/multi','Multi','fa fa-circle-o','','','',0,NULL,'','','',1491635035,1491635035,0,'normal'),
	(91,'file',0,'customers','学生管理','fa fa-users','','','',0,'addtabs','','xsgl','xueshengguanli',1653898483,1654654681,0,'normal'),
	(92,'file',0,'customers/index','公海学生','fa fa-shopping-basket','','','',1,'addtabs','','ghxs','gonghaixuesheng',1653898483,1654685666,0,'normal'),
	(93,'file',92,'customers/index/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1653898483,1653900609,0,'normal'),
	(94,'file',92,'customers/index/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1653898483,1653900609,0,'normal'),
	(95,'file',92,'customers/index/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1653898483,1653900609,0,'normal'),
	(96,'file',92,'customers/index/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1653898483,1653900609,0,'normal'),
	(97,'file',92,'customers/index/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1653898483,1653900609,0,'normal'),
	(98,'file',92,'customers/index/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1653898483,1653900609,0,'normal'),
	(99,'file',92,'customers/index/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1653898483,1653900609,0,'normal'),
	(100,'file',92,'customers/index/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1653898483,1653900609,0,'normal'),
	(101,'file',92,'customers/index/batch','线索分配','fa fa-circle-o','','','',0,'dialog','','xsfp','xiansuofenpei',1653904340,1654050360,0,'normal'),
	(102,'file',92,'customers/index/claim','线索认领','fa fa-circle-o','','','',0,'addtabs','','xsrl','xiansuorenling',1654050306,1654050306,0,'normal'),
	(103,'file',0,'customers/customers','学生列表','fa fa-mortar-board','','','',1,'addtabs','','xslb','xueshengliebiao',1653898483,1654685728,0,'normal'),
	(104,'file',103,'customers/customers/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1653898483,1653900609,0,'normal'),
	(105,'file',103,'customers/customers/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1653898483,1653900609,0,'normal'),
	(106,'file',103,'customers/customers/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1653898483,1653900609,0,'normal'),
	(107,'file',103,'customers/customers/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1653898483,1653900609,0,'normal'),
	(108,'file',103,'customers/customers/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1653898483,1653900609,0,'normal'),
	(109,'file',103,'customers/customers/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1653898483,1653900609,0,'normal'),
	(110,'file',103,'customers/customers/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1653898483,1653900609,0,'normal'),
	(111,'file',103,'customers/customers/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1653898483,1653900609,0,'normal'),
	(112,'file',103,'customers/customers/claim','跟进记录','fa fa-circle-o','','','',0,'addtabs','','gjjl','genjinjilu',1654133117,1654133117,0,'normal'),
	(113,'file',103,'customers/customers/ocean','放回公海','fa fa-circle-o','','','',0,'addtabs','','fhgh','fanghuigonghai',1654566723,1654566723,0,'normal'),
	(114,'file',0,'customers/logs','跟进记录','fa fa-list-ol','','','',1,'addtabs','','gjjl','genjinjilu',1654068056,1654685768,0,'normal'),
	(115,'file',114,'customers/logs/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1654068056,1654068056,0,'normal'),
	(116,'file',114,'customers/logs/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1654068056,1654068056,0,'normal'),
	(117,'file',114,'customers/logs/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1654068056,1654068056,0,'normal'),
	(118,'file',114,'customers/logs/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1654068056,1654068056,0,'normal'),
	(119,'file',114,'customers/logs/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1654068056,1654068056,0,'normal'),
	(120,'file',114,'customers/logs/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1654068056,1654068056,0,'normal'),
	(121,'file',114,'customers/logs/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1654068056,1654068056,0,'normal'),
	(122,'file',114,'customers/logs/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1654068056,1654068056,0,'normal'),
	(123,'file',0,'customers/record','数据录入','fa fa-user-plus','','','',1,'addtabs','','sjlr','shujuluru',1653898483,1654685788,0,'normal'),
	(124,'file',123,'customers/record/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1653898483,1653900609,0,'normal'),
	(125,'file',123,'customers/record/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1653898483,1653900609,0,'normal'),
	(126,'file',123,'customers/record/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1653898483,1653900609,0,'normal'),
	(127,'file',123,'customers/record/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1653898483,1653900609,0,'normal'),
	(128,'file',123,'customers/record/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1653898483,1653900609,0,'normal'),
	(129,'file',123,'customers/record/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1653898483,1653900609,0,'normal'),
	(130,'file',123,'customers/record/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1653898483,1653900609,0,'normal'),
	(131,'file',123,'customers/record/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1653898483,1653900609,0,'normal'),
	(132,'file',0,'customers/traded','成交学生','fa fa-star','','','',1,'addtabs','','cjxs','chengjiaoxuesheng',1653898483,1654685822,0,'normal'),
	(133,'file',132,'customers/traded/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1653898483,1653900609,0,'normal'),
	(134,'file',132,'customers/traded/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1653898483,1653900609,0,'normal'),
	(135,'file',132,'customers/traded/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1653898483,1653900609,0,'normal'),
	(136,'file',132,'customers/traded/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1653898483,1653900609,0,'normal'),
	(137,'file',132,'customers/traded/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1653898483,1653900609,0,'normal'),
	(138,'file',132,'customers/traded/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1653898483,1653900609,0,'normal'),
	(139,'file',132,'customers/traded/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1653898483,1653900609,0,'normal'),
	(140,'file',91,'customers/notices','通知消息','fa fa-circle-o','','','',0,NULL,'','tzxx','tongzhixiaoxi',1654486120,1654581922,0,'normal'),
	(141,'file',140,'customers/notices/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1654486120,1654486120,0,'normal'),
	(142,'file',140,'customers/notices/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1654486120,1654486120,0,'normal'),
	(143,'file',140,'customers/notices/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1654486120,1654486120,0,'normal'),
	(144,'file',140,'customers/notices/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1654486120,1654486120,0,'normal'),
	(145,'file',140,'customers/notices/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1654486120,1654486120,0,'normal'),
	(146,'file',140,'customers/notices/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1654486120,1654486120,0,'normal'),
	(147,'file',140,'customers/notices/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1654486120,1654486120,0,'normal'),
	(148,'file',140,'customers/notices/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1654486120,1654486120,0,'normal'),
	(149,'file',103,'customers/customers/traded','线索成交','fa fa-circle-o','','','',0,'addtabs','','xscj','xiansuochengjiao',1654841636,1654841636,0,'normal'),
	(150,'file',0,'school','学校列表','fa fa-institution','','','',1,'addtabs','','xxlb','xuexiaoliebiao',1654848634,1654852695,0,'normal'),
	(151,'file',150,'school/index','查看','fa fa-circle-o','','','',0,NULL,'','zk','zhakan',1654848634,1654848634,0,'normal'),
	(152,'file',150,'school/recyclebin','回收站','fa fa-circle-o','','','',0,NULL,'','hsz','huishouzhan',1654848634,1654848634,0,'normal'),
	(153,'file',150,'school/add','添加','fa fa-circle-o','','','',0,NULL,'','tj','tianjia',1654848634,1654848634,0,'normal'),
	(154,'file',150,'school/edit','编辑','fa fa-circle-o','','','',0,NULL,'','bj','bianji',1654848634,1654848634,0,'normal'),
	(155,'file',150,'school/del','删除','fa fa-circle-o','','','',0,NULL,'','sc','shanchu',1654848634,1654848634,0,'normal'),
	(156,'file',150,'school/destroy','真实删除','fa fa-circle-o','','','',0,NULL,'','zssc','zhenshishanchu',1654848634,1654848634,0,'normal'),
	(157,'file',150,'school/restore','还原','fa fa-circle-o','','','',0,NULL,'','hy','huanyuan',1654848634,1654848634,0,'normal'),
	(158,'file',150,'school/multi','批量更新','fa fa-circle-o','','','',0,NULL,'','plgx','pilianggengxin',1654848634,1654848634,0,'normal');

/*!40000 ALTER TABLE `cr_auth_rule` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_category`;

CREATE TABLE `cr_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父ID',
  `type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '栏目类型',
  `name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `flag` set('hot','index','recommend') COLLATE utf8mb4_unicode_ci DEFAULT '',
  `image` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片',
  `keywords` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '关键字',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '描述',
  `diyname` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '自定义名称',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `weigh` (`weigh`,`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';



# Dump of table cr_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_config`;

CREATE TABLE `cr_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量名',
  `group` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分组',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
  `visible` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '可见条件',
  `value` text COLLATE utf8mb4_unicode_ci COMMENT '变量值',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '变量字典数据',
  `rule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '扩展属性',
  `setting` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '配置',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置';

LOCK TABLES `cr_config` WRITE;
/*!40000 ALTER TABLE `cr_config` DISABLE KEYS */;

INSERT INTO `cr_config` (`id`, `name`, `group`, `title`, `tip`, `type`, `visible`, `value`, `content`, `rule`, `extend`, `setting`)
VALUES
	(1,'name','basic','Site name','请填写站点名称','string','','CRM系统','','required','',NULL),
	(2,'beian','basic','Beian','粤ICP备15000000号-1','string','','','','','',NULL),
	(3,'cdnurl','basic','Cdn url','如果全站静态资源使用第三方云储存请配置该值','string','','','','','',''),
	(4,'version','basic','Version','如果静态资源有变动请重新配置该值','string','','1.0.1','','required','',NULL),
	(5,'timezone','basic','Timezone','','string','','Asia/Shanghai','','required','',NULL),
	(6,'forbiddenip','basic','Forbidden ip','一行一条记录','text','','','','','',NULL),
	(7,'languages','basic','Languages','','array','','{\"backend\":\"zh-cn\",\"frontend\":\"zh-cn\"}','','required','',NULL),
	(8,'fixedpage','basic','Fixed page','请尽量输入左侧菜单栏存在的链接','string','','dashboard','','required','',NULL),
	(9,'categorytype','dictionary','Category type','','array','','{\"default\":\"Default\",\"page\":\"Page\",\"article\":\"Article\",\"test\":\"Test\"}','','','',''),
	(10,'configgroup','dictionary','Config group','','array','','{\"basic\":\"Basic\",\"email\":\"Email\",\"dictionary\":\"Dictionary\",\"user\":\"User\",\"example\":\"Example\"}','','','',''),
	(11,'mail_type','email','Mail type','选择邮件发送方式','select','','1','[\"请选择\",\"SMTP\"]','','',''),
	(12,'mail_smtp_host','email','Mail smtp host','错误的配置发送邮件会导致服务器超时','string','','smtp.qq.com','','','',''),
	(13,'mail_smtp_port','email','Mail smtp port','(不加密默认25,SSL默认465,TLS默认587)','string','','465','','','',''),
	(14,'mail_smtp_user','email','Mail smtp user','（填写完整用户名）','string','','10000','','','',''),
	(15,'mail_smtp_pass','email','Mail smtp password','（填写您的密码或授权码）','string','','password','','','',''),
	(16,'mail_verify_type','email','Mail vertify type','（SMTP验证方式[推荐SSL]）','select','','2','[\"无\",\"TLS\",\"SSL\"]','','',''),
	(17,'mail_from','email','Mail from','','string','','10000@qq.com','','','',''),
	(18,'attachmentcategory','dictionary','Attachment category','','array','','{\"category1\":\"Category1\",\"category2\":\"Category2\",\"custom\":\"Custom\"}','','','',''),
	(19,'max_customers','basic','线索限制','每个销售同时跟进的最大线索数量','number','','30','','digits','','{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}'),
	(20,'offset_time','basic','提醒间隔','线索下一步跟进提醒的时间，注意是在这个时间之内，并非是精确的提前时间。','select','','600000','{\"300000\":\"5分钟\",\"600000\":\"10分钟\",\"900000\":\"15分钟\",\"1800000\":\"30分钟\",\"3600000\":\"1小时\",\"7200000\":\"2小时\"}','','','{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');

/*!40000 ALTER TABLE `cr_config` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_crontab
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_crontab`;

CREATE TABLE `cr_crontab` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` varchar(10) NOT NULL DEFAULT '' COMMENT '事件类型',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '事件标题',
  `content` text NOT NULL COMMENT '事件内容',
  `schedule` varchar(100) NOT NULL DEFAULT '' COMMENT 'Crontab格式',
  `sleep` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '延迟秒数执行',
  `maximums` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大执行次数 0为不限',
  `executes` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '已经执行的次数',
  `createtime` bigint(16) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) DEFAULT NULL COMMENT '更新时间',
  `begintime` bigint(16) DEFAULT NULL COMMENT '开始时间',
  `endtime` bigint(16) DEFAULT NULL COMMENT '结束时间',
  `executetime` bigint(16) DEFAULT NULL COMMENT '最后执行时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` enum('completed','expired','hidden','normal') NOT NULL DEFAULT 'normal' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='定时任务表';

LOCK TABLES `cr_crontab` WRITE;
/*!40000 ALTER TABLE `cr_crontab` DISABLE KEYS */;

INSERT INTO `cr_crontab` (`id`, `type`, `title`, `content`, `schedule`, `sleep`, `maximums`, `executes`, `createtime`, `updatetime`, `begintime`, `endtime`, `executetime`, `weigh`, `status`)
VALUES
	(1,'url','请求百度','https://www.baidu.com','* * * * *',0,0,0,1497070825,1501253101,1483200000,1830268800,1501253101,1,'normal'),
	(2,'sql','查询一条SQL','SELECT 1;','* * * * *',0,0,0,1497071095,1501253101,1483200000,1830268800,1501253101,2,'normal');

/*!40000 ALTER TABLE `cr_crontab` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_crontab_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_crontab_log`;

CREATE TABLE `cr_crontab_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `crontab_id` int(10) DEFAULT NULL COMMENT '任务ID',
  `executetime` bigint(16) DEFAULT NULL COMMENT '执行时间',
  `completetime` bigint(16) DEFAULT NULL COMMENT '结束时间',
  `content` text COMMENT '执行结果',
  `status` enum('success','failure') DEFAULT 'failure' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `crontab_id` (`crontab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='定时任务日志表';



# Dump of table cr_customers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_customers`;

CREATE TABLE `cr_customers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) DEFAULT NULL COMMENT '负责人',
  `created_id` int(11) NOT NULL COMMENT '创建人',
  `name` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客户网名',
  `contact` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系方式',
  `mobile` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号码',
  `source` tinyint(1) DEFAULT '0' COMMENT '客户来源:0=网报,1=线上咨询,2=其它',
  `trace_status` tinyint(1) DEFAULT '0' COMMENT '跟进状态:0=待跟进,1=电话访谈,2=微信沟通,3=QQ沟通,4=线下会面',
  `trace_status_info` int(11) DEFAULT '0' COMMENT '状态详情',
  `allot_status` tinyint(1) DEFAULT '0' COMMENT '分配状态:0=未分配,1=已分配',
  `last_admin_name` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上次负责人',
  `last_admin_change` int(11) DEFAULT NULL COMMENT '负责人变更',
  `entry_time` int(11) DEFAULT NULL COMMENT '流入时间',
  `note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `school_id` int(11) DEFAULT NULL COMMENT '报读学校',
  `course` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '报读专业',
  `degree` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '报读层次',
  `amount` decimal(9,2) DEFAULT '0.00' COMMENT '定位金',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态:0=未成交,1=已成交,2=已审核',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(11) DEFAULT NULL COMMENT '更新时间',
  `deletetime` int(11) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户列表';



# Dump of table cr_customers_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_customers_log`;

CREATE TABLE `cr_customers_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) NOT NULL COMMENT '负责人',
  `customers_id` int(11) NOT NULL COMMENT '客户ID',
  `trace_status` tinyint(1) DEFAULT NULL COMMENT '跟进状态:0=待跟进,1=电话访谈,2=微信沟通,3=QQ沟通,4=线下会面',
  `trace_status_info` int(11) DEFAULT '0' COMMENT '状态详情',
  `trace_note` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '跟进内容',
  `next_trace_note` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '下一步计划',
  `next_trace_time` int(11) DEFAULT NULL COMMENT '计划时间',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(11) DEFAULT NULL COMMENT '更新时间',
  `deletetime` int(11) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='跟进记录';



# Dump of table cr_ems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_ems`;

CREATE TABLE `cr_ems` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `event` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '事件',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '邮箱',
  `code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证码',
  `times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证次数',
  `ip` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'IP',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮箱验证码表';



# Dump of table cr_notices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_notices`;

CREATE TABLE `cr_notices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) NOT NULL COMMENT '负责人',
  `customers_id` int(11) NOT NULL COMMENT '客户ID',
  `msg` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '消息内容',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(11) DEFAULT NULL COMMENT '更新时间',
  `deletetime` int(11) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知消息';



# Dump of table cr_school
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_school`;

CREATE TABLE `cr_school` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态:1=正常,2=禁用',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(11) DEFAULT NULL COMMENT '更新时间',
  `deletetime` int(11) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学校列表';



# Dump of table cr_sms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_sms`;

CREATE TABLE `cr_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `event` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '事件',
  `mobile` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号',
  `code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证码',
  `times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证次数',
  `ip` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'IP',
  `createtime` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信验证码表';



# Dump of table cr_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_user`;

CREATE TABLE `cr_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '组别ID',
  `username` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '昵称',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `salt` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码盐',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像',
  `level` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `bio` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '格言',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
  `successions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '连续登录天数',
  `maxsuccessions` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '最大连续登录天数',
  `prevtime` int(10) DEFAULT NULL COMMENT '上次登录时间',
  `logintime` int(10) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录IP',
  `loginfailure` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '失败次数',
  `joinip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '加入IP',
  `jointime` int(10) DEFAULT NULL COMMENT '加入时间',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Token',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '状态',
  `verification` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证',
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `email` (`email`),
  KEY `mobile` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员表';

LOCK TABLES `cr_user` WRITE;
/*!40000 ALTER TABLE `cr_user` DISABLE KEYS */;

INSERT INTO `cr_user` (`id`, `group_id`, `username`, `nickname`, `password`, `salt`, `email`, `mobile`, `avatar`, `level`, `gender`, `birthday`, `bio`, `money`, `score`, `successions`, `maxsuccessions`, `prevtime`, `logintime`, `loginip`, `loginfailure`, `joinip`, `jointime`, `createtime`, `updatetime`, `token`, `status`, `verification`)
VALUES
	(1,1,'admin','admin','b87b94fd23942b2adb59c153e308d75e','235392','admin@163.com','13888888888','http://www.crm.hk/assets/img/avatar.png',0,0,'2017-04-08','',0.00,0,1,1,1491635035,1491635035,'127.0.0.1',0,'127.0.0.1',1491635035,0,1491635035,'','normal','');

/*!40000 ALTER TABLE `cr_user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_user_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_user_group`;

CREATE TABLE `cr_user_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '组名',
  `rules` text COLLATE utf8mb4_unicode_ci COMMENT '权限节点',
  `createtime` int(10) DEFAULT NULL COMMENT '添加时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `status` enum('normal','hidden') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员组表';

LOCK TABLES `cr_user_group` WRITE;
/*!40000 ALTER TABLE `cr_user_group` DISABLE KEYS */;

INSERT INTO `cr_user_group` (`id`, `name`, `rules`, `createtime`, `updatetime`, `status`)
VALUES
	(1,'默认组','1,2,3,4,5,6,7,8,9,10,11,12',1491635035,1491635035,'normal');

/*!40000 ALTER TABLE `cr_user_group` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_user_money_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_user_money_log`;

CREATE TABLE `cr_user_money_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更余额',
  `before` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更前余额',
  `after` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变更后余额',
  `memo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员余额变动表';



# Dump of table cr_user_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_user_rule`;

CREATE TABLE `cr_user_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) DEFAULT NULL COMMENT '父ID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '标题',
  `remark` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `ismenu` tinyint(1) DEFAULT NULL COMMENT '是否菜单',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) DEFAULT '0' COMMENT '权重',
  `status` enum('normal','hidden') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员规则表';

LOCK TABLES `cr_user_rule` WRITE;
/*!40000 ALTER TABLE `cr_user_rule` DISABLE KEYS */;

INSERT INTO `cr_user_rule` (`id`, `pid`, `name`, `title`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`)
VALUES
	(1,0,'index','Frontend','',1,1491635035,1491635035,1,'normal'),
	(2,0,'api','API Interface','',1,1491635035,1491635035,2,'normal'),
	(3,1,'user','User Module','',1,1491635035,1491635035,12,'normal'),
	(4,2,'user','User Module','',1,1491635035,1491635035,11,'normal'),
	(5,3,'index/user/login','Login','',0,1491635035,1491635035,5,'normal'),
	(6,3,'index/user/register','Register','',0,1491635035,1491635035,7,'normal'),
	(7,3,'index/user/index','User Center','',0,1491635035,1491635035,9,'normal'),
	(8,3,'index/user/profile','Profile','',0,1491635035,1491635035,4,'normal'),
	(9,4,'api/user/login','Login','',0,1491635035,1491635035,6,'normal'),
	(10,4,'api/user/register','Register','',0,1491635035,1491635035,8,'normal'),
	(11,4,'api/user/index','User Center','',0,1491635035,1491635035,10,'normal'),
	(12,4,'api/user/profile','Profile','',0,1491635035,1491635035,3,'normal');

/*!40000 ALTER TABLE `cr_user_rule` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cr_user_score_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_user_score_log`;

CREATE TABLE `cr_user_score_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '变更积分',
  `before` int(10) NOT NULL DEFAULT '0' COMMENT '变更前积分',
  `after` int(10) NOT NULL DEFAULT '0' COMMENT '变更后积分',
  `memo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员积分变动表';



# Dump of table cr_user_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_user_token`;

CREATE TABLE `cr_user_token` (
  `token` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Token',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `expiretime` int(10) DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员Token表';



# Dump of table cr_version
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cr_version`;

CREATE TABLE `cr_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `oldversion` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '旧版本号',
  `newversion` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '新版本号',
  `packagesize` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '包大小',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '升级内容',
  `downloadurl` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '下载地址',
  `enforce` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '强制更新',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='版本表';




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
