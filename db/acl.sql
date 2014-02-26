-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: demo3
-- ------------------------------------------------------
-- Server version	5.5.35-0ubuntu0.12.04.2

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
-- Table structure for table `acl_roles`
--

DROP TABLE IF EXISTS `acl_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_roles` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(140) NOT NULL,
  `type` enum('system','user','admin','additional') NOT NULL,
  `date_creation` datetime DEFAULT NULL,
  `description` text,
  `deleted` enum('y','n') DEFAULT 'n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `acl_privileges`
--

DROP TABLE IF EXISTS `acl_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_privileges` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(140) NOT NULL,
  `date_creation` datetime DEFAULT NULL,
  `description` text,
  `deleted` enum('y','n') DEFAULT 'n',
  `resource_id` bigint(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `resource_id` (`resource_id`),
  CONSTRAINT `acl_privileges_ibfk_1` FOREIGN KEY (`resource_id`) REFERENCES `acl_resources` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `acl_resources`
--

DROP TABLE IF EXISTS `acl_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_resources` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(140) NOT NULL,
  `date_creation` datetime DEFAULT NULL,
  `description` text,
  `deleted` enum('y','n') DEFAULT 'n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `acl_hierarchy`
--

DROP TABLE IF EXISTS `acl_hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_hierarchy` (
  `role_id` bigint(11) NOT NULL,
  `parent_role_id` bigint(11) DEFAULT NULL,
  KEY `role_id` (`role_id`),
  KEY `parent_role_id` (`parent_role_id`),
  CONSTRAINT `acl_hierarchy_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `acl_roles` (`id`),
  CONSTRAINT `acl_hierarchy_ibfk_2` FOREIGN KEY (`parent_role_id`) REFERENCES `acl_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `acl_user`
--

DROP TABLE IF EXISTS `acl_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_user` (
  `role_id` bigint(11) NOT NULL,
  `user_id` bigint(11) NOT NULL,
  KEY `role_id` (`role_id`),
  CONSTRAINT `acl_user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `acl_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `acl_roles_structure`
--

DROP TABLE IF EXISTS `acl_roles_structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_roles_structure` (
  `role_id` bigint(11) NOT NULL,
  `privilege_id` bigint(11) NOT NULL,
  `mode` enum('allow','deny') DEFAULT 'allow',
  KEY `role_id` (`role_id`),
  KEY `privilege_id` (`privilege_id`),
  CONSTRAINT `acl_roles_structure_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `acl_roles` (`id`),
  CONSTRAINT `acl_roles_structure_ibfk_2` FOREIGN KEY (`privilege_id`) REFERENCES `acl_privileges` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `acl`
--

DROP TABLE IF EXISTS `acl`;
/*!50001 DROP VIEW IF EXISTS `acl`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `acl` (
  `id` tinyint NOT NULL,
  `role` tinyint NOT NULL,
  `resource` tinyint NOT NULL,
  `privilege` tinyint NOT NULL,
  `mode` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `acl_hie`
--

DROP TABLE IF EXISTS `acl_hie`;
/*!50001 DROP VIEW IF EXISTS `acl_hie`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `acl_hie` (
  `role` tinyint NOT NULL,
  `parents` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `acl`
--

/*!50001 DROP TABLE IF EXISTS `acl`*/;
/*!50001 DROP VIEW IF EXISTS `acl`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `acl` AS select `acl_roles`.`id` AS `id`,`acl_roles`.`code` AS `role`,`acl_resources`.`code` AS `resource`,`acl_privileges`.`code` AS `privilege`,`acl_roles_structure`.`mode` AS `mode` from (((`acl_roles` left join `acl_roles_structure` on((`acl_roles_structure`.`role_id` = `acl_roles`.`id`))) left join `acl_privileges` on((`acl_privileges`.`id` = `acl_roles_structure`.`privilege_id`))) left join `acl_resources` on((`acl_resources`.`id` = `acl_privileges`.`resource_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `acl_hie`
--

/*!50001 DROP TABLE IF EXISTS `acl_hie`*/;
/*!50001 DROP VIEW IF EXISTS `acl_hie`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`demo3-db`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `acl_hie` AS select `a1`.`code` AS `role`,group_concat(`a2`.`code` separator ',') AS `parents` from (`acl_roles` `a1` join (`acl_hierarchy` `h` left join `acl_roles` `a2` on((`a2`.`id` = `h`.`parent_role_id`)))) where (`a1`.`id` = `h`.`role_id`) group by `h`.`role_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-02-16 22:17:50
