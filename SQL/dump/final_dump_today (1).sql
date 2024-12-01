CREATE DATABASE  IF NOT EXISTS `husky_eats` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `husky_eats`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: husky_eats
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `admin_faculty`
--

DROP TABLE IF EXISTS `admin_faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_faculty` (
  `Faculty_id` int NOT NULL,
  `Admin_Department_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Faculty_id`),
  CONSTRAINT `Admin_Faculty_FK` FOREIGN KEY (`Faculty_id`) REFERENCES `neu_employee` (`Faculty_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `building`
--

DROP TABLE IF EXISTS `building`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `building` (
  `Building_id` int NOT NULL,
  `Building_name` varchar(100) DEFAULT NULL,
  `store_capacity` int DEFAULT NULL,
  PRIMARY KEY (`Building_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `Cart_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `items_name` varchar(100) DEFAULT NULL,
  `items_price` float DEFAULT NULL,
  `items_qty` int DEFAULT NULL,
  `is_order_placed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`Cart_id`),
  KEY `cart_user_fk` (`username`),
  CONSTRAINT `cart_user_fk` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `Category_id` int NOT NULL,
  `Category_name` varchar(100) DEFAULT NULL,
  `Category_Belonging` enum('Menu','Grocery') DEFAULT NULL,
  PRIMARY KEY (`Category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `username` varchar(50) NOT NULL,
  `user_password` varchar(66) DEFAULT NULL,
  `user_type` enum('Faculty','Student') DEFAULT NULL,
  `Reference_Id` int DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delivery_agent`
--

DROP TABLE IF EXISTS `delivery_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_agent` (
  `Delivery_agent_id` varchar(50) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `DOB` date NOT NULL,
  `Gender` enum('Male','Female') DEFAULT NULL,
  `Phone_no` varchar(100) DEFAULT NULL,
  `Availability_time` time DEFAULT NULL,
  `Availability` tinyint(1) DEFAULT '1',
  `Password` varchar(20) NOT NULL,
  PRIMARY KEY (`Delivery_agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grocery`
--

DROP TABLE IF EXISTS `grocery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grocery` (
  `store_id` int NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `item_price` float DEFAULT NULL,
  `item_qty` int DEFAULT NULL,
  PRIMARY KEY (`store_id`,`item_name`),
  CONSTRAINT `store_grocery_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `store_id` int NOT NULL,
  `Food_name` varchar(100) NOT NULL,
  `Food_cuisine` varchar(100) DEFAULT NULL,
  `Price` float DEFAULT NULL,
  `Availability` enum('Yes','No') DEFAULT NULL,
  `FOOD_IMAGE` mediumblob,
  PRIMARY KEY (`store_id`,`Food_name`),
  CONSTRAINT `store_menu_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `menu_category`
--

DROP TABLE IF EXISTS `menu_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_category` (
  `Category_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `Food_name` varchar(100) DEFAULT NULL,
  KEY `menu_cat_fk_store` (`store_id`,`Food_name`),
  KEY `menu_cat_fk` (`Category_id`),
  CONSTRAINT `menu_cat_fk` FOREIGN KEY (`Category_id`) REFERENCES `category` (`Category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_cat_fk_store` FOREIGN KEY (`store_id`, `Food_name`) REFERENCES `menu` (`store_id`, `Food_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `neu_employee`
--

DROP TABLE IF EXISTS `neu_employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `neu_employee` (
  `Faculty_ID` int NOT NULL,
  `First_name` varchar(255) DEFAULT NULL,
  `Last_name` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Email` varchar(175) DEFAULT NULL,
  `Gender` enum('Male','Female') DEFAULT NULL,
  `College_Name` varchar(100) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Faculty_ID`),
  KEY `faculty_username_fk_1` (`username`),
  CONSTRAINT `faculty_username_fk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `Delivery_agent_id` varchar(50) DEFAULT NULL,
  `Total_amount` float DEFAULT NULL,
  `delivery_location` varchar(100) DEFAULT NULL,
  `iaAssigned` tinyint(1) DEFAULT '0',
  `isDelivered` tinyint(1) DEFAULT '0',
  `OTP` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `orders_cart_orders_fk` (`cart_id`),
  KEY `user_cart_orders_fk` (`username`),
  KEY `delivery_cart_orders_fk` (`Delivery_agent_id`),
  CONSTRAINT `delivery_cart_orders_fk` FOREIGN KEY (`Delivery_agent_id`) REFERENCES `delivery_agent` (`Delivery_agent_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_cart_orders_fk` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`Cart_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_cart_orders_fk` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating` (
  `rating_num` int DEFAULT NULL,
  `store_id` int NOT NULL,
  `feedback` varchar(500) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`store_id`),
  KEY `rating_username_fk` (`username`),
  CONSTRAINT `rating_store_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rating_username_fk` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shops`
--

DROP TABLE IF EXISTS `shops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shops` (
  `Store_id` int NOT NULL,
  `Username` varchar(50) NOT NULL,
  PRIMARY KEY (`Store_id`,`Username`),
  KEY `Username` (`Username`),
  CONSTRAINT `shops_ibfk_1` FOREIGN KEY (`Store_id`) REFERENCES `store` (`store_id`),
  CONSTRAINT `shops_ibfk_2` FOREIGN KEY (`Username`) REFERENCES `customer` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `store_id` int NOT NULL,
  `store_name` varchar(50) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `Building_id` int DEFAULT NULL,
  PRIMARY KEY (`store_id`),
  KEY `store_building_fk` (`Building_id`),
  CONSTRAINT `store_building_fk` FOREIGN KEY (`Building_id`) REFERENCES `building` (`Building_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store_category`
--

DROP TABLE IF EXISTS `store_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_category` (
  `Category_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `item_name` varchar(100) DEFAULT NULL,
  KEY `groc_cat_fk_store` (`store_id`,`item_name`),
  KEY `groc_cat_fk` (`Category_id`),
  CONSTRAINT `groc_cat_fk` FOREIGN KEY (`Category_id`) REFERENCES `category` (`Category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `groc_cat_fk_store` FOREIGN KEY (`store_id`, `item_name`) REFERENCES `grocery` (`store_id`, `item_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `NUID` int NOT NULL,
  `First_Name` varchar(255) DEFAULT NULL,
  `Last_Name` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Email_Address` varchar(175) DEFAULT NULL,
  `Street_name` varchar(100) DEFAULT NULL,
  `City` varchar(150) DEFAULT NULL,
  `Zipcode` int DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`NUID`),
  KEY `student_username_fk_1` (`username`),
  CONSTRAINT `student_username_fk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teaching_staff`
--

DROP TABLE IF EXISTS `teaching_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teaching_staff` (
  `Faculty_id` int NOT NULL,
  `Educational_Qualifications` varchar(10) NOT NULL,
  `Department_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Faculty_id`,`Educational_Qualifications`),
  CONSTRAINT `Teaching_Staff_FK_1` FOREIGN KEY (`Faculty_id`) REFERENCES `neu_employee` (`Faculty_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'husky_eats'
--

--
-- Dumping routines for database 'husky_eats'
--
/*!50003 DROP FUNCTION IF EXISTS `get_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_name`(p_username varchar(50),ref_id INT,user_type varchar(20)) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE users_name VARCHAR(100) DEFAULT "";
	IF user_type = 'Student' THEN 
		select concat(first_name," ",last_name) INTO users_name from student s 
        join customer c
        ON c.username = s.username 
        WHERE c.username = p_username;
	END IF;
	RETURN users_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CustomerSignup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CustomerSignup`(
    IN p_username VARCHAR(50),
    IN p_user_password VARCHAR(66),
    IN p_user_type ENUM('Faculty', 'Student'),
    IN p_reference_id INT)
BEGIN
    -- Check if the username already exists
    IF EXISTS (SELECT 1 FROM customer WHERE username = p_username or reference_id = p_reference_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Record already exists change either the reference id or username.';
    ELSE
        -- Insert the new customer into the table
        INSERT INTO customer (username, user_password, user_type, Reference_Id)
        VALUES (p_username, p_user_password, p_user_type, p_reference_id);
    END IF;
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

-- Dump completed on 2024-11-30 17:25:04
