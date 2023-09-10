-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: main
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attributes` (
  `attributeId` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`attributeId`),
  UNIQUE KEY `attributeId_UNIQUE` (`attributeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attributes`
--

LOCK TABLES `attributes` WRITE;
/*!40000 ALTER TABLE `attributes` DISABLE KEYS */;
INSERT INTO `attributes` VALUES (0,'phi_c'),(1,'phi_s'),(2,'phi_d'),(3,'phi_r'),(4,'phi_im'),(5,'phi_prec'),(6,'phi_spec'),(7,'phi_sens'),(8,'phi_npv'),(9,'phi_fnr'),(10,'phi_fpr'),(11,'phi_acc'),(12,'phi_ts'),(13,'phi_bacc'),(14,'phi_F1'),(15,'phi_mcc'),(16,'phi_fm'),(17,'phi_inform'),(18,'phi_marked'),(19,'phi_kappa'),(20,'phi_nlr'),(21,'phi_npr'),(22,'phi_dor');
/*!40000 ALTER TABLE `attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataset`
--

DROP TABLE IF EXISTS `dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset` (
  `idDataset` int GENERATED ALWAYS AS (0) STORED NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `content` mediumblob,
  PRIMARY KEY (`idDataset`),
  UNIQUE KEY `idDataset_UNIQUE` (`idDataset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataset`
--

LOCK TABLES `dataset` WRITE;
/*!40000 ALTER TABLE `dataset` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generation`
--

DROP TABLE IF EXISTS `generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generation` (
  `idRun` bigint NOT NULL,
  `generation` int NOT NULL DEFAULT '0',
  `time` int DEFAULT NULL,
  `idGeneration` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idGeneration`),
  KEY `runId_idx` (`idRun`),
  CONSTRAINT `idRun` FOREIGN KEY (`idRun`) REFERENCES `run` (`idRun`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generation`
--

LOCK TABLES `generation` WRITE;
/*!40000 ALTER TABLE `generation` DISABLE KEYS */;
/*!40000 ALTER TABLE `generation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `generation_BEFORE_INSERT` BEFORE INSERT ON `generation` FOR EACH ROW BEGIN
 SET NEW.generation = IFNULL((SELECT MAX(generation) FROM generation WHERE idRun = NEW.idRun), 0) + 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `run`
--

DROP TABLE IF EXISTS `run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `run` (
  `idRun` bigint NOT NULL,
  `isMultithreadingEnabled` tinyint DEFAULT '0',
  `metricConfig` varchar(45) DEFAULT NULL,
  `usedDataset` varchar(45) DEFAULT NULL,
  `completed` tinyint DEFAULT '0',
  PRIMARY KEY (`idRun`),
  UNIQUE KEY `idRun_UNIQUE` (`idRun`),
  KEY `dataset_idx` (`usedDataset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `run`
--

LOCK TABLES `run` WRITE;
/*!40000 ALTER TABLE `run` DISABLE KEYS */;
/*!40000 ALTER TABLE `run` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tree_data`
--

DROP TABLE IF EXISTS `tree_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tree_data` (
  `treeId` int NOT NULL,
  `value` float NOT NULL,
  `attributeId` int NOT NULL,
  PRIMARY KEY (`treeId`,`attributeId`,`value`),
  KEY `attributeId_idx` (`attributeId`),
  CONSTRAINT `attributeId` FOREIGN KEY (`attributeId`) REFERENCES `attributes` (`attributeId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `treeId` FOREIGN KEY (`treeId`) REFERENCES `trees` (`idTree`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tree_data`
--

LOCK TABLES `tree_data` WRITE;
/*!40000 ALTER TABLE `tree_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `tree_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trees`
--

DROP TABLE IF EXISTS `trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trees` (
  `idTree` int NOT NULL AUTO_INCREMENT,
  `idGeneration` int DEFAULT NULL,
  `tree` mediumtext,
  `position` int DEFAULT NULL,
  PRIMARY KEY (`idTree`),
  KEY `idGeneration_idx` (`idGeneration`),
  CONSTRAINT `idGen` FOREIGN KEY (`idGeneration`) REFERENCES `generation` (`idGeneration`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trees`
--

LOCK TABLES `trees` WRITE;
/*!40000 ALTER TABLE `trees` DISABLE KEYS */;
/*!40000 ALTER TABLE `trees` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trees_BEFORE_INSERT` BEFORE INSERT ON `trees` FOR EACH ROW BEGIN
SET NEW.position = IFNULL((SELECT MAX(position) FROM trees WHERE idGeneration = NEW.idGeneration), 0) + 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'main'
--

--
-- Dumping routines for database 'main'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-10 14:06:28
