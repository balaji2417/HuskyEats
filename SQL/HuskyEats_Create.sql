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
-- Dumping data for table `admin_faculty`
--

LOCK TABLES `admin_faculty` WRITE;
/*!40000 ALTER TABLE `admin_faculty` DISABLE KEYS */;
INSERT INTO `admin_faculty` VALUES (2004,'Business Administration'),(2006,'Academic Affairs '),(2007,'Law school admin'),(2008,'Analytics Lab Admin '),(2010,'Research and Development');
/*!40000 ALTER TABLE `admin_faculty` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `building`
--

LOCK TABLES `building` WRITE;
/*!40000 ALTER TABLE `building` DISABLE KEYS */;
INSERT INTO `building` VALUES (1,'Cuury Student Center',5),(2,'West village',3),(3,'Snell Engineering',4),(4,'Business School',3),(5,'Arts Building',2),(6,'Library',2),(7,'Exp',3),(8,'Richards hall',2),(9,'Dodge hall',1),(10,'Health Center',3),(11,'Technology Hub',4),(12,'Conference Center',2),(13,'ISEC',3),(14,'Shillman',2),(15,'Ell hall',1);
/*!40000 ALTER TABLE `building` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Fast Food','Menu'),(2,'Healthy Options','Menu'),(3,'Beverages','Menu'),(4,'Breakfast','Menu'),(5,'Lunch','Menu'),(6,'Dinner','Menu'),(7,'Snacks','Menu'),(8,'International','Menu'),(9,'Dairy','Grocery'),(10,'Bakery','Grocery'),(11,'Drinks','Grocery'),(12,'Snacks','Grocery'),(13,'Produce','Grocery'),(14,'Pantry','Grocery'),(15,'Protein','Grocery');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('ava_wright','pass18','Student',113),('Daniel_clarison','pass25','Faculty',120),('daniel_lewis','pass13','Faculty',205),('david_wilson','pass5','Student',103),('dua_lipa','pass23','Faculty',118),('emily_brown','pass4','Faculty',202),('emma_young','pass16','Student',111),('james_martin','pass9','Student',106),('jane_smith','pass2','Faculty',201),('jeff_bezos','pass22','Faculty',117),('jennifer_white','pass10','Faculty',204),('john_doe','pass1','Student',101),('Kathleen_Durant','pass21','Faculty',116),('liam_scott','pass19','Student',114),('lisa_anderson','pass8','Student',105),('mia_green','pass20','Student',115),('michael_hall','pass15','Student',110),('mike_johnson','pass3','Student',102),('noah_king','pass17','Student',112),('olivia_harris','pass12','Student',108),('robert_taylor','pass7','Faculty',203),('sarah_lee','pass6','Student',104),('sophia_walker','pass14','Student',109),('william_clark','pass11','Student',107),('yang_hu','pass24','Faculty',119);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`Delivery_agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_agent`
--

LOCK TABLES `delivery_agent` WRITE;
/*!40000 ALTER TABLE `delivery_agent` DISABLE KEYS */;
INSERT INTO `delivery_agent` VALUES ('DA001','Alex','Johnson','1995-05-15','Male','1234567890','09:00:00',1),('DA002','Emma','Davis','1998-08-22','Female','2345678901','10:00:00',1),('DA003','Chris','Wilson','1993-03-10','Male','3456789012','11:00:00',1),('DA004','Sophia','Brown','1997-11-30','Female','4567890123','12:00:00',1),('DA005','Ryan','Taylor','1994-07-18','Male','5678901234','13:00:00',1),('DA006','Olivia','Anderson','1996-02-25','Female','6789012345','14:00:00',1),('DA007','Ethan','Thomas','1999-09-05','Male','7890123456','15:00:00',1),('DA008','Ava','Martinez','1992-12-12','Female','8901234567','16:00:00',1),('DA009','Noah','Garcia','1991-06-20','Male','9012345678','17:00:00',1),('DA010','Isabella','Lopez','1998-04-03','Female','1234567890','18:00:00',1),('DA011','Liam','Lee','1995-10-08','Male','2345678901','19:00:00',1),('DA012','Mia','Gonzalez','1997-01-15','Female','3456789012','20:00:00',1),('DA013','James','Wilson','1993-07-22','Male','4567890123','21:00:00',1),('DA014','Charlotte','Moore','1996-11-11','Female','5678901234','22:00:00',1),('DA015','Benjamin','Jackson','1994-03-28','Male','6789012345','23:00:00',1);
/*!40000 ALTER TABLE `delivery_agent` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `grocery`
--

LOCK TABLES `grocery` WRITE;
/*!40000 ALTER TABLE `grocery` DISABLE KEYS */;
INSERT INTO `grocery` VALUES (4,'Oatmeal Packets',3.5,35),(5,'Bananas',0.99,100),(5,'Bread',2.99,30),(5,'Eggs',4.5,40),(5,'Milk',3.99,50),(5,'Pasta',2.49,45),(5,'Peanut Butter',3.99,25),(6,'Apples',1.29,80),(14,'Fresh Fruit Cups',3.99,30),(18,'Dried Fruits',4.5,30),(18,'Energy Bars',2.5,60),(18,'Trail Mix',3.99,40),(19,'Cereal',3.99,25),(19,'Protein Powder',19.99,15),(23,'Bottled Water',1.5,100),(23,'Coffee Beans',9.99,20),(23,'Iced Tea',2.99,40),(23,'Muffins',2.99,30),(23,'Packaged Sandwiches',5.99,25),(24,'Bottled Water',1.5,100),(24,'Cereal',3.99,25),(24,'Chips',2.99,60),(24,'Chocolate Bars',1.99,70),(24,'Energy Drinks',2.99,50),(24,'Granola Bars',3.99,40),(24,'Gum',1.5,80),(24,'Instant Noodles',0.99,100),(24,'Nuts Mix',4.99,30),(24,'Protein Bars',2.5,60),(24,'Soda',1.99,80),(25,'Hummus',3.99,20),(25,'Protein Shakes',3.5,35),(25,'Salad Kits',4.99,20),(25,'Veggie Sticks',2.99,25),(25,'Yogurt',1.99,40),(29,'Beef Jerky',5.99,25),(29,'Protein Cookies',2.99,40),(29,'Protein Shakes',3.5,35),(31,'Energy Drinks',2.99,50),(31,'Pepsi',2.99,40),(31,'Popcorn',2.5,45);
/*!40000 ALTER TABLE `grocery` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`store_id`,`Food_name`),
  CONSTRAINT `store_menu_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'Caesar Salad','Italian',7.5,'Yes'),(1,'Cheeseburger','American',8.99,'Yes'),(1,'Chicken Sandwich','American',7.99,'Yes'),(1,'Vegetarian Pizza','Italian',10.99,'Yes'),(2,'Fruit Smoothie','Health',4.5,'Yes'),(2,'Turkey Sandwich','American',6.99,'Yes'),(2,'Veggie Wrap','Vegetarian',6.99,'Yes'),(3,'Butter Chicken','Indian',11.99,'Yes'),(3,'Chicken Curry','Indian',10.99,'Yes'),(3,'Naan Bread','Indian',2.99,'Yes'),(3,'Vegetable Biryani','Indian',9.99,'Yes'),(4,'Blueberry Muffin','American',2.99,'Yes'),(4,'Cappuccino','Italian',3.5,'Yes'),(4,'Croissant','French',2.5,'Yes'),(4,'Latte','Italian',3.75,'Yes'),(6,'Fruit Cup','Health',3.99,'Yes'),(6,'Veggie Wrap','Vegetarian',6.99,'Yes'),(6,'Yogurt Parfait','Health',4.5,'Yes'),(7,'Bagel with Cream Cheese','American',3.99,'Yes'),(7,'Coffee','American',2.5,'Yes'),(7,'Glazed Donut','American',1.99,'Yes'),(8,'Grilled Cheese','American',5.99,'Yes'),(8,'Tomato Soup','American',4.99,'Yes'),(8,'Tuna Salad Sandwich','American',7.99,'Yes'),(9,'Caesar Salad','Italian',7.5,'Yes'),(9,'Garlic Breadsticks','Italian',4.99,'Yes'),(9,'Margherita Pizza','Italian',11.99,'Yes'),(9,'Pepperoni Pizza','Italian',12.99,'Yes'),(10,'Chicken Sandwich','American',7.99,'Yes'),(10,'Chocolate Milkshake','American',4.99,'Yes'),(10,'French Fries','American',3.99,'Yes'),(11,'Falafel Wrap','Middle Eastern',7.99,'Yes'),(11,'Greek Salad','Greek',8.5,'Yes'),(11,'Hummus Plate','Middle Eastern',6.99,'Yes'),(12,'Grilled Panini','Italian',8.99,'Yes'),(12,'Iced Tea','American',2.5,'Yes'),(12,'Vegetable Soup','International',5.99,'Yes'),(13,'Baklava','Middle Eastern',3.99,'Yes'),(13,'Beef Shawarma','Middle Eastern',9.99,'Yes'),(13,'Chicken Shawarma','Middle Eastern',9.99,'Yes'),(13,'Falafel Plate','Middle Eastern',8.99,'Yes'),(14,'Cobb Salad','American',9.99,'Yes'),(14,'Grilled Chicken Plate','American',11.99,'Yes'),(14,'Vegetarian Pasta','Italian',10.99,'Yes'),(15,'Chocolate Chip Cookie','American',1.5,'Yes'),(15,'Meatball Sub','Italian',8.99,'Yes'),(15,'Turkey Breast Sub','American',7.99,'Yes'),(15,'Veggie Delite Sub','Vegetarian',6.99,'Yes');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `menu_category`
--

LOCK TABLES `menu_category` WRITE;
/*!40000 ALTER TABLE `menu_category` DISABLE KEYS */;
INSERT INTO `menu_category` VALUES (1,1,'Cheeseburger'),(2,1,'Caesar Salad'),(1,1,'Chicken Sandwich'),(1,1,'Vegetarian Pizza'),(5,2,'Turkey Sandwich'),(3,2,'Fruit Smoothie'),(2,2,'Veggie Wrap'),(8,3,'Chicken Curry'),(8,3,'Butter Chicken'),(8,3,'Vegetable Biryani'),(8,3,'Naan Bread'),(3,4,'Cappuccino'),(3,4,'Latte'),(4,4,'Blueberry Muffin'),(4,4,'Croissant'),(2,6,'Veggie Wrap'),(2,6,'Fruit Cup'),(2,6,'Yogurt Parfait'),(4,7,'Glazed Donut'),(3,7,'Coffee'),(4,7,'Bagel with Cream Cheese'),(5,8,'Tuna Salad Sandwich'),(5,8,'Grilled Cheese'),(5,8,'Tomato Soup'),(1,9,'Pepperoni Pizza'),(1,9,'Margherita Pizza'),(7,9,'Garlic Breadsticks'),(2,9,'Caesar Salad'),(1,10,'Chicken Sandwich'),(7,10,'French Fries'),(3,10,'Chocolate Milkshake'),(2,11,'Greek Salad'),(8,11,'Hummus Plate'),(8,11,'Falafel Wrap'),(2,12,'Vegetable Soup'),(5,12,'Grilled Panini'),(3,12,'Iced Tea'),(8,13,'Beef Shawarma'),(8,13,'Chicken Shawarma'),(8,13,'Falafel Plate'),(7,13,'Baklava'),(6,14,'Grilled Chicken Plate'),(6,14,'Vegetarian Pasta'),(2,14,'Cobb Salad'),(5,15,'Meatball Sub'),(5,15,'Turkey Breast Sub'),(2,15,'Veggie Delite Sub'),(7,15,'Chocolate Chip Cookie');
/*!40000 ALTER TABLE `menu_category` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `neu_employee`
--

LOCK TABLES `neu_employee` WRITE;
/*!40000 ALTER TABLE `neu_employee` DISABLE KEYS */;
INSERT INTO `neu_employee` VALUES (2001,'Jane','Smith','1980-05-15','jane.smith@northeastern.edu','Female','College of Engineering','jane_smith'),(2002,'Emily','Brown','1975-08-22','emily.brown@northeastern.edu','Female','College of Arts and  Science','emily_brown'),(2003,'Robert','Taylor','1982-03-10','robert.taylor@northeastern.edu','Male','College of Professional Studies','robert_taylor'),(2004,'Jennifer','White','1978-11-30','jennifer.white@northeastern.edu','Female','College of Business','jennifer_white'),(2005,'Daniel','Lewis','1985-07-18','daniel.lewis@northeastern.edu','Male','Khoury college of Computer Sciences','daniel_lewis'),(2006,'Kathleen','Durant','1970-02-21','kathleen.durant@northeastern.edu','Female','College of Engineering','Kathleen_Durant'),(2007,'Jeff','bezos','1980-05-14','jeff.bezos@northeastern.edu','Male','School of Law','jeff_bezos'),(2008,'Dua','lipa','1990-06-18','dua.lipa@northeastern.edu','Female','College of Business','dua_lipa'),(2009,'Yang ','Hu','1978-05-16','yang.hu@northeastern.edu','Male','Khoury college of Computer Sciences','yang_hu'),(2010,'Daniel','Clarison','1985-07-02','daniel.clarison@northeastern.edu','Male','College of Arts and  Science','Daniel_clarison');
/*!40000 ALTER TABLE `neu_employee` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `shops`
--

LOCK TABLES `shops` WRITE;
/*!40000 ALTER TABLE `shops` DISABLE KEYS */;
/*!40000 ALTER TABLE `shops` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,'Campus Cafe','07:00:00','22:00:00',1),(2,'Student Snacks','08:00:00','20:00:00',1),(3,'Curry Market','09:00:00','21:00:00',1),(4,'College Coffee Shop','06:30:00','23:00:00',1),(5,'Campus Convenience','07:30:00','23:30:00',1),(6,'Science Snacks','08:00:00','18:00:00',2),(7,'Dunkin Donuts','11:00:00','15:00:00',2),(8,'Experiment Eats','07:30:00','19:30:00',2),(9,'Engineering Eats','07:30:00','20:00:00',3),(10,'Tech Bites','08:00:00','19:00:00',3),(11,'Robotics Refreshments','09:00:00','18:00:00',3),(12,'Circuit Cafe','07:00:00','21:00:00',3),(13,'Boston shawarma','08:30:00','19:00:00',4),(14,'Nu dining CafÃ©','07:00:00','20:00:00',4),(15,'Subway','09:00:00','18:00:00',4),(16,'coffee house ','09:00:00','21:00:00',5),(17,'Boston halal','10:00:00','20:00:00',5),(18,'Library Lounge','10:00:00','23:00:00',6),(19,'Study Snacks','08:00:00','22:00:00',6),(20,'Sports Bar & Grill','11:00:00','23:30:00',7),(21,'Fitness Fuel','06:00:00','22:00:00',7),(22,'Internatinal cuisines','07:00:00','21:00:00',7),(23,'starbucks','06:00:00','00:00:00',8),(24,'college convinience','06:00:00','00:00:00',9),(25,'Healthy Bites','07:00:00','20:00:00',10),(26,'Halal Shacks','08:00:00','22:00:00',11),(27,'Coding Cafe','07:30:00','23:00:00',11),(28,'Data Diner','09:00:00','21:00:00',11),(29,'AI Appetizers','10:00:00','20:00:00',11),(30,'Conference Cafe','07:30:00','18:00:00',12),(31,'Besto Snack','09:00:00','17:00:00',12),(32,'Pizza hut','06:30:00','21:00:00',13),(33,'Lab Lunch','11:00:00','15:00:00',13),(34,'Science Sips','08:00:00','20:00:00',13),(35,'Choolah','08:00:00','20:00:00',14),(36,'Startup Snacks','07:30:00','21:00:00',14),(37,'Dining Hall','11:00:00','14:00:00',15);
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `store_category`
--

LOCK TABLES `store_category` WRITE;
/*!40000 ALTER TABLE `store_category` DISABLE KEYS */;
INSERT INTO `store_category` VALUES (9,5,'Milk'),(10,5,'Bread'),(9,5,'Eggs'),(13,5,'Bananas'),(13,6,'Apples'),(14,5,'Peanut Butter'),(14,5,'Pasta'),(11,23,'Coffee Beans'),(11,23,'Bottled Water'),(10,23,'Packaged Sandwiches'),(10,23,'Muffins'),(11,23,'Iced Tea'),(12,24,'Chips'),(11,24,'Soda'),(11,24,'Bottled Water'),(11,24,'Energy Drinks'),(15,24,'Protein Bars'),(14,24,'Instant Noodles'),(14,24,'Cereal'),(12,24,'Granola Bars'),(12,24,'Chocolate Bars'),(12,24,'Gum'),(12,24,'Nuts Mix'),(13,14,'Fresh Fruit Cups'),(9,25,'Yogurt'),(13,25,'Salad Kits'),(15,25,'Protein Shakes'),(13,25,'Veggie Sticks'),(14,25,'Hummus'),(12,18,'Energy Bars'),(12,18,'Trail Mix'),(13,18,'Dried Fruits'),(14,19,'Cereal'),(14,4,'Oatmeal Packets'),(15,19,'Protein Powder'),(15,29,'Protein Shakes'),(12,29,'Protein Cookies'),(15,29,'Beef Jerky'),(11,31,'Energy Drinks'),(12,31,'Popcorn'),(11,31,'Pepsi');
/*!40000 ALTER TABLE `store_category` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1001,'John','Doe','2000-05-15','john.doe@northeastern.edu','123 Main St','Boston',2115,'john_doe'),(1002,'Mike','Johnson','2001-08-22','mike.johnson@northeastern.edu','456 Elm St','Boston',2116,'mike_johnson'),(1003,'David','Wilson','1999-03-10','david.wilson@northeastern.edu','789 Oak St','Boston',2117,'david_wilson'),(1004,'Sarah','Lee','2002-11-30','sarah.lee@northeastern.edu','101 Pine St','Boston',2118,'sarah_lee'),(1005,'Lisa','Anderson','2000-07-18','lisa.anderson@northeastern.edu','202 Maple St','Boston',2119,'lisa_anderson'),(1006,'James','Martin','2001-02-25','james.martin@northeastern.edu','303 Cedar St','Boston',2120,'james_martin'),(1007,'William','Clark','1999-09-05','william.clark@northeastern.edu','404 Birch St','Boston',2121,'william_clark'),(1008,'Olivia','Harris','2002-12-12','olivia.harris@northeastern.edu','505 Walnut St','Boston',2122,'olivia_harris'),(1009,'Sophia','Walker','2000-06-20','sophia.walker@northeastern.edu','606 Cherry St','Boston',2123,'sophia_walker'),(1010,'Michael','Hall','2001-04-03','michael.hall@northeastern.edu','707 Spruce St','Boston',2124,'michael_hall'),(1011,'Emma','Young','1999-10-08','emma.young@northeastern.edu','808 Ash St','Boston',2125,'emma_young'),(1012,'Noah','King','2002-01-15','noah.king@northeastern.edu','909 Beech St','Boston',2126,'noah_king'),(1013,'Ava','Wright','2000-07-22','ava.wright@northeastern.edu','1010 Willow St','Boston',2127,'ava_wright'),(1014,'Liam','Scott','2001-11-11','liam.scott@northeastern.edu','1111 Poplar St','Boston',2128,'liam_scott'),(1015,'Mia','Green','1999-03-28','mia.green@northeastern.edu','1212 Sycamore St','Boston',2129,'mia_green');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `teaching_staff`
--

LOCK TABLES `teaching_staff` WRITE;
/*!40000 ALTER TABLE `teaching_staff` DISABLE KEYS */;
INSERT INTO `teaching_staff` VALUES (2001,'Ms, Phd','Data Analytics'),(2002,'Ms, Phd','Economics'),(2003,'Ms, Phd','Regulatory Affairs'),(2005,'Ms, Phd','Engineering Management'),(2009,'Ms, Phd','Computer Science');
/*!40000 ALTER TABLE `teaching_staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-13 13:45:50
