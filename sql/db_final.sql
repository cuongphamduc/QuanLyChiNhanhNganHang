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
  `MaGD` int NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `giaodichcanhan_BEFORE_INSERT` BEFORE INSERT ON `giaodichcanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    declare res1 bool;
    declare money int;
    
    select count(*) into rowCount from giaodichcanhan gdcn where gdcn.MaGD = new.MaGD;
    if rowCount != 0 then
		set msg = concat("Mã giao dịch ", cast(new.MaGD as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaGD, res);
    if res = false then
		set msg = concat("Mã giao dịch ", cast(new.MaGD as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.SoTien, res);
    if res = false then
		set msg = concat("Số tiền ", cast(new.SoTien as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHCN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHCN as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKTD, res);
    call chinhanhnganhang.IsNumber(new.MaTKGT, res1);
    if res = false and res1 = false then
		set msg = concat("Mã tài khoản không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if new.LoaiGD = "thanh toan TKTD" and new.PhuongThuc = "TKGT"
    then
		select SoDu into money
        from taikhoanguitien tkgt
        where tkgt.MaTKGT = new.MaTKGT;
        
        if cast(money as unsigned) < cast(new.SoTien as unsigned)
		then
			set msg = "Số tiền không đủ để thanh toán";
			signal sqlstate "45000" set message_text = msg;
		end if;
	end if;
    
	if new.LoaiGD = "chi tieu TKGT"
    then
		select SoDu into money
        from taikhoanguitien tkgt
        where tkgt.MaTKGT = new.MaTKGT;
        
        if cast(money as unsigned) < cast(new.SoTien as unsigned)
		then
			set msg = "Số tiền không đủ để thanh toán";
			signal sqlstate "45000" set message_text = msg;
		end if;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `giaodichcanhan_AFTER_INSERT` AFTER INSERT ON `giaodichcanhan` FOR EACH ROW BEGIN
	insert into giaodichcanhan_log(ThaoTac, MaGD, SoTien, LoaiGD, PhuongThuc, ThoiGianThucHien, MaKHCN, MaTKTD, MaTKGT, MaNV)
    values("Insert", new.MaGD, new.SoTien, new.LoaiGD, new.PhuongThuc, new.ThoiGianThucHien, new.MaKHCN, new.MaTKTD, new.MaTKGT, new.MaNV);
    
	if new.LoaiGD = "chi tieu TKTD"
    then
		update taikhoantindung tktd
        set SoNo = cast(SoNo as unsigned) + cast(new.SoTien as unsigned)
        where tkgt.MaTKTD = new.MaTKTD;
    end if;
    
    if new.LoaiGD = "thanh toan TKTD" and new.PhuongThuc = "TKGT"
    then
		update taikhoanguitien tkgt
        set SoDu = cast(SoDu as unsigned) - cast(new.SoTien as unsigned)
        where tkgt.MaTKGT = new.MaTKGT;
        
        update taikhoantindung tktd
        set SoNo = cast(SoNo as unsigned) - cast(new.SoTien as unsigned)
        where tkgt.MaTKTD = new.MaTKTD;
	end if;
    
	if new.LoaiGD = "thanh toan TKTD" and new.PhuongThuc = "tien mat"
    then
        update taikhoantindung tktd
        set SoNo = cast(SoNo as unsigned) - cast(new.SoTien as unsigned)
        where tkgt.MaTKTD = new.MaTKTD;
	end if;
    
	if new.LoaiGD = "nap tien TKGT" and new.PhuongThuc = "tien mat"
    then
		update taikhoanguitien tkgt
        set SoDu = cast(SoDu as unsigned) + cast(new.SoTien as unsigned)
        where tkgt.MaTKGT = new.MaTKGT;
    end if;
    
    if new.LoaiGD = "chi tieu TKGT"
    then
		update taikhoanguitien tkgt
        set SoDu = cast(SoDu as unsigned) - cast(new.SoTien as unsigned)
        where tkgt.MaTKGT = new.MaTKGT;
    end if;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `giaodichcanhan_log`
--

DROP TABLE IF EXISTS `giaodichcanhan_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giaodichcanhan_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaGD` int NOT NULL,
  `SoTien` int DEFAULT NULL,
  `LoaiGD` varchar(255) DEFAULT NULL,
  `PhuongThuc` varchar(255) DEFAULT NULL,
  `ThoiGianThucHien` datetime DEFAULT NULL,
  `MaKHCN` int DEFAULT NULL,
  `MaTKTD` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `giaodichtochucdoanhnghiep`
--

DROP TABLE IF EXISTS `giaodichtochucdoanhnghiep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giaodichtochucdoanhnghiep` (
  `MaGD` int NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `giaodichtochucdoanhnghiep_BEFORE_INSERT` BEFORE INSERT ON `giaodichtochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    declare res1 bool;
    declare money int;
    
    select count(*) into rowCount from giaodichtochucdoanhnghiep gdtcdn where gdtcdn.MaGD = new.MaGD;
    
    if rowCount != 0 then
		set msg = concat("Mã giao dịch ", cast(new.MaGD as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaGD, res);
    
    if res = false then
		set msg = concat("Mã giao dịch ", cast(new.MaGD as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.SoTien, res);
    
    if res = false then
		set msg = concat("Số tiền ", cast(new.SoTien as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHTCDN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHTCDN as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKVT, res);
    call chinhanhnganhang.IsNumber(new.MaTKGT, res1);
    if res = false and res1 = false then
		set msg = concat("Mã tài khoản không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if new.LoaiGD = "chi tieu TKGT"
    then
		select SoDu into money
        from taikhoanguitien tkgt
        where tkgt.MaTKGT = new.MaTKGT;
        
        if cast(money as unsigned) < cast(new.SoTien as unsigned)
		then
			set msg = "Số tiền không đủ để thanh toán";
			signal sqlstate "45000" set message_text = msg;
		end if;
	end if;
    
    if new.LoaiGD = "tra no TKVT" and new.PhuongThuc = "TKGT"
    then
		select SoDu into money
        from taikhoanguitien tkgt
        where tkgt.MaTKGT = new.MaTKGT;
        
        if cast(money as unsigned) < cast(new.SoTien as unsigned)
		then
			set msg = "Số tiền không đủ để thanh toán";
			signal sqlstate "45000" set message_text = msg;
		end if;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `giaodichtochucdoanhnghiep_AFTER_INSERT` AFTER INSERT ON `giaodichtochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into giaodichtochucdoanhnghiep_log(ThaoTac, MaGD, SoTien, LoaiGD, PhuongThuc, ThoiGianThucHien, MaKHTCDN, MaTKVT, MaTKGT, MaNV)
    values("Insert", new.MaGD, new.SoTien, new.LoaiGD, new.PhuongThuc, new.ThoiGianThucHien, new.MaKHTCDN, new.MaTKVT, new.MaTKGT, new.MaNV);
    
    if new.LoaiGD = "chi tieu TKGT"
    then
		update taikhoanguitien tkgt
        set SoDu = cast(SoDu as unsigned) - cast(new.SoTien as unsigned)
        where tkgt.MaTKGT = new.MaTKGT;
	end if;
    
    if new.LoaiGD = "vay tien TKVT" and new.PhuongThuc = "TKGT"
    then
		update taikhoanguitien tkgt
        set SoDu = cast(SoDu as unsigned) + cast(new.SoTien as unsigned)
        where tkgt.MaTKGT = new.MaTKGT;
        
        update taikhoanvaytien tkvt
        set SoNo = cast(SoNo as unsigned) + cast(new.SoTien as unsigned)
        where tkvt.MaTKVT = new.MaTKVT;
	end if;
    
    if new.LoaiGD = "vay tien TKVT" and new.PhuongThuc = "tien mat"
    then
        update taikhoanvaytien tkvt
        set SoNo = cast(SoNo as unsigned) + cast(new.SoTien as unsigned)
        where tkvt.MaTKVT = new.MaTKVT;
	end if;
    
	if new.LoaiGD = "tra no TKVT" and new.PhuongThuc = "TKGT"
    then
		update taikhoanguitien tkgt
        set SoDu = cast(SoDu as unsigned) - cast(new.SoTien as unsigned)
        where tkgt.MaTKGT = new.MaTKGT;
        
        update taikhoanvaytien tkvt
        set SoNo = cast(SoNo as unsigned) - cast(new.SoTien as unsigned)
        where tkvt.MaTKVT = new.MaTKVT;
	end if;
    
	if new.LoaiGD = "tra no TKVT" and new.PhuongThuc = "tien mat"
    then
        update taikhoanvaytien tkvt
        set SoNo = cast(SoNo as unsigned) - cast(new.SoTien as unsigned)
        where tkvt.MaTKVT = new.MaTKVT;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `giaodichtochucdoanhnghiep_log`
--

DROP TABLE IF EXISTS `giaodichtochucdoanhnghiep_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giaodichtochucdoanhnghiep_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaGD` int NOT NULL,
  `SoTien` int DEFAULT NULL,
  `LoaiGD` varchar(255) DEFAULT NULL,
  `PhuongThuc` varchar(255) DEFAULT NULL,
  `ThoiGianThucHien` datetime DEFAULT NULL,
  `MaKHTCDN` int DEFAULT NULL,
  `MaTKVT` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_BEFORE_INSERT` BEFORE INSERT ON `khachhang` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from khachhang kh where kh.MaKH = new.MaKH;
    if rowCount != 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKH as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKH, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKH as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if new.Ten is null or new.Ten = '' then
		set msg = concat("Tên khách hàng không được để trống");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_AFTER_INSERT` AFTER INSERT ON `khachhang` FOR EACH ROW BEGIN
	insert into khachhang_log(ThaoTac, MaKH, Ten_new, DiaChi_new)
    values("Insert", new.MaKH, new.Ten, new.DiaChi);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_BEFORE_UPDATE` BEFORE UPDATE ON `khachhang` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhang kh where kh.MaKH = new.MaKH;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKH as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if new.Ten is null or new.Ten = '' then
		set msg = concat("Tên khách hàng không được để trống");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_AFTER_UPDATE` AFTER UPDATE ON `khachhang` FOR EACH ROW BEGIN
	insert into khachhang_log(ThaoTac, MaKH, Ten_old, Ten_new, DiaChi_old, DiaChi_new)
    values("Update", old.MaKH, old.Ten, new.Ten, old.DiaChi, new.DiaChi);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_BEFORE_DELETE` BEFORE DELETE ON `khachhang` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhang kh where kh.MaKH = old.MaKH;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(old.MaKH as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_AFTER_DELETE` AFTER DELETE ON `khachhang` FOR EACH ROW BEGIN
	insert into khachhang_log(ThaoTac, MaKH, Ten_old, Ten_new, DiaChi_old, DiaChi_new)
    values("Delete", old.MaKH, old.Ten, null, old.DiaChi, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `khachhang_log`
--

DROP TABLE IF EXISTS `khachhang_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhang_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaKH` int NOT NULL,
  `Ten_old` varchar(255) DEFAULT NULL,
  `Ten_new` varchar(255) DEFAULT NULL,
  `Diachi_old` varchar(255) DEFAULT NULL,
  `Diachi_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_sdt_BEFORE_INSERT` BEFORE INSERT ON `khachhang_sdt` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from khachhang_sdt kh_sdt where kh_sdt.MaKH = new.MaKH;
    if rowCount != 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKH as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKH, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKH as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsPhoneNumber(new.Sdt, res);
    if res = false then
		set msg = concat("Số điện thoại ", cast(new.Sdt as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_sdt_AFTER_INSERT` AFTER INSERT ON `khachhang_sdt` FOR EACH ROW BEGIN
	insert into khachhang_sdt_log(ThaoTac, MaKH, Sdt_new)
    values("Insert", new.MaKH, new.Sdt);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_sdt_BEFORE_UPDATE` BEFORE UPDATE ON `khachhang_sdt` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from khachhang_sdt kh_sdt where kh_sdt.MaKH = new.MaKH;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKH as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsPhoneNumber(new.Sdt, res);
    if res = false then
		set msg = concat("Số điện thoại ", cast(new.Sdt as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_sdt_AFTER_UPDATE` AFTER UPDATE ON `khachhang_sdt` FOR EACH ROW BEGIN
	insert into khachhang_sdt_log(ThaoTac, MaKH, Sdt_new, Sdti_new)
    values("Update", old.MaKH, old.Sdt, new.Sdt);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_sdt_BEFORE_DELETE` BEFORE DELETE ON `khachhang_sdt` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhang_sdt kh_sdt where kh_sdt.MaKH = old.MaKH;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(old.MaKH as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhang_sdt_AFTER_DELETE` AFTER DELETE ON `khachhang_sdt` FOR EACH ROW BEGIN
	insert into khachhang_sdt_log(ThaoTac, MaKH, Sdt_old, Sdt_new)
    values("Delete", old.MaKH, old.Sdt, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `khachhang_sdt_log`
--

DROP TABLE IF EXISTS `khachhang_sdt_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhang_sdt_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaKH` int NOT NULL,
  `Sdt_old` varchar(12) DEFAULT NULL,
  `Sdt_new` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangcanhan_BEFORE_INSERT` BEFORE INSERT ON `khachhangcanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from khachhangcanhan khcn where khcn.MaKHCN = new.MaKHCN;
    if rowCount != 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKHCN as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHCN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHCN as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangcanhan_AFTER_INSERT` AFTER INSERT ON `khachhangcanhan` FOR EACH ROW BEGIN
	insert into khachhangcanhan_log(ThaoTac, MaKHCN, NgheNghiep_new, ThuNhap_new)
    values("Insert", new.MaKHCN, new.NgheNghiep, new.ThuNhap);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangcanhan_BEFORE_UPDATE` BEFORE UPDATE ON `khachhangcanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhangcanhan khcn where khcn.MaKHCN = new.MaKHCN;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKHCN as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangcanhan_AFTER_UPDATE` AFTER UPDATE ON `khachhangcanhan` FOR EACH ROW BEGIN
	insert into khachhangcanhan_log(ThaoTac, MaKHCN, NgheNghiep_old, NgheNghiep_new, ThuNhap_old, ThuNhap_new)
    values("Update", old.MaKHCN, old.NgheNghiep, new.NgheNghiep, old.ThuNhap, new.ThuNhap);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangcanhan_BEFORE_DELETE` BEFORE DELETE ON `khachhangcanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhangcanhan khcn where khcn.MaKHCN = old.MaKHCN;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(old.MaKHCN as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangcanhan_AFTER_DELETE` AFTER DELETE ON `khachhangcanhan` FOR EACH ROW BEGIN
	insert into khachhangcanhan_log(ThaoTac, MaKHCN, NgheNghiep_old, NgheNghiep_new, ThuNhap_old, ThuNhap_new)
    values("Delete", old.MaKHCN, old.NgheNghiep, null, old.ThuNhap, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `khachhangcanhan_log`
--

DROP TABLE IF EXISTS `khachhangcanhan_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhangcanhan_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaKHCN` int NOT NULL,
  `NgheNghiep_old` varchar(255) DEFAULT NULL,
  `NgheNghiep_new` varchar(255) DEFAULT NULL,
  `ThuNhap_old` varchar(255) DEFAULT NULL,
  `ThuNhap_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangtochucdoanhnghiep_BEFORE_INSERT` BEFORE INSERT ON `khachhangtochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from khachhangtochucdoanhnghiep khtcdn where khtcdn.MaKHTCDN = new.MaKHTCDN;
    if rowCount != 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKHTCDN as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHTCDN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHTCDN as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangtochucdoanhnghiep_AFTER_INSERT` AFTER INSERT ON `khachhangtochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into khachhangtochucdoanhnghiep_log(ThaoTac, MaKHTCDN, NguoiDaiDien_new, QuyMo_new)
    values("Insert", new.MaKHTCDN, new.NguoiDaiDien, new.QuyMo);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangtochucdoanhnghiep_BEFORE_UPDATE` BEFORE UPDATE ON `khachhangtochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhangtochucdoanhnghiep khtcdn where khtcdn.MaKHTCDN = new.MaKHTCDN;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(new.MaKHTCDN as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangtochucdoanhnghiep_AFTER_UPDATE` AFTER UPDATE ON `khachhangtochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into khachhangtochucdoanhnghiep_log(ThaoTac, MaKHTCDN, NguoiDaiDien_old, NguoiDaiDien_new, QuyMo_old, QuyMo_new)
    values("Update", old.MaKHTCDN, old.NguoiDaiDien, new.NguoiDaiDien, old.QuyMo, new.QuyMo);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangtochucdoanhnghiep_BEFORE_DELETE` BEFORE DELETE ON `khachhangtochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from khachhangtochucdoanhnghiep khtcdn where khtcdn.MaKHTCDN = old.MaKHTCDN;
    if rowCount = 0 then
		set msg = concat("Mã khách hàng ", cast(old.MaKHTCDN as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `khachhangtochucdoanhnghiep_AFTER_DELETE` AFTER DELETE ON `khachhangtochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into khachhangtochucdoanhnghiep_log(ThaoTac, MaKHTCDN, NguoiDaiDien_old, NguoiDaiDien_new, QuyMo_old, QuyMo_new)
    values("Delete", old.MaKHTCDN, old.NguoiDaiDien, null, old.QuyMo, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `khachhangtochucdoanhnghiep_log`
--

DROP TABLE IF EXISTS `khachhangtochucdoanhnghiep_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khachhangtochucdoanhnghiep_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaKHTCDN` int NOT NULL,
  `NguoiDaiDien_old` varchar(255) DEFAULT NULL,
  `NguoiDaiDien_new` varchar(255) DEFAULT NULL,
  `QuyMo_old` varchar(255) DEFAULT NULL,
  `QuyMo_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=6970 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
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
	insert into nhanvien_log(ThaoTac, MaNV, Ten_old, Ten_new, DiaChi_old, DiaChi_new, CapBac_old, CapBac_new)
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
	insert into nhanvien_log(ThaoTac, MaNV, Ten_old, Ten_new, DiaChi_old, DiaChi_new, CapBac_old, CapBac_new)
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_sdt_BEFORE_INSERT` BEFORE INSERT ON `nhanvien_sdt` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from nhanvien_sdt nv_sdt where nv_sdt.MaNV = new.MaNV;
    if rowCount != 0 then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsPhoneNumber(new.Sdt, res);
    if res = false then
		set msg = concat("Số điện thoại ", cast(new.Sdt as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_sdt_AFTER_INSERT` AFTER INSERT ON `nhanvien_sdt` FOR EACH ROW BEGIN
	insert into nhanvien_sdt_log(ThaoTac, MaNV, Sdt_new)
    values("Insert", new.MaNV, new.Sdt);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_sdt_BEFORE_UPDATE` BEFORE UPDATE ON `nhanvien_sdt` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from nhanvien_sdt nv_sdt where nv_sdt.MaNV = new.MaNV;
    if rowCount = 0 then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsPhoneNumber(new.Sdt, res);
    if res = false then
		set msg = concat("Số điện thoại ", cast(new.Sdt as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_sdt_AFTER_UPDATE` AFTER UPDATE ON `nhanvien_sdt` FOR EACH ROW BEGIN
	insert into nhanvien_sdt_log(ThaoTac, MaNV, Sdt_new, Sdti_new)
    values("Update", old.MaNV, old.Sdt, new.Sdt);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_sdt_BEFORE_DELETE` BEFORE DELETE ON `nhanvien_sdt` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from nhanvien_sdt nv_sdt where nv_sdt.MaNV = old.MaNV;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `nhanvien_sdt_AFTER_DELETE` AFTER DELETE ON `nhanvien_sdt` FOR EACH ROW BEGIN
	insert into nhanvien_sdt_log(ThaoTac, MaNV, Sdt_old, Sdt_new)
    values("Delete", old.MaNV, old.Sdt, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `nhanvien_sdt_log`
--

DROP TABLE IF EXISTS `nhanvien_sdt_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nhanvien_sdt_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaNV` int NOT NULL,
  `Sdt_old` varchar(12) DEFAULT NULL,
  `Sdt_new` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sohuucanhan`
--

DROP TABLE IF EXISTS `sohuucanhan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sohuucanhan` (
  `MaSH` int NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuucanhan_BEFORE_INSERT` BEFORE INSERT ON `sohuucanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    declare res1 bool;
    declare tmp int;
    
    select count(*) into rowCount from sohuucanhan shcn where shcn.MaSH = new.MaSH;
    if rowCount != 0 then
		set msg = concat("Mã sở hữu ", cast(new.MaSH as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaSH, res);
    if res = false then
		set msg = concat("Mã sở hữu ", cast(new.MaSH as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHCN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHCN as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKTD, res);
    call chinhanhnganhang.IsNumber(new.MaTKGT, res1);
    if res = false and res1 = false then
		set msg = concat("Mã tài khoản không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if res != false
    then
		select count(*) into tmp
        from sohuucanhan shcn
        where shcn.MaKHCN = new.MaKHCN and shcn.MaTKTD is not null and shcn.MaTKTD != "";
        
        if tmp >= 2
        then
			delete from taikhoan tk
			where MaTK = tk.MaTK;
			
			delete from taikhoantindung tktd
			where MaTK = tktd.MaTKTD;
        
			set msg = concat("Mỗi khách hàng cá nhân chỉ có tối đa 2 tài khoản tín dụng");
			signal sqlstate "45000" set message_text = msg;
		end if;
	end if;
    
    if res != false
    then
		select count(*) into tmp
        from sohuucanhan shcn
        where shcn.MaKHCN = new.MaKHCN and shcn.MaTKGT is not null and shcn.MaTKGT != "";
        
        if tmp >= 3
        then
			delete from taikhoan tk
			where MaTK = tk.MaTK;
			
			delete from taikhoanguitien tkgt
			where MaTK = tkgt.MaTKGT;
        
			set msg = concat("Mỗi khách hàng cá nhân chỉ có tối đa 3 tài khoản gửi tiền");
			signal sqlstate "45000" set message_text = msg;
		end if;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuucanhan_AFTER_INSERT` AFTER INSERT ON `sohuucanhan` FOR EACH ROW BEGIN
	insert into sohuucanhan_log(ThaoTac, MaSH, MaKHCN, MaTKTD, MaTKGT, MaNV)
    values("Insert", new.MaSH, new.MaKHCN, new.MaTKTD, new.MaTKGT, new.MaNV);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuucanhan_BEFORE_UPDATE` BEFORE UPDATE ON `sohuucanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    declare res1 bool;
    
    select count(*) into rowCount from sohuucanhan shcn where shcn.MaSH = new.MaSH;
    if rowCount = 0 then
		set msg = concat("Mã sở hữu ", cast(new.MaSH as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHCN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHCN as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKTD, res);
    call chinhanhnganhang.IsNumber(new.MaTKGT, res1);
    if res = false and res1 = false then
		set msg = concat("Mã tài khoản không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuucanhan_AFTER_UPDATE` AFTER UPDATE ON `sohuucanhan` FOR EACH ROW BEGIN
	insert into sohuucanhan_log(ThaoTac, MaSH, MaKHCN, MaTKTD, MaTKGT, MaNV)
    values("Update", old.MaSH, new.MaKHCN, new.MaTKTD, new.MaTKGT, new.MaNV);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuucanhan_BEFORE_DELETE` BEFORE DELETE ON `sohuucanhan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from sohuucanhan shcn where shcn.MaSH = old.MaSH;
    if rowCount = 0 then
		set msg = concat("Mã sở hữu ", cast(old.MaSH as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuucanhan_AFTER_DELETE` AFTER DELETE ON `sohuucanhan` FOR EACH ROW BEGIN
	insert into sohuucanhan_log(ThaoTac, MaSH, MaKHCN, MaTKTD, MaTKGT, MaNV)
    values("Delete", old.MaSH, null, null, null, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sohuucanhan_log`
--

DROP TABLE IF EXISTS `sohuucanhan_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sohuucanhan_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaSH` int NOT NULL,
  `ThoiGianSoHuu` datetime DEFAULT NULL,
  `MaKHCN` int DEFAULT NULL,
  `MaTKTD` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sohuutochucdoanhnghiep`
--

DROP TABLE IF EXISTS `sohuutochucdoanhnghiep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sohuutochucdoanhnghiep` (
  `MaSH` int NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuutochucdoanhnghiep_BEFORE_INSERT` BEFORE INSERT ON `sohuutochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    declare res1 bool;
    declare tmp int;
    
    select count(*) into rowCount from sohuutochucdoanhnghiep shtcdn where shtcdn.MaSH = new.MaSH;
    if rowCount != 0 then
		set msg = concat("Mã sở hữu ", cast(new.MaSH as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaSH, res);
    if res = false then
		set msg = concat("Mã sở hữu ", cast(new.MaSH as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHTCDN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHTCDN as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKVT, res);
    call chinhanhnganhang.IsNumber(new.MaTKGT, res1);
    if res = false and res1 = false then
		set msg = concat("Mã tài khoản không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if res != false
    then
		select count(*) into tmp
        from sohuutochucdoanhnghiep shtcdn
        where shtcdn.MaKHTCDN = new.MaKHTCDN and shtcdn.MaTKVT is not null and shtcdn.MaTKVT != "";
        
        if tmp >= 1
        then
			delete from taikhoan tk
			where new.MaTKGT = tk.MaTK;
			
			delete from taikhoanvaytien tkvt
			where new.MaTKVT = tkvt.MaTKVT;
        
			set msg = concat("Mỗi khách hàng tổ chức doanh nghiệp chỉ có tối đa 1 tài khoản vay tiền");
			signal sqlstate "45000" set message_text = msg;
		end if;
	end if;
    
    if res1 != false
    then
		select count(*) into tmp
        from sohuutochucdoanhnghiep shtcdn
        where shtcdn.MaKHTCDN = new.MaKHTCDN and shtcdn.MaTKGT is not null and shtcdn.MaTKGT != "";
        
        if tmp >= 1
        then
			delete from taikhoan tk
			where new.MaTKGT = tk.MaTK;
			
			delete from taikhoanguitien tkgt
			where new.MaTKGT = tkgt.MaTKGT;
        
			set msg = concat("Mỗi khách hàng tổ chức doanh nghiệp chỉ có tối đa 1 tài khoản gửi tiền");
			signal sqlstate "45000" set message_text = msg;
		end if;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuutochucdoanhnghiep_AFTER_INSERT` AFTER INSERT ON `sohuutochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into sohuutochucdoanhnghiep_log(ThaoTac, MaSH, MaKHTCDN, MaTKVT, MaTKGT, MaNV)
    values("Insert", new.MaSH, new.MaKHTCDN, new.MaTKVT, new.MaTKGT, new.MaNV);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuutochucdoanhnghiep_BEFORE_UPDATE` BEFORE UPDATE ON `sohuutochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    declare res1 bool;
    
    select count(*) into rowCount from sohuutochucdoanhnghiep shtcdn where shtcdn.MaSH = new.MaSH;
    if rowCount = 0 then
		set msg = concat("Mã sở hữu ", cast(new.MaSH as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaKHTCDN, res);
    if res = false then
		set msg = concat("Mã khách hàng ", cast(new.MaKHTCDN as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaNV, res);
    if res = false then
		set msg = concat("Mã nhân viên ", cast(new.MaNV as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKVT, res);
    call chinhanhnganhang.IsNumber(new.MaTKGT, res1);
    if res = false and res1 = false then
		set msg = concat("Mã tài khoản không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuutochucdoanhnghiep_AFTER_UPDATE` AFTER UPDATE ON `sohuutochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into sohuutochucdoanhnghiep_log(ThaoTac, MaSH, MaKHTCDN, MaTKVT, MaTKGT, MaNV)
    values("Update", old.MaSH, new.MaKHTCDN, new.MaTKVT, new.MaTKGT, new.MaNV);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuutochucdoanhnghiep_BEFORE_DELETE` BEFORE DELETE ON `sohuutochucdoanhnghiep` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from sohuutochucdoanhnghiep shtcdn where shtcdn.MaSH = old.MaSH;
    if rowCount = 0 then
		set msg = concat("Mã sở hữu ", cast(old.MaSH as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sohuutochucdoanhnghiep_AFTER_DELETE` AFTER DELETE ON `sohuutochucdoanhnghiep` FOR EACH ROW BEGIN
	insert into sohuutochucdoanhnghiep_log(ThaoTac, MaSH, MaKHTCDN, MaTKVT, MaTKGT, MaNV)
    values("Delete", old.MaSH, null, null, null, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sohuutochucdoanhnghiep_log`
--

DROP TABLE IF EXISTS `sohuutochucdoanhnghiep_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sohuutochucdoanhnghiep_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaSH` int NOT NULL,
  `ThoiGianSoHuu` datetime DEFAULT NULL,
  `MaKHTCDN` int DEFAULT NULL,
  `MaTKGT` int DEFAULT NULL,
  `MaTKVT` int DEFAULT NULL,
  `MaNV` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoan_BEFORE_INSERT` BEFORE INSERT ON `taikhoan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from taikhoan tk where tk.MaTK = new.MaTK;
    if rowCount != 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTK as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTK, res);
    if res = false then
		set msg = concat("Mã tài khoản ", cast(new.MaTK as char), " không hợp lệ");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if new.Hang is null or new.Hang = '' then
		set msg = concat("Hạng tài khoản không được để trống");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoan_AFTER_INSERT` AFTER INSERT ON `taikhoan` FOR EACH ROW BEGIN
	insert into taikhoan_log(ThaoTac, MaTK, Hang_new)
    values("Insert", new.MaTK, new.Hang);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoan_BEFORE_UPDATE` BEFORE UPDATE ON `taikhoan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoan tk where tk.MaTK = new.MaTK;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTK as char), " không tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    if new.Hang is null or new.Hang = '' then
		set msg = concat("Hạng tài khoản không được để trống");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoan_AFTER_UPDATE` AFTER UPDATE ON `taikhoan` FOR EACH ROW BEGIN
	insert into taikhoan_log(ThaoTac, MaTK, Hang_old, Hang_new)
    values("Update", old.MaTK, old.Hang, new.Hang);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoan_BEFORE_DELETE` BEFORE DELETE ON `taikhoan` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoan tk where tk.MaTK = old.MaTK;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(old.MaTK as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoan_AFTER_DELETE` AFTER DELETE ON `taikhoan` FOR EACH ROW BEGIN
	insert into taikhoan_log(ThaoTac, MaTK, Hang_old, Hang_new)
    values("Delete", old.MaTK, old.Hang, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `taikhoan_log`
--

DROP TABLE IF EXISTS `taikhoan_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoan_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaTK` int NOT NULL,
  `Hang_old` varchar(255) DEFAULT NULL,
  `Hang_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`MaTKGT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanguitien_BEFORE_INSERT` BEFORE INSERT ON `taikhoanguitien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from taikhoanguitien tk where tk.MaTKGT = new.MaTKGT;
    if rowCount != 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTKGT as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKGT, res);
    if res = false then
		set msg = concat("Mã tài khoản ", cast(new.MaTKGT as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanguitien_AFTER_INSERT` AFTER INSERT ON `taikhoanguitien` FOR EACH ROW BEGIN
	insert into taikhoanguitien_log(ThaoTac, MaTKGT, LaiSuat_new, SoDu_new)
    values("Insert", new.MaTKGT, new.LaiSuat, new.SoDu);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanguitien_BEFORE_UPDATE` BEFORE UPDATE ON `taikhoanguitien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoanguitien tk where tk.MaTKGT = new.MaTKGT;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTKGT as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanguitien_AFTER_UPDATE` AFTER UPDATE ON `taikhoanguitien` FOR EACH ROW BEGIN
	insert into taikhoanguitien_log(ThaoTac, MaTKGT, LaiSuat_old, LaiSuat_new, SoDu_old, SoDu_new)
    values("Update", old.MaTKGT, old.LaiSuat, new.LaiSuat, old.SoDu, new.SoDu);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanguitien_BEFORE_DELETE` BEFORE DELETE ON `taikhoanguitien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoanguitien tk where tk.MaTKGT = old.MaTKGT;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(old.MaTKGT as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanguitien_AFTER_DELETE` AFTER DELETE ON `taikhoanguitien` FOR EACH ROW BEGIN
	insert into taikhoanguitien_log(ThaoTac, MaTKGT, LaiSuat_old, LaiSuat_new, SoDu_old, SoDu_new)
    values("Delete", old.MaTKGT, old.LaiSuat, null, old.SoDu, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `taikhoanguitien_log`
--

DROP TABLE IF EXISTS `taikhoanguitien_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoanguitien_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaTKGT` int NOT NULL,
  `LaiSuat_old` varchar(255) DEFAULT NULL,
  `LaiSuat_new` varchar(255) DEFAULT NULL,
  `SoDu_old` varchar(255) DEFAULT NULL,
  `SoDu_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoantindung_BEFORE_INSERT` BEFORE INSERT ON `taikhoantindung` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from taikhoantindung tk where tk.MaTKTD = new.MaTKTD;
    if rowCount != 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTKTD as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKTD, res);
    if res = false then
		set msg = concat("Mã tài khoản ", cast(new.MaTKTD as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoantindung_AFTER_INSERT` AFTER INSERT ON `taikhoantindung` FOR EACH ROW BEGIN
	insert into taikhoantindung_log(ThaoTac, MaTKTD, HanMuc_new, SoNo_new)
    values("Insert", new.MaTKTD, new.HanMuc, new.SoNo);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoantindung_BEFORE_UPDATE` BEFORE UPDATE ON `taikhoantindung` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoantindung tk where tk.MaTKTD = new.MaTKTD;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTKTD as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoantindung_AFTER_UPDATE` AFTER UPDATE ON `taikhoantindung` FOR EACH ROW BEGIN
	insert into taikhoantindung_log(ThaoTac, MaTKTD, HanMuc_old, HanMuc_new, SoNo_old, SoNo_new)
    values("Update", old.MaTKTD, old.HanMuc, new.HanMuc, old.SoNo, new.SoNo);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoantindung_BEFORE_DELETE` BEFORE DELETE ON `taikhoantindung` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoantindung tk where tk.MaTKTD = old.MaTKTD;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(old.MaTKTD as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoantindung_AFTER_DELETE` AFTER DELETE ON `taikhoantindung` FOR EACH ROW BEGIN
	insert into taikhoantindung_log(ThaoTac, MaTKTD, HanMuc_old, HanMuc_new, SoNo_old, SoNo_new)
    values("Delete", old.MaTKTD, old.HanMuc, null, old.SoNo, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `taikhoantindung_log`
--

DROP TABLE IF EXISTS `taikhoantindung_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoantindung_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaTKTD` int NOT NULL,
  `HanMuc_old` varchar(255) DEFAULT NULL,
  `HanMuc_new` varchar(255) DEFAULT NULL,
  `SoNo_old` varchar(255) DEFAULT NULL,
  `SoNo_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanvaytien_BEFORE_INSERT` BEFORE INSERT ON `taikhoanvaytien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    declare res bool;
    
    select count(*) into rowCount from taikhoanvaytien tk where tk.MaTKVT = new.MaTKVT;
    if rowCount != 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTKVT as char), " đã tồn tại");
        signal sqlstate "45000" set message_text = msg;
	end if;
    
    call chinhanhnganhang.IsNumber(new.MaTKVT, res);
    if res = false then
		set msg = concat("Mã tài khoản ", cast(new.MaTKVT as char), " không hợp lệ");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanvaytien_AFTER_INSERT` AFTER INSERT ON `taikhoanvaytien` FOR EACH ROW BEGIN
	insert into taikhoanvaytien_log(ThaoTac, MaTKVT, LaiSuat_new, SoNo_new)
    values("Insert", new.MaTKVT, new.LaiSuat, new.SoNo);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanvaytien_BEFORE_UPDATE` BEFORE UPDATE ON `taikhoanvaytien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoanvaytien tk where tk.MaTKVT = new.MaTKVT;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(new.MaTKVT as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanvaytien_AFTER_UPDATE` AFTER UPDATE ON `taikhoanvaytien` FOR EACH ROW BEGIN
	insert into taikhoanvaytien_log(ThaoTac, MaTKVT, LaiSuat_old, LaiSuat_new, SoNo_old, SoNo_new)
    values("Update", old.MaTKVT, old.LaiSuat, new.LaiSuat, old.SoNo, new.SoNo);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanvaytien_BEFORE_DELETE` BEFORE DELETE ON `taikhoanvaytien` FOR EACH ROW BEGIN
	declare msg varchar(255);
    declare rowCount int;
    
    select count(*) into rowCount from taikhoanvaytien tk where tk.MaTKVT = old.MaTKVT;
    if rowCount = 0 then
		set msg = concat("Mã tài khoản ", cast(old.MaTKVT as char), " không tồn tại");
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `taikhoanvaytien_AFTER_DELETE` AFTER DELETE ON `taikhoanvaytien` FOR EACH ROW BEGIN
	insert into taikhoanvaytien_log(ThaoTac, MaTKVT, LaiSuat_old, LaiSuat_new, SoNo_old, SoNo_new)
    values("Delete", old.MaTKVT, old.LaiSuat, null, old.SoNo, null);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `taikhoanvaytien_log`
--

DROP TABLE IF EXISTS `taikhoanvaytien_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taikhoanvaytien_log` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ThoiGian` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ThaoTac` varchar(45) NOT NULL,
  `MaTKVT` int NOT NULL,
  `LaiSuat_old` varchar(255) DEFAULT NULL,
  `LaiSuat_new` varchar(255) DEFAULT NULL,
  `SoNo_old` varchar(255) DEFAULT NULL,
  `SoNo_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'chinhanhnganhang'
--

--
-- Dumping routines for database 'chinhanhnganhang'
--
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
/*!50003 DROP PROCEDURE IF EXISTS `LietKeTienGui` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LietKeTienGui`()
BEGIN
	select kh.MaKH, kh.Ten, kh.DiaChi, kh_sdt.Sdt, sum(tkgt.SoDu) as SoduTKGT from khachhang kh
	join khachhang_sdt kh_sdt
    on kh.MaKH = kh_sdt.MaKH
	join sohuucanhan shcn
    on kh.MaKH = shcn.MaKHCN
	join taikhoanguitien tkgt
    on shcn.MaTKGT = tkgt.MaTKGT
    
    union
    
    select kh.MaKH, kh.Ten, kh.DiaChi, kh_sdt.Sdt, sum(tkgt.SoDu) as SoduTKGT from khachhang kh
	join khachhang_sdt kh_sdt
    on kh.MaKH = kh_sdt.MaKH
	join sohuutochucdoanhnghiep shtcdn
    on kh.MaKH = shtcdn.MaKHTCDN
	join taikhoanguitien tkgt
    on shtcdn.MaTKGT = tkgt.MaTKGT
    
    order by SoduTKGT desc
    limit 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LietKeTinDung` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LietKeTinDung`(
	in start_date date,
    in end_date date
)
BEGIN
	select kh.Ten as Ten, sum(gdcn.SoTien) as SoTien
    from giaodichcanhan gdcn
    join khachhang kh
    on gdcn.MaKHCN = kh.MaKH
    where gdcn.MaTKTD is not null and gdcn.MaTKTD != "" and cast(gdcn.ThoiGianThucHien as date) >= start_date and cast(gdcn.ThoiGianThucHien as date) <= end_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SapXepNoTinDung` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SapXepNoTinDung`()
BEGIN
	select kh.Ten as Ten, tktd.SoNo as SoNo
    from taikhoantindung tktd
    join sohuucanhan shcn
    on tktd.MaTKTD = shcn.MaTKTD
    join khachhang kh
    on shcn.MaKHCN = kh.MaKH
    order by tktd.SoNo desc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaKhachHang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaKhachHang`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12),
    in NgheNghiep varchar(255),
    in ThuNhap varchar(255),
    in NguoiDaiDien varchar(255),
    in QuyMo varchar(255)
)
BEGIN
	update khachhang set Ten=Ten, DiaChi=DiaChi 
    where MaKH=MaKH;
    
    update khachhang_sdt set Sdt=Sdt
    where MaKH=MaKH;
    
    update khachhangcanhan set NgheNghiep=NgheNghiep, ThuNhap=ThuNhap
    where MaKHCN=MaKH;
    
    update khachhangtochucdoanhnghiep set NguoiDaiDien=NguoiDaiDien, QuyMo=QuyMo 
    where MaKHTCDN=MaKH;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaKhachHangCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaKhachHangCaNhan`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12),
    in NgheNghiep varchar(255),
    in ThuNhap varchar(255)
)
BEGIN
	update khachhang set Ten=Ten, DiaChi=DiaChi 
    where MaKH=MaKH;
    
    update khachhang_sdt set Sdt=Sdt
    where MaKH=MaKH;
    
    update khachhangcanhan set NgheNghiep=NgheNghiep, ThuNhap=ThuNhap
    where MaKHCN=MaKH;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaKhachHangToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaKhachHangToChucDoanhNghiep`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12),
    in NguoiDaiDien varchar(255),
    in QuyMo varchar(255)
)
BEGIN
	update khachhang set Ten=Ten, DiaChi=DiaChi 
    where MaKH=MaKH;
    
    update khachhang_sdt set Sdt=Sdt
    where MaKH=MaKH;
    
    update khachhangtochucdoanhnghiep set NguoiDaiDien=NguoiDaiDien, QuyMo=QuyMo 
    where MaKHTCDN=MaKH;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaNhanVien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaNhanVien`(
	in MaNV varchar(255),
    in Ten varchar(255),
    in DiaChi varchar(255),
    in CapBac varchar(255),
    in Sdt varchar(12)
)
BEGIN
	update nhanvien set Ten=Ten, DiaChi=DiaChi, CapBac=CapBac
    where MaNV=MaNV;
    
    update nhanvien_sdt set Sdt=Sdt
    where MaNV=MaNV;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaTaiKhoan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaTaiKhoan`(
	in MaTK varchar(255),
    in Hang varchar(255),
    in SoDu varchar(255),
    in HanMuc varchar(255),
	in LaiSuat varchar(255),
    in SoNo varchar(255)
)
BEGIN
	update taikhoan set Hang=Hang
    where MaTK=MaTK;
    
    update taikhoanguitien set LaiSuat=LaiSuat, SoDu=SoDu
    where MaTKGT=MaTK;
    
    update taikhoantindung set HanMuc=HanMuc, SoNo=SoNo
    where MaTKTD=MaTK;
    
    update taikhoanvaytien set LaiSuat=LaiSuat, SoNo=SoNo
    where MaTKVT=MaTK;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaTaiKhoanGuiTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaTaiKhoanGuiTien`(
	in MaTK varchar(255),
    in Hang varchar(255),
    in SoDu varchar(255),
	in LaiSuat varchar(255)
)
BEGIN
	update taikhoan set Hang=Hang
    where MaTK=MaTK;
    
    update taikhoanguitien set LaiSuat=LaiSuat, SoDu=SoDu
    where MaTKGT=MaTK;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaTaiKhoanTinDung` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaTaiKhoanTinDung`(
	in MaTK varchar(255),
    in Hang varchar(255),
    in HanMuc varchar(255),
    in SoNo varchar(255)
)
BEGIN
	update taikhoan set Hang=Hang
    where MaTK=MaTK;
    
    update taikhoantindung set HanMuc=HanMuc, SoNo=SoNo
    where MaTKTD=MaTK;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuaTaiKhoanVayTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuaTaiKhoanVayTien`(
	in MaTK varchar(255),
    in Hang varchar(255),
	in LaiSuat varchar(255),
    in SoNo varchar(255)
)
BEGIN
	update taikhoan set Hang=Hang
    where MaTK=MaTK;
    
    update taikhoanvaytien set LaiSuat=LaiSuat, SoNo=SoNo
    where MaTKVT=MaTK;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TaoMaKH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TaoMaKH`(
	out res varchar(255)
)
BEGIN
	declare i int default 1;
    declare rowCount1 int;
    declare rowCount2 int;
    
	select count(*) into rowCount1 from khachhang kh where kh.MaKH = i;
    select count(*) into rowCount2 from khachhang_log kh_log where kh_log.ThaoTac = "Delete" and kh_log.MaKH = i;
    
    while (rowCount1 + rowCount2) != 0 do
		set i = i + 1;
		select count(*) into rowCount1 from khachhang kh where kh.MaKH = i;
        select count(*) into rowCount2 from khachhang_log kh_log where kh_log.ThaoTac = "Delete" and kh_log.MaKH = i;
    end while;
    
    set res = cast(i as char);
    
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
/*!50003 DROP PROCEDURE IF EXISTS `TaoMaTK` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TaoMaTK`(
	out res varchar(255)
)
BEGIN
	declare i int default 1;
    declare rowCount1 int;
    declare rowCount2 int;
    
	select count(*) into rowCount1 from taikhoan tk where tk.MaTK = i;
    select count(*) into rowCount2 from taikhoan_log tk_log where tk_log.ThaoTac = "Delete" and tk_log.MaTK = i;
    
    while (rowCount1 + rowCount2) != 0 do
		set i = i + 1;
		select count(*) into rowCount1 from taikhoan tk where tk.MaTK = i;
        select count(*) into rowCount2 from taikhoan_log tk_log where tk_log.ThaoTac = "Delete" and tk_log.MaKH = i;
    end while;
    
    set res = cast(i as char);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemGiaoDichCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemGiaoDichCaNhan`(
    in SoTien varchar(255),
    in LoaiGD varchar(255),
    in PhuongThuc varchar(255),
    in MaKHCN varchar(255),
    in MaTKTD varchar(255),
    in MaTKGT varchar(255),
    in MaNV varchar(255)
)
BEGIN
	if MaTKTD is not null and MaTKTD != "" and MaTKGT is not null and MaTKGT != ""
    then
		insert into giaodichcanhan (SoTien, LoaiGD, PhuongThuc, MaKHCN, MaTKTD, MaTKGT, MaNV)
		values (SoTien, LoaiGD, PhuongThuc, MaKHCN, MaTKTD, MaTKGT, MaNV);
        
	elseif MaTKTD is not null and MaTKTD != ""
    then
		insert into giaodichcanhan (SoTien, LoaiGD, PhuongThuc, MaKHCN, MaTKTD, MaNV)
		values (SoTien, LoaiGD, PhuongThuc, MaKHCN, MaTKTD, MaNV);
	
    elseif MaTKGT is not null and MaTKGT != ""
    then
		insert into giaodichcanhan (SoTien, LoaiGD, PhuongThuc, MaKHCN, MaTKGT, MaNV)
		values (SoTien, LoaiGD, PhuongThuc, MaKHCN, MaTKGT, MaNV);
    
	end if;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemGiaoDichToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemGiaoDichToChucDoanhNghiep`(
    in SoTien varchar(255),
    in LoaiGD varchar(255),
    in PhuongThuc varchar(255),
    in MaKHTCDN varchar(255),
    in MaTKGT varchar(255),
    in MaTKVT varchar(255),
    in MaNV varchar(255)
)
BEGIN
	if MaTKGT is not null and MaTKGT != "" and MaTKVT is not null and MaTKVT != ""
    then
		insert into giaodichtochucdoanhnghiep (SoTien, LoaiGD, PhuongThuc, MaKHTCDN, MaTKGT, MaTKVT, MaNV)
		values (SoTien, LoaiGD, PhuongThuc, MaKHTCDN, MaTKGT, MaTKVT, MaNV);
        
	elseif MaTKGT is not null and MaTKGT != ""
    then
		insert into giaodichtochucdoanhnghiep (SoTien, LoaiGD, PhuongThuc, MaKHTCDN, MaTKGT, MaNV)
		values (SoTien, LoaiGD, PhuongThuc, MaKHTCDN, MaTKGT, MaNV);
        
	elseif MaTKVT is not null and MaTKVT != ""
    then
		insert into giaodichtochucdoanhnghiep (SoTien, LoaiGD, PhuongThuc, MaKHTCDN, MaTKVT, MaNV)
		values (SoTien, LoaiGD, PhuongThuc, MaKHTCDN, MaTKVT, MaNV);
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemKhachHang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemKhachHang`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12),
    in NgheNghiep varchar(255),
    in ThuNhap varchar(255),
    in NguoiDaiDien varchar(255),
    in QuyMo varchar(255)
)
BEGIN
	insert into khachhang (MaKH, Ten, DiaChi)
    values (MaKH, Ten, DiaChi);
    
    insert into khachhang_sdt (MaKH, Sdt) 
    values (MaKH, Sdt);
    
    insert into khachhangcanhan (MaKHCN, NgheNghiep, ThuNhap) 
    values (MaKH, NgheNghiep, ThuNhap);
    
    insert into khachhangtochucdoanhnghiep (MaKHTCDN, NguoiDaiDien, QuyMo) 
    values (MaKH, NguoiDaiDien, QuyMo);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemKhachHangCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemKhachHangCaNhan`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in DiaChi varchar(255),
    in Sdt varchar(12),
    in NgheNghiep varchar(255),
    in ThuNhap varchar(255)
)
BEGIN
	insert into khachhang (MaKH, Ten, DiaChi)
    values (MaKH, Ten, DiaChi);
    
    insert into khachhang_sdt (MaKH, Sdt) 
    values (MaKH, Sdt);
    
    insert into khachhangcanhan (MaKHCN, NgheNghiep, ThuNhap) 
    values (MaKH, NgheNghiep, ThuNhap);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemKhachHangToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemKhachHangToChucDoanhNghiep`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in DiaChi varchar(255),
    in Sdt varchar(12),
    in NguoiDaiDien varchar(255),
    in QuyMo varchar(255)
)
BEGIN
	insert into khachhang (MaKH, Ten, DiaChi)
    values (MaKH, Ten, DiaChi);
    
    insert into khachhang_sdt (MaKH, Sdt) 
    values (MaKH, Sdt);
    
    insert into khachhangtochucdoanhnghiep (MaKHCN, NguoiDaiDien, QuyMo) 
    values (MaKH, NguoiDaiDien, QuyMo);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemNhanVien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemNhanVien`(
	in MaNV varchar(255),
    in Ten varchar(255),
    in DiaChi varchar(255),
    in CapBac varchar(255),
    in Sdt varchar(12)
)
BEGIN
	insert into nhanvien (MaNV, Ten, DiaChi, CapBac)
    values (MaNV, Ten, DiaChi, CapBac);
    
    insert into nhanvien_sdt (MaNV, Sdt) 
    values (MaNV, Sdt);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemTaiKhoan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemTaiKhoan`(
	in MaTK varchar(255),
    in Hang varchar(255),
    in SoDu varchar(255),
    in HanMuc varchar(255),
	in LaiSuat varchar(255),
    in SoNo varchar(255)
)
BEGIN
	insert into taikhoan (MaTK, Hang)
    values (MaTK, Hang);
    
    insert into taikhoantindung (MaTKTD, HanMuc, SoNo) 
    values (MaTK, HanMuc, SoNo);
    
    insert into taikhoanguitien (MaTKGT, LaiSuat, SoDu) 
    values (MaTK, LaiSuat, SoDu);
    
    insert into taikhoanvaytien (MaTKVT, LaiSuat, SoNo) 
    values (MaTK, LaiSuat, SoNo);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemTaiKhoanGuiTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemTaiKhoanGuiTien`(
	in MaTK varchar(255),
    in Hang varchar(255),
    in SoDu varchar(255),
	in LaiSuat varchar(255)
)
BEGIN
	insert into taikhoan (MaTK, Hang)
    values (MaTK, Hang);
    
    insert into taikhoanguitien (MaTKGT, LaiSuat, SoDu) 
    values (MaTK, LaiSuat, SoDu);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemTaiKhoanGuiTienCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemTaiKhoanGuiTienCaNhan`(
	in MaKHCN varchar(255),
    in MaNV varchar(255),
	in MaTK varchar(255),
    in Hang varchar(255),
    in SoDu varchar(255),
	in LaiSuat varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
	insert into taikhoan (MaTK, Hang)
    values (MaTK, Hang);
    
    insert into taikhoanguitien (MaTKGT, LaiSuat, SoDu) 
    values (MaTK, LaiSuat, SoDu);
    
    insert into sohuucanhan (MaKHCN, MaTKGT, MaNV)
    values (MaKHCN, MaTK, MaNV);
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemTaiKhoanGuiTienToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemTaiKhoanGuiTienToChucDoanhNghiep`(
	in MaKHTCDN varchar(255),
    in MaNV varchar(255),
	in MaTK varchar(255),
    in Hang varchar(255),
    in SoDu varchar(255),
	in LaiSuat varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
	insert into taikhoan (MaTK, Hang)
    values (MaTK, Hang);
    
    insert into taikhoanguitien (MaTKGT, LaiSuat, SoDu) 
    values (MaTK, LaiSuat, SoDu);
    
    insert into sohuutochucdoanhnghiep (MaKHTCDN, MaTKGT, MaNV)
    values (MaKHTCDN, MaTK, MaNV);
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemTaiKhoanTinDung` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemTaiKhoanTinDung`(
	in MaKHCN varchar(255),
    in MaNV varchar(255),
	in MaTK varchar(255),
    in Hang varchar(255),
    in HanMuc varchar(255),
    in SoNo varchar(255)
)
BEGIN
	insert into taikhoan (MaTK, Hang)
    values (MaTK, Hang);
    
    insert into taikhoantindung (MaTKTD, HanMuc, SoNo) 
    values (MaTK, HanMuc, SoNo);
    
    insert into sohuucanhan (MaKHCN, MaTKTD, MaNV)
    values (MaKHCN, MaTK, MaNV);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ThemTaiKhoanVayTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ThemTaiKhoanVayTien`(
	in MaKHTCDN varchar(255),
    in MaNV varchar(255),
	in MaTK varchar(255),
    in Hang varchar(255),
	in LaiSuat varchar(255),
    in SoNo varchar(255)
)
BEGIN
	insert into taikhoan (MaTK, Hang)
    values (MaTK, Hang);
    
    insert into taikhoanvaytien (MaTKVT, LaiSuat, SoNo) 
    values (MaTK, LaiSuat, SoNo);
    
    insert into sohuutochucdoanhnghiep (MaKHTCDN, MaTKVT, MaNV)
    values (MaKHTCDN, MaTK, MaNV);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemGiaoDichCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemGiaoDichCaNhan`(
	in MaGD varchar(255),
    in MaKH varchar(255),
    in MaNV varchar(255),
    in MaTK varchar(255)
)
BEGIN
	select * from giaodichcanhan
    where (MaGD is null or MaGD = "" or MaGD = cast(MaGD as unsigned))
		and (MaKH is null or MaKH = "" or MaKHCN = cast(MaKH as unsigned))
		and (MaNV is null or MaNV = "" or MaNV = cast(MaNV as unsigned))
		and (MaTK is null or MaTK = "" or MaTKTD = cast(MaTK as unsigned) or MaTKGT = cast(MaTK as unsigned));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemGiaoDichToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemGiaoDichToChucDoanhNghiep`(
	in MaGD varchar(255),
    in MaKH varchar(255),
    in MaNV varchar(255),
    in MaTK varchar(255)
)
BEGIN
	select * from giaodichtochucdoanhnghiep
    where (MaGD is null or MaGD = "" or MaGD = cast(MaGD as unsigned))
		and (MaKH is null or MaKH = "" or MaKHTCDN = cast(MaKH as unsigned))
		and (MaNV is null or MaNV = "" or MaNV = cast(MaNV as unsigned))
		and (MaTK is null or MaTK = "" or MaTKVT = cast(MaTK as unsigned) or MaTKGT = cast(MaTK as unsigned));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemKhachHang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemKhachHang`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12)
)
BEGIN
	select * from khachhang kh 
    join khachhang_sdt kh_sdt on kh.MaKH = kh_sdt.MaKH
    left join khachhangcanhan khcn on kh.MaKH = khcn.MaKHCN
    left join khachhangtochucdoanhnghiep khtcdn on kh.MaKH = khtcdn.MaKHTCDN
    where (MaKH is null or MaKH = "" or kh.MaKH = cast(MaKH as unsigned))
		and (Ten is null or Ten = "" or kh.Ten LIKE concat("%", Ten, "%"))
        and (Sdt is null or Sdt = "" or kh_sdt.Sdt like concat("%", Sdt, "%"));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemKhachHangCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemKhachHangCaNhan`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12)
)
BEGIN
	select * from khachhang kh 
    join khachhang_sdt kh_sdt on kh.MaKH = kh_sdt.MaKH
	join khachhangcanhan khcn on kh.MaKH = khcn.MaKHCN
    where (MaKH is null or MaKH = "" or kh.MaKH = cast(MaKH as unsigned))
		and (Ten is null or Ten = "" or kh.Ten LIKE concat("%", Ten, "%"))
        and (Sdt is null or Sdt = "" or kh_sdt.Sdt like concat("%", Sdt, "%"));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemKhachHangToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemKhachHangToChucDoanhNghiep`(
	in MaKH varchar(255),
    in Ten varchar(255),
    in Sdt varchar(12)
)
BEGIN
	select * from khachhang kh 
    join khachhang_sdt kh_sdt on kh.MaKH = kh_sdt.MaKH
	join khachhangtochucdoanhnghiep khtcdn on kh.MaKH = khtcdn.MaKHTCDN
    where (MaKH is null or MaKH = "" or kh.MaKH = cast(MaKH as unsigned))
		and (Ten is null or Ten = "" or kh.Ten LIKE concat("%", Ten, "%"))
        and (Sdt is null or Sdt = "" or kh_sdt.Sdt like concat("%", Sdt, "%"));
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
	select * from nhanvien nv 
    join nhanvien_sdt nv_sdt on nv.MaNV = nv_sdt.MaNV
    where (MaNV is null or MaNV = "" or nv.MaNV = cast(MaNV as unsigned))
		and (Ten is null or Ten = "" or nv.Ten LIKE concat("%", Ten, "%"))
		and (DiaChi is null or DiaChi = "" or nv.DiaChi like concat("%", DiaChi, "%"))
		and (CapBac is null or CapBac = "" or nv.CapBac like concat("%", CapBac, "%"))
        and (Sdt is null or Sdt = "" or nv_sdt.Sdt like concat("%", Sdt, "%"));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemTaiKhoan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemTaiKhoan`(
	in MaTK varchar(255)
)
BEGIN
	select * from taikhoan tk
	left join taikhoantindung tktd on tk.MaTK = tktd.MaTKTD
    left join taikhoanvaytien tkvt on tk.MaTK = tkvt.MaTKVT
    left join taikhoanguitien tkgt on tk.MaTK = tkgt.MaTKGT
    where (MaTK is null or MaTK = "" or tk.MaTK = cast(MaTK as unsigned));
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemTaiKhoanGuiTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemTaiKhoanGuiTien`(
	in MaTK varchar(255)
)
BEGIN
	select * from taikhoan tk
	join taikhoanguitien on tk.MaTK = tkgt.MaTKGT
    where (MaTK is null or MaTK = "" or tk.MaTK = cast(MaTK as unsigned));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemTaiKhoanTinDung` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemTaiKhoanTinDung`(
	in MaTK varchar(255)
)
BEGIN
	select * from taikhoan tk
	join taikhoantindung tktd on tk.MaTK = tktd.MaTKTD
    where (MaTK is null or MaTK = "" or tk.MaTK = cast(MaTK as unsigned));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TimKiemTaiKhoanVayTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimKiemTaiKhoanVayTien`(
	in MaTK varchar(255)
)
BEGIN
	select * from taikhoan tk
	join taikhoanvaytien on tk.MaTK = tkgt.MaTKVT
    where (MaTK is null or MaTK = "" or tk.MaTK = cast(MaTK as unsigned));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TinhLuong` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TinhLuong`(
	in MaNV varchar(255),
	in thang varchar(2),
    out luong varchar(255)
)
BEGIN
	declare count_td int default 0;
    declare count_gt1 int default 0;
    declare count_gt2 int default 0;
    declare count_vt int default 0;
    
    select count(*) into count_td
    from sohuucanhan shcn
    where (shcn.MaNV = cast(MaNV as unsigned) and shcn.MaTKTD is not null and shcn.MaTKTD != ""
							and cast(month(shcn.ThoiGian) as unsigned) = cast(thang as unsigned));
        
    select SUM(gdcn.SoTien) into count_gt1
    from giaodichcanhan gdcn
    join sohuucanhan shcn
    on (gdcn.MaKHCN = shcn.MaKHCN and gdcn.MaTKGT = shcn.MaTKGT)
    where (shcn.MaNV = cast(MaNV as unsigned) and gdcn.LoaiGD = "nap tien TKGT"
			and cast(month(gdcn.ThoiGianThucHien) as unsigned) = cast(thang as unsigned)
			and minute(timediff(gdcn.ThoiGianThucHien, shcn.ThoiGian)) < 5);
                                                    
	select SUM(gdtcdn.SoTien) into count_gt2
    from giaodichtochucdoanhnghiep gdtcdn
    join sohuutochucdoanhnghiep shtcdn
    on (gdtcdn.MaKHTCDN = shtcdn.MaKHTCDN and gdtcdn.MaTKGT = shtcdn.MaTKGT)
    where (shtcdn.MaNV = cast(MaNV as unsigned) and gdtcdn.LoaiGD = "nap tien TKGT"
			and cast(month(gdtcdn.ThoiGianThucHien) as unsigned) = cast(thang as unsigned)
			and minute(timediff(gdtcdn.ThoiGianThucHien, shtcdn.ThoiGian)) < 5);
	
	select SUM(gdtcdn.SoTien) into count_vt
    from giaodichtochucdoanhnghiep gdtcdn
    join sohuutochucdoanhnghiep shtcdn
    on (gdtcdn.MaTKVT = shtcdn.MaTKVT)
    where (shtcdn.MaNV = cast(MaNV as unsigned) and gdtcdn.LoaiGD = "vay tien TKVT"
			and cast(month(gdtcdn.ThoiGianThucHien) as unsigned) = cast(thang as unsigned));
            
	if count_td is null then
		set count_td = 0;
    end if;
    
    if (count_gt1 is null) then
		set count_gt1 = 0;
    end if;
    
    if (count_gt2 is null) then
		set count_gt2 = 0;
    end if;
    
    if (count_vt is null) then
		set count_vt = 0;
    end if;
    
    set luong = cast((500000 * count_td + 0.01 * (count_gt1 + count_gt2) + 0.0005 * count_vt) as char);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaKhachHang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaKhachHang`(
	in MaKH varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
	delete kh, khsdt, khcn, shcn, tk, tktd, tkgt
	from khachhang kh
    join khachhang_sdt khsdt on kh.MaKH = khsdt.MaKH
    join khachhangcanhan khcn on kh.MaKH = khcn.MaKHCN
    join sohuucanhan shcn on khcn.MaKHCN = shcn.MaKHCN
	join taikhoan tk on (tk.MaTK = shcn.MaTKTD or tk.MaTK = shcn.MaTKGT)
    join taikhoantindung tktd on tktd.MaTKTD = shcn.MaTKTD
    join taikhoanguitien tkgt on tkgt.MaTKGT = shcn.MaTKGT
    where kh.MaKH=MaKH;
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaKhachHangCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaKhachHangCaNhan`(
	in MaKH varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
	delete kh, khsdt, khcn, shcn, tk, tktd, tkgt
	from khachhang kh
    join khachhang_sdt khsdt on kh.MaKH = khsdt.MaKH
    join khachhangcanhan khcn on kh.MaKH = khcn.MaKHCN
    join sohuucanhan shcn on khcn.MaKHCN = shcn.MaKHCN
	join taikhoan tk on (tk.MaTK = shcn.MaTKTD or tk.MaTK = shcn.MaTKGT)
    join taikhoantindung tktd on tktd.MaTKTD = shcn.MaTKTD
    join taikhoanguitien tkgt on tkgt.MaTKGT = shcn.MaTKGT
    where kh.MaKH=MaKH;
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaKhachHangToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaKhachHangToChucDoanhNghiep`(
	in MaKH varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
	delete kh, khsdt, khtcdn, shtcdn, tk, tkvt, tkgt
	from khachhang kh
    join khachhang_sdt khsdt on kh.MaKH = khsdt.MaKH
    join khachhangtochucdoanhnghiep khtcdn on kh.MaKH = khtcdn.MaKHTCDN
    join sohuutochucdoanhnghiep shtcdn on khtcdn.MaKHTCDN = shtcdn.MaKHTCDN
	join taikhoan tk on (tk.MaTK = shtcdn.MaTKVT or tk.MaTK = shtcdn.MaTKGT)
    join taikhoanvaytien tkvt on tkvt.MaTKVT = shtcdn.MaTKVT
    join taikhoanguitien tkgt on tkgt.MaTKGT = shtcdn.MaTKGT
    where kh.MaKH=MaKH;
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaNhanVien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaNhanVien`(
	in MaNV varchar(255)
)
BEGIN
	delete from nhanvien where MaNV=MaNV;
    
    delete from nhanvien_sdt where MaNV=MaNV;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaTaiKhoanGuiTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaTaiKhoanGuiTien`(
	in MaTK varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
	delete tk, tkgt, shtcdn
	from taikhoan tk
    join taikhoanguitien tkgt on tk.MaTK = tkgt.MaTKGT
    join sohuutochucdoanhnghiep shtcdn on tkgt.MaTKGT = shtcdn.MaTKGT
    where tk.MaTK=MaTK;
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaTaiKhoanGuiTienCaNhan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaTaiKhoanGuiTienCaNhan`(
	in MaTK varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
    delete from taikhoan tk
    where MaTK = tk.MaTK;
    
	delete from taikhoanguitien tkgt
    where MaTK = tkgt.MaTKGT;
    
	delete from sohuucanhan shcn
    where MaTK = shcn.MaTKGT;
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaTaiKhoanGuiTienToChucDoanhNghiep` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaTaiKhoanGuiTienToChucDoanhNghiep`(
	in MaTK varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
    delete from taikhoan tk
    where MaTK = tk.MaTK;
    
	delete from taikhoanguitien tkgt
    where MaTK = tkgt.MaTKGT;
    
	delete from sohuutochucdoanhnghiep shtcdn
    where MaTK = shtcdn.MaTKGT;
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaTaiKhoanTinDung` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaTaiKhoanTinDung`(
	in MaTK varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
	delete from taikhoan tk
    where MaTK = tk.MaTK;
    
	delete from taikhoantindung tktd
    where MaTK = tktd.MaTKTD;
    
	delete from sohuucanhan shcn
    where MaTK = shcn.MaTKTD;
    
    set FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `XoaTaiKhoanVayTien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `XoaTaiKhoanVayTien`(
	in MaTK varchar(255)
)
BEGIN
	set FOREIGN_KEY_CHECKS = 0;
    
    delete from taikhoan tk
    where MaTK = tk.MaTK;
    
	delete from taikhoanvaytien tkvt
    where MaTK = tkvt.MaTKVT;
    
	delete from sohuutochucdoanhnghiep shtcdn
    where MaTK = shtcdn.MaTKVT;
    
    set FOREIGN_KEY_CHECKS = 1;
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

-- Dump completed on 2022-08-14 15:07:38
