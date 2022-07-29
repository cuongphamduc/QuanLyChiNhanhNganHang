CREATE DATABASE  IF NOT EXISTS `chinhanhnganhang` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `chinhanhnganhang`;
-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: chinhanhnganhang
-- ------------------------------------------------------
-- Server version	8.0.29

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
-- Table structure for table `giaodichcanhan`
--

DROP TABLE IF EXISTS `giaodichcanhan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giaodichcanhan` (
  `MaGD` int NOT NULL,
  `SoTien` int DEFAULT NULL,
  `LoaiGD` varchar(255) DEFAULT NULL,
  `PhuongThuc` varchar(255) DEFAULT NULL,
  `ThoiGianThucHien` datetime DEFAULT CURRENT_TIMESTAMP,
  `MaKHCN` int DEFAULT NULL,
  `MaTKTD` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`MaGD`),
  KEY `GDCN-MaKHCN_idx` (`MaKHCN`),
  KEY `GDCN-MaTKGT_idx` (`MaTKGT`),
  KEY `GDCN-MaTKTD_idx` (`MaTKTD`),
  KEY `GDCN-MaNV_idx` (`MaNV`),
  CONSTRAINT `GDCN-MaKHCN` FOREIGN KEY (`MaKHCN`) REFERENCES `khachhangcanhan` (`MaKHCN`),
  CONSTRAINT `GDCN-MaNV` FOREIGN KEY (`MaNV`) REFERENCES `nhanvien` (`MaNV`),
  CONSTRAINT `GDCN-MaTKGT` FOREIGN KEY (`MaTKGT`) REFERENCES `taikhoanguitien` (`MaTKGT`),
  CONSTRAINT `GDCN-MaTKTD` FOREIGN KEY (`MaTKTD`) REFERENCES `taikhoantindung` (`MaTKTD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giaodichcanhan`
--

LOCK TABLES `giaodichcanhan` WRITE;
/*!40000 ALTER TABLE `giaodichcanhan` DISABLE KEYS */;
/*!40000 ALTER TABLE `giaodichcanhan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `giaodichtochucdoanhnghiep`
--

DROP TABLE IF EXISTS `giaodichtochucdoanhnghiep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giaodichtochucdoanhnghiep` (
  `MaGD` int NOT NULL,
  `SoTien` int DEFAULT NULL,
  `LoaiGD` varchar(255) DEFAULT NULL,
  `PhuongThuc` varchar(255) DEFAULT NULL,
  `ThoiGianThucHien` datetime DEFAULT CURRENT_TIMESTAMP,
  `MaKHTCDN` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaTKVT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`MaGD`),
  KEY `GDTCDN-MaKHTCDN_idx` (`MaKHTCDN`),
  KEY `GDTCDN-MaTKGT_idx` (`MaTKGT`),
  KEY `GDTCDN-MaTKVT_idx` (`MaTKVT`),
  KEY `GDTCDN-MaNV_idx` (`MaNV`),
  CONSTRAINT `GDTCDN-MaKHTCDN` FOREIGN KEY (`MaKHTCDN`) REFERENCES `khachhangtochucdoanhnghiep` (`MaKHTCDN`),
  CONSTRAINT `GDTCDN-MaNV` FOREIGN KEY (`MaNV`) REFERENCES `nhanvien` (`MaNV`),
  CONSTRAINT `GDTCDN-MaTKGT` FOREIGN KEY (`MaTKGT`) REFERENCES `taikhoanguitien` (`MaTKGT`),
  CONSTRAINT `GDTCDN-MaTKVT` FOREIGN KEY (`MaTKVT`) REFERENCES `taikhoanvaytien` (`MaTKVT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giaodichtochucdoanhnghiep`
--

LOCK TABLES `giaodichtochucdoanhnghiep` WRITE;
/*!40000 ALTER TABLE `giaodichtochucdoanhnghiep` DISABLE KEYS */;
/*!40000 ALTER TABLE `giaodichtochucdoanhnghiep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khachhang`
--

DROP TABLE IF EXISTS `khachhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhang` (
  `MaKH` int NOT NULL AUTO_INCREMENT,
  `Ten` varchar(255) DEFAULT NULL,
  `DiaChi` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MaKH`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khachhang`
--

LOCK TABLES `khachhang` WRITE;
/*!40000 ALTER TABLE `khachhang` DISABLE KEYS */;
INSERT INTO `khachhang` VALUES (1,'cuong','a'),(3,'s','s');
/*!40000 ALTER TABLE `khachhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khachhang_sdt`
--

DROP TABLE IF EXISTS `khachhang_sdt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhang_sdt` (
  `MaKH` int NOT NULL,
  `Sdt` varchar(12) NOT NULL,
  PRIMARY KEY (`MaKH`,`Sdt`),
  CONSTRAINT `MaKH-SDT` FOREIGN KEY (`MaKH`) REFERENCES `khachhang` (`MaKH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khachhang_sdt`
--

LOCK TABLES `khachhang_sdt` WRITE;
/*!40000 ALTER TABLE `khachhang_sdt` DISABLE KEYS */;
INSERT INTO `khachhang_sdt` VALUES (1,'0123456789');
/*!40000 ALTER TABLE `khachhang_sdt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khachhangcanhan`
--

DROP TABLE IF EXISTS `khachhangcanhan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhangcanhan` (
  `MaKHCN` int NOT NULL,
  `NgheNghiep` varchar(255) DEFAULT NULL,
  `ThuNhap` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MaKHCN`),
  CONSTRAINT `MaKHCN` FOREIGN KEY (`MaKHCN`) REFERENCES `khachhang` (`MaKH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khachhangcanhan`
--

LOCK TABLES `khachhangcanhan` WRITE;
/*!40000 ALTER TABLE `khachhangcanhan` DISABLE KEYS */;
INSERT INTO `khachhangcanhan` VALUES (1,'s','1200');
/*!40000 ALTER TABLE `khachhangcanhan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khachhangtochucdoanhnghiep`
--

DROP TABLE IF EXISTS `khachhangtochucdoanhnghiep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhangtochucdoanhnghiep` (
  `MaKHTCDN` int NOT NULL,
  `NguoiDaiDien` varchar(255) DEFAULT NULL,
  `QuyMo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MaKHTCDN`),
  CONSTRAINT `MaKHTCDN` FOREIGN KEY (`MaKHTCDN`) REFERENCES `khachhang` (`MaKH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khachhangtochucdoanhnghiep`
--

LOCK TABLES `khachhangtochucdoanhnghiep` WRITE;
/*!40000 ALTER TABLE `khachhangtochucdoanhnghiep` DISABLE KEYS */;
/*!40000 ALTER TABLE `khachhangtochucdoanhnghiep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nhanvien`
--

DROP TABLE IF EXISTS `nhanvien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nhanvien` (
  `MaNV` int NOT NULL AUTO_INCREMENT,
  `Ten` varchar(255) DEFAULT NULL,
  `DiaChi` varchar(255) DEFAULT NULL,
  `CapBac` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MaNV`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nhanvien`
--

LOCK TABLES `nhanvien` WRITE;
/*!40000 ALTER TABLE `nhanvien` DISABLE KEYS */;
INSERT INTO `nhanvien` VALUES (1,'cuong','dfa','sep'),(2,'cuong','d','sep'),(3,'nam','binh da','nhan vien');
/*!40000 ALTER TABLE `nhanvien` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_BEFORE_INSERT` BEFORE INSERT ON `nhanvien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from nhanvien nv where nv.MaNV = new.MaNV;
    
    if rowCount != 0 then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_AFTER_INSERT` AFTER INSERT ON `nhanvien` FOR EACH ROW BEGIN
	insert into nhanvien_log(ThaoTac, MaNV, Ten_new, DiaChi_new, CapBac_new)
    values("Insert", new.MaNV, new.Ten, new.DiaChi, new.CapBac);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_BEFORE_UPDATE` BEFORE UPDATE ON `nhanvien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from nhanvien nv where nv.MaNV = new.MaNV;
    
    if rowCount = 0 then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_AFTER_UPDATE` AFTER UPDATE ON `nhanvien` FOR EACH ROW BEGIN
	insert into nhanvien_log(ThaoTac, MaNV, Ten_old, Ten_new, DiaChi_old, DiaChi_new, CapBAc_old, CapBac_new)
    values("Update", old.MaNV, old.Ten, new.Ten, old.DiaChi, new.DiaChi, old.CapBac, new.CapBac);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_BEFORE_DELETE` BEFORE DELETE ON `nhanvien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from nhanvien nv where nv.MaNV = old.MaNV;
    
    if rowCount = 0 then
		set msg = concat("Mã nhân viên ", cast(old.MaNV as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_AFTER_DELETE` AFTER DELETE ON `nhanvien` FOR EACH ROW BEGIN
	insert into nhanvien_log(ThaoTac, MaNV, Ten_old, Ten_new, DiaChi_old, DiaChi_new, CapBAc_old, CapBac_new)
    values("Delete", old.MaNV, old.Ten, null, old.DiaChi, null, old.CapBac, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `nhanvien_log`
--

DROP TABLE IF EXISTS `nhanvien_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nhanvien_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaNV` int NOT NULL,
  `Ten_old` varchar(255) DEFAULT NULL,
  `Ten_new` varchar(255) DEFAULT NULL,
  `DiaChi_old` varchar(255) DEFAULT NULL,
  `DiaChi_new` varchar(255) DEFAULT NULL,
  `CapBac_old` varchar(255) DEFAULT NULL,
  `CapBac_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nhanvien_log`
--

LOCK TABLES `nhanvien_log` WRITE;
/*!40000 ALTER TABLE `nhanvien_log` DISABLE KEYS */;
INSERT INTO `nhanvien_log` VALUES (1,'2022-07-29 10:44:43','Insert',4,NULL,'a',NULL,'a',NULL,'a'),(2,'2022-07-29 10:50:30','Update',2,'cuongggg','cuong','dfa','d','sepppp','sep'),(3,'2022-07-29 10:52:57','Delete',4,'a',NULL,'a',NULL,'a',NULL);
/*!40000 ALTER TABLE `nhanvien_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nhanvien_sdt`
--

DROP TABLE IF EXISTS `nhanvien_sdt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nhanvien_sdt` (
  `MaNV` int NOT NULL,
  `Sdt` varchar(12) NOT NULL,
  PRIMARY KEY (`MaNV`,`Sdt`),
  CONSTRAINT `MaNV-SDT` FOREIGN KEY (`MaNV`) REFERENCES `nhanvien` (`MaNV`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nhanvien_sdt`
--

LOCK TABLES `nhanvien_sdt` WRITE;
/*!40000 ALTER TABLE `nhanvien_sdt` DISABLE KEYS */;
INSERT INTO `nhanvien_sdt` VALUES (1,'+84787111997'),(2,'0787111997'),(3,'0111111111');
/*!40000 ALTER TABLE `nhanvien_sdt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sohuucanhan`
--

DROP TABLE IF EXISTS `sohuucanhan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sohuucanhan` (
  `MaSH` int NOT NULL,
  `ThoiGian` datetime DEFAULT CURRENT_TIMESTAMP,
  `MaKHCN` int DEFAULT NULL,
  `MaTKTD` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`MaSH`),
  KEY `SHCN-MaKHCN_idx` (`MaKHCN`),
  KEY `SHCN-MaTKTD_idx` (`MaTKTD`),
  KEY `SHCN-MaTKGT_idx` (`MaTKGT`),
  KEY `SHCN-MaNV_idx` (`MaNV`),
  CONSTRAINT `SHCN-MaKHCN` FOREIGN KEY (`MaKHCN`) REFERENCES `khachhangcanhan` (`MaKHCN`),
  CONSTRAINT `SHCN-MaNV` FOREIGN KEY (`MaNV`) REFERENCES `nhanvien` (`MaNV`),
  CONSTRAINT `SHCN-MaTKGT` FOREIGN KEY (`MaTKGT`) REFERENCES `taikhoanguitien` (`MaTKGT`),
  CONSTRAINT `SHCN-MaTKTD` FOREIGN KEY (`MaTKTD`) REFERENCES `taikhoantindung` (`MaTKTD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sohuucanhan`
--

LOCK TABLES `sohuucanhan` WRITE;
/*!40000 ALTER TABLE `sohuucanhan` DISABLE KEYS */;
/*!40000 ALTER TABLE `sohuucanhan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sohuutochucdoanhnghiep`
--

DROP TABLE IF EXISTS `sohuutochucdoanhnghiep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sohuutochucdoanhnghiep` (
  `MaSH` int NOT NULL,
  `ThoiGian` datetime DEFAULT CURRENT_TIMESTAMP,
  `MaKHTCDN` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaTKVT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`MaSH`),
  KEY `SHTCDN-MaKHTCDN_idx` (`MaKHTCDN`),
  KEY `SHTCDN-MaTKGT_idx` (`MaTKGT`),
  KEY `SHTCDN-MaTKVT_idx` (`MaTKVT`),
  KEY `SHTCDN-MaNV_idx` (`MaNV`),
  CONSTRAINT `SHTCDN-MaKHTCDN` FOREIGN KEY (`MaKHTCDN`) REFERENCES `khachhangtochucdoanhnghiep` (`MaKHTCDN`),
  CONSTRAINT `SHTCDN-MaNV` FOREIGN KEY (`MaNV`) REFERENCES `nhanvien` (`MaNV`),
  CONSTRAINT `SHTCDN-MaTKGT` FOREIGN KEY (`MaTKGT`) REFERENCES `taikhoanguitien` (`MaTKGT`),
  CONSTRAINT `SHTCDN-MaTKVT` FOREIGN KEY (`MaTKVT`) REFERENCES `taikhoanvaytien` (`MaTKVT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sohuutochucdoanhnghiep`
--

LOCK TABLES `sohuutochucdoanhnghiep` WRITE;
/*!40000 ALTER TABLE `sohuutochucdoanhnghiep` DISABLE KEYS */;
/*!40000 ALTER TABLE `sohuutochucdoanhnghiep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taikhoan`
--

DROP TABLE IF EXISTS `taikhoan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoan` (
  `MaTK` int NOT NULL,
  `Hang` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MaTK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taikhoan`
--

LOCK TABLES `taikhoan` WRITE;
/*!40000 ALTER TABLE `taikhoan` DISABLE KEYS */;
/*!40000 ALTER TABLE `taikhoan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taikhoanguitien`
--

DROP TABLE IF EXISTS `taikhoanguitien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoanguitien` (
  `MaTKGT` int NOT NULL,
  `LaiSuat` float DEFAULT NULL,
  `SoDu` int DEFAULT NULL,
  PRIMARY KEY (`MaTKGT`),
  CONSTRAINT `MaTKGT` FOREIGN KEY (`MaTKGT`) REFERENCES `taikhoan` (`MaTK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taikhoanguitien`
--

LOCK TABLES `taikhoanguitien` WRITE;
/*!40000 ALTER TABLE `taikhoanguitien` DISABLE KEYS */;
/*!40000 ALTER TABLE `taikhoanguitien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taikhoantindung`
--

DROP TABLE IF EXISTS `taikhoantindung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoantindung` (
  `MaTKTD` int NOT NULL,
  `HanMuc` int DEFAULT NULL,
  `SoNo` int DEFAULT NULL,
  PRIMARY KEY (`MaTKTD`),
  CONSTRAINT `MaTKTD` FOREIGN KEY (`MaTKTD`) REFERENCES `taikhoan` (`MaTK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taikhoantindung`
--

LOCK TABLES `taikhoantindung` WRITE;
/*!40000 ALTER TABLE `taikhoantindung` DISABLE KEYS */;
/*!40000 ALTER TABLE `taikhoantindung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taikhoanvaytien`
--

DROP TABLE IF EXISTS `taikhoanvaytien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoanvaytien` (
  `MaTKVT` int NOT NULL,
  `LaiSuat` float DEFAULT NULL,
  `SoNo` int DEFAULT NULL,
  PRIMARY KEY (`MaTKVT`),
  CONSTRAINT `MaTKVT` FOREIGN KEY (`MaTKVT`) REFERENCES `taikhoan` (`MaTK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taikhoanvaytien`
--

LOCK TABLES `taikhoanvaytien` WRITE;
/*!40000 ALTER TABLE `taikhoanvaytien` DISABLE KEYS */;
/*!40000 ALTER TABLE `taikhoanvaytien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'chinhanhnganhang'
--

--
-- Dumping routines for database 'chinhanhnganhang'
--
/*!50003 DROP PROCEDURE IF EXISTS `GenMaNV` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenMaNV`(
	out MaNV varchar(255)
)
BEGIN
	declare i int default 1;
    declare rowCount1 int;
    declare rowCount2 int;
    
	select count(*) into rowCount1 from nhanvien nv where nv.MaNV = i;
    select count(*) into rowCount2 from nhanvien_log nv_log where nv_log.ThaoTac = "Delete" and nv_log.MaNV = i;
    
    while (rowCount1 + rowCount2) != 0 do
		set i = i + 1;
		select count(*) into rowCount1 from nhanvien nv where nv.MaNV = i;
    end while;
    
    set MaNV = cast(i as char);
    select MaNV;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IsNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IsNumber`(
	in num varchar(255),
    out res bool
)
BEGIN
	set res = !(num is null or num = "") and (num regexp "^[0-9]+$");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IsPhoneNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IsPhoneNumber`(
	in phone_number varchar(255),
    out res bool
)
BEGIN
	set res = !(phone_number is null or phone_number = "") and ((LENGTH(phone_number) = 10 and SUBSTR(phone_number, 1, 1) = "0" and phone_number regexp "^[0-9]+$" = true) 
		or (LENGTH(phone_number) = 12 and SUBSTR(phone_number, 1, 3) = "+84" and SUBSTR(phone_number, 2) regexp "^[0-9]+$" = true));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TaoMaNV` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TaoMaNV`(
	out res varchar(255)
)
BEGIN
	declare i int default 1;
    declare rowCount1 int;
    declare rowCount2 int;
    
	select count(*) into rowCount1 from nhanvien nv where nv.MaNV = i;
    select count(*) into rowCount2 from nhanvien_log nv_log where nv_log.ThaoTac = "Delete" and nv_log.MaNV = i;
    
    while (rowCount1 + rowCount2) != 0 do
		set i = i + 1;
		select count(*) into rowCount1 from nhanvien nv where nv.MaNV = i;
        select count(*) into rowCount2 from nhanvien_log nv_log where nv_log.ThaoTac = "Delete" and nv_log.MaNV = i;
    end while;
    
    set res = cast(i as char);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemNhanVien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemNhanVien`(
	in MaNV varchar(255),
    in Ten varchar(255),
    in DiaChi varchar(255),
    in CapBac varchar(255),
    in Sdt varchar(12)
)
BEGIN
	select *
    from nhanvien nv join nhanvien_sdt nv_sdt
    on nv.MaNV = nv_sdt.MaNV
    where (MaNV is null or MaNV = "" or nv.MaNV = CAST(MaNV as unsigned))
		and (Ten is null or Ten = "" or nv.Ten LIKE CONCAT("%", Ten, "%"))
		and (DiaChi is null or DiaChi = "" or nv.DiaChi like concat("%", DiaChi, "%"))
		and (CapBac is null or CapBac = "" or nv.CapBac like concat("%", CapBac, "%"))
        and (Sdt is null or Sdt = "" or nv_sdt.Sdt like concat("%", Sdt, "%"));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-29 15:17:54
