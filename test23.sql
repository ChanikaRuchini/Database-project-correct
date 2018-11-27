-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 25, 2018 at 08:58 AM
-- Server version: 10.1.35-MariaDB
-- PHP Version: 7.2.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test23`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_cc` (IN `date` DATE)  NO SQL
BEGIN
    IF date<sysdate() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'invalid date!';
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_nic` (IN `nic` VARCHAR(10))  NO SQL
BEGIN
    IF char_length(nic)!=10 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'check constraint on cutomers.nic failed';
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_pn` (IN `pn` VARCHAR(12))  NO SQL
BEGIN
    IF pn!=12 or SUBSTRING(pn,1,1)!="+" THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'invalid Phone number';
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_price` (IN `totalPrice` FLOAT)  NO SQL
BEGIN
    IF totalPrice<0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'check constraint on cart.totalPrice failed';
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_product` (IN `value` FLOAT, IN `value2` FLOAT)  NO SQL
BEGIN
    IF value<0 or value2<0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'check constraint on cannot ne negative';
    END IF;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CheckLogin` (`password` VARCHAR(40), `username` VARCHAR(40)) RETURNS TINYINT(1) begin
 
   
   IF(select  count(*)  from log_in where log_in.password=sha1(password) and log_in.username=username) then
      return TRUE;
   ELSE
     return FALSE;

   END IF;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `check_login` (`password` VARCHAR(40), `username` VARCHAR(40)) RETURNS TINYINT(1) begin
   declare s_count int(4); 
   select  count(*) into s_count from log_in where log_in.password=sha1(password) and log_in.username=username;
   return true;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `login_verification` (`password` VARCHAR(40), `username` VARCHAR(40)) RETURNS TINYINT(1) begin
   IF(select  count(*)  from log_in where log_in.password=password and log_in.username=username) THEN
      return True;
  
   ELSE
     return False;

   END IF;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Varient_change_Price` (`CartId` VARCHAR(40), `productId` VARCHAR(40), `varient` VARCHAR(40)) RETURNS DECIMAL(8,2) begin
   IF(varient != null) THEN
       select unitPrice into @unitpriceold from cart_items where cart_items.cartId=cartId and cart_items.productId=productId;
	   select AddingPrice into @addition from productVarient where productVarient.productId=productId and productVarient.varientValue=varient;
	   UPDATE Cart_items set cart_items.unitPrice=@unitpriceold + @addition where cart_items.cartId=cartId;
       return @unitpriceold+@addition;
   END IF;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `verification` (`psw` VARCHAR(40), `username` VARCHAR(40)) RETURNS VARCHAR(3) CHARSET latin1 begin
   declare s_count  int(4); 
   select  count(*) into s_count from log_in where log_in.password=sha1(psw)  and log_in.username=username;
  
     return N;

 
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cartId` varchar(255) NOT NULL,
  `customerId` varchar(255) DEFAULT NULL,
  `totalPrice` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cartId`, `customerId`, `totalPrice`) VALUES
('1', 'ES0001', 74500);

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `cartId` varchar(255) NOT NULL,
  `productId` varchar(20) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unitPrice` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`cartId`, `productId`, `quantity`, `unitPrice`) VALUES
('1', 'E1', 1, 74500);

--
-- Triggers `cart_items`
--
DELIMITER $$
CREATE TRIGGER `update_price_cart_delete` AFTER DELETE ON `cart_items` FOR EACH ROW BEGIN
	     UPDATE cart set totalPrice=totalPrice-old.unitPrice*old.quantity where cart.cartid=old.cartid;
       END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_price_on_cart` BEFORE INSERT ON `cart_items` FOR EACH ROW BEGIN
	     IF(select * from cart_items where cartId=new.cartId and productId=new.productId) THEN
	        	SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'duplicate Entry!';
		 ELSE
		   select price into @unitprice from product where productId=new.productId;
		   set new.Unitprice= @unitprice;
		   set new.quantity=1;
		   UPDATE Cart set totalPrice=totalPrice+new.unitPrice*new.quantity where cart.cartid=new.cartid;
		 END IF;
       END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_price_on_cart_update` AFTER UPDATE ON `cart_items` FOR EACH ROW BEGIN
	   IF(new.quantity!=old.quantity and new.unitPrice=old.UnitPrice) THEN
	    IF new.quantity>old.quantity then 
	      UPDATE Cart set totalPrice=totalPrice+old.UnitPrice*(new.quantity-old.quantity) where cart.cartid=old.cartid;
	    ELSE IF new.quantity<old.quantity THEN
	      UPDATE Cart set totalPrice=totalPrice-old.unitPrice*(old.quantity-new.quantity) where cart.cartid=old.cartid;
          END IF;END IF;
	   ELSE IF(new.quantity=old.quantity and new.unitPrice!=old.unitPrice) THEN
          Update Cart set totalPrice=totalPrice-old.quantity*old.unitPrice+new.unitPrice*quantity;
	   END IF;END IF;
       END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryId` varchar(20) NOT NULL,
  `name` varchar(30) NOT NULL,
  `MainCatId` varchar(25) NOT NULL,
  `link` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryId`, `name`, `MainCatId`, `link`) VALUES
('c1', 'phones', '1', '/product/c1'),
('c2', 'Laptops', '1', '/product/c2'),
('c3', 'puzzles', '2', '/product/c3'),
('c4', 'building blocks', '2', '/product/c4');

-- --------------------------------------------------------

--
-- Table structure for table `ccdetails`
--

CREATE TABLE `ccdetails` (
  `cardId` varchar(20) NOT NULL,
  `customerId` varchar(20) DEFAULT NULL,
  `CCNumber` varchar(20) NOT NULL,
  `cvv` decimal(3,0) NOT NULL,
  `expiredate` date NOT NULL,
  `billingAddress` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `ccdetails`
--
DELIMITER $$
CREATE TRIGGER `check_cc` BEFORE INSERT ON `ccdetails` FOR EACH ROW CALL check_cc(new.expiredate)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ccpayment`
--

CREATE TABLE `ccpayment` (
  `paymentId` varchar(25) NOT NULL,
  `cardId` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cutomers`
--

CREATE TABLE `cutomers` (
  `customerId` varchar(20) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `nic` varchar(10) NOT NULL,
  `birthday` date DEFAULT NULL,
  `email` varchar(65) NOT NULL,
  `streetNumber` varchar(25) DEFAULT NULL,
  `streetName` varchar(100) DEFAULT NULL,
  `aptName` varchar(25) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `country` varchar(25) NOT NULL,
  `zip` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cutomers`
--

INSERT INTO `cutomers` (`customerId`, `first_name`, `last_name`, `nic`, `birthday`, `email`, `streetNumber`, `streetName`, `aptName`, `city`, `state`, `country`, `zip`) VALUES
('ES0001', 'Pinsara', 'Weerasinghe', '950840129v', '1995-03-24', 'pinsara@gmail.com', 'No:57', 'Savijaya road', 'Edment Apartment', 'Wellawaya', 'Uva Province', 'sri lanka', '9200');

--
-- Triggers `cutomers`
--
DELIMITER $$
CREATE TRIGGER `checking` BEFORE INSERT ON `cutomers` FOR EACH ROW CALL check_nic(new.nic)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `productId` varchar(20) NOT NULL,
  `wearHouseId` varchar(20) NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `inventory`
--
DELIMITER $$
CREATE TRIGGER `check_quntity` BEFORE INSERT ON `inventory` FOR EACH ROW call check_price(new.quantity)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log_in`
--

CREATE TABLE `log_in` (
  `username` varchar(25) NOT NULL,
  `customerId` varchar(20) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `log_in`
--

INSERT INTO `log_in` (`username`, `customerId`, `password`) VALUES
('malintha', 'ES0001', '1c859c61f27928bf851a761b2e081b7c54919a76');

--
-- Triggers `log_in`
--
DELIMITER $$
CREATE TRIGGER `before_log_in_insert` BEFORE INSERT ON `log_in` FOR EACH ROW BEGIN
	    IF char_length(new.password)<8 THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'password length is not enough!';
		ELSE
         SET NEW.password= SHA1(NEW.password);
		END IF;
         
      END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `maincategory`
--

CREATE TABLE `maincategory` (
  `MainCatId` varchar(25) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `maincategory`
--

INSERT INTO `maincategory` (`MainCatId`, `name`, `link`) VALUES
('1', 'Electronics', 'assets/images/electronic.jpg'),
('2', 'Toys', 'assets/images/toy.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `ondeliverypayment`
--

CREATE TABLE `ondeliverypayment` (
  `paymentReciepeint` varchar(20) NOT NULL,
  `paymentId` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderId` varchar(20) NOT NULL,
  `customerId` varchar(20) DEFAULT NULL,
  `deliverDate` date DEFAULT NULL,
  `deliverAddress` varchar(255) NOT NULL,
  `deliverStatus` varchar(25) DEFAULT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderId`, `customerId`, `deliverDate`, `deliverAddress`, `deliverStatus`, `quantity`) VALUES
('005', 'ES0001', '2018-11-03', 'rfrf', 'rfr4', 42);

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `before_order_insert` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
	    IF new.deliverDate<sysDate() THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid Deliver Date!';
		ELSE IF new.quantity <=0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid Quantity Value!';
		END IF;
         End IF;
      END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `orderId` varchar(20) NOT NULL,
  `productId` varchar(20) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `paymentId` varchar(20) NOT NULL,
  `orderId` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `phonenumbers`
--

CREATE TABLE `phonenumbers` (
  `customerId` varchar(20) NOT NULL,
  `phoneNumber` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `phonenumbers`
--
DELIMITER $$
CREATE TRIGGER `check_phone` BEFORE INSERT ON `phonenumbers` FOR EACH ROW CALL check_pn(new.phoneNumber)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `productId` varchar(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `weight` float NOT NULL,
  `SKU` varchar(100) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `price` float NOT NULL,
  `categoryId` varchar(20) DEFAULT NULL,
  `link` varchar(300) DEFAULT NULL,
  `brandname` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productId`, `title`, `weight`, `SKU`, `description`, `price`, `categoryId`, `link`, `brandname`) VALUES
('E1', 'i phone 7 black', 0.5, 'sku1', 'I phone 7 black,128GB Factory unlocked Full set with same Imei box Brandnew condition With 4n to 4n warranty ', 74500, 'c1', '../assets/images/phones/iphone.png', 'apple'),
('E2', 'Huawei Mate SE', 1, 'sku2', 'GSM / 4G LTE Compatible 16MP & 2MP Dual Rear Cameras 8MP Front Camera HiSilicon Kirin 659 Octa-Core Chipset', 50000, 'c1', '../assets/images/phones/1.jpg', 'Huawei');

--
-- Triggers `product`
--
DELIMITER $$
CREATE TRIGGER `after_price_update_cart` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
	    IF old.price != new.price THEN
		    UPDATE cart_items set UnitPrice=new.price where productId=old.productId; 
		ELSE IF new.weight<=0 THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid weight value!';
		ELSE IF new.price<=0 THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid weight price!';	
        END IF;
		END IF;
		END IF;
       END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `checking_price` BEFORE INSERT ON `product` FOR EACH ROW CALL check_product(new.price,new.weight)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `productvarient`
--

CREATE TABLE `productvarient` (
  `productId` varchar(20) NOT NULL,
  `varientValue` varchar(20) NOT NULL,
  `vTypeId` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `productvarient`
--

INSERT INTO `productvarient` (`productId`, `varientValue`, `vTypeId`) VALUES
('E1', 'red', 'v1'),
('E2', 'red', 'v1'),
('E1', '32GB', 'v2'),
('E2', '64GB', 'v2');

-- --------------------------------------------------------

--
-- Table structure for table `variantypes`
--

CREATE TABLE `variantypes` (
  `vTypeId` varchar(20) NOT NULL,
  `variant` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `variantypes`
--

INSERT INTO `variantypes` (`vTypeId`, `variant`) VALUES
('v1', 'color'),
('v2', 'capacity');

-- --------------------------------------------------------

--
-- Table structure for table `wearhouse`
--

CREATE TABLE `wearhouse` (
  `wearHouseId` varchar(20) NOT NULL,
  `country` varchar(30) NOT NULL,
  `state` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cartId`),
  ADD UNIQUE KEY `customerId` (`customerId`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`cartId`,`productId`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryId`),
  ADD KEY `MainCatId` (`MainCatId`);

--
-- Indexes for table `ccdetails`
--
ALTER TABLE `ccdetails`
  ADD PRIMARY KEY (`cardId`),
  ADD KEY `customerId` (`customerId`);

--
-- Indexes for table `ccpayment`
--
ALTER TABLE `ccpayment`
  ADD PRIMARY KEY (`paymentId`,`cardId`),
  ADD KEY `cardId` (`cardId`);

--
-- Indexes for table `cutomers`
--
ALTER TABLE `cutomers`
  ADD PRIMARY KEY (`customerId`),
  ADD UNIQUE KEY `nic` (`nic`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`productId`,`wearHouseId`),
  ADD KEY `wearHouseId` (`wearHouseId`);

--
-- Indexes for table `log_in`
--
ALTER TABLE `log_in`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `customerId` (`customerId`);

--
-- Indexes for table `maincategory`
--
ALTER TABLE `maincategory`
  ADD PRIMARY KEY (`MainCatId`);

--
-- Indexes for table `ondeliverypayment`
--
ALTER TABLE `ondeliverypayment`
  ADD PRIMARY KEY (`paymentReciepeint`),
  ADD KEY `paymentId` (`paymentId`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderId`),
  ADD KEY `customerId` (`customerId`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`orderId`,`productId`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`paymentId`),
  ADD KEY `orderId` (`orderId`);

--
-- Indexes for table `phonenumbers`
--
ALTER TABLE `phonenumbers`
  ADD PRIMARY KEY (`customerId`,`phoneNumber`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`productId`),
  ADD KEY `categoryId` (`categoryId`);

--
-- Indexes for table `productvarient`
--
ALTER TABLE `productvarient`
  ADD PRIMARY KEY (`varientValue`,`productId`),
  ADD KEY `vTypeId` (`vTypeId`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `variantypes`
--
ALTER TABLE `variantypes`
  ADD PRIMARY KEY (`vTypeId`);

--
-- Indexes for table `wearhouse`
--
ALTER TABLE `wearhouse`
  ADD PRIMARY KEY (`wearHouseId`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `cutomers` (`customerId`);

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`);

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `category_ibfk_1` FOREIGN KEY (`MainCatId`) REFERENCES `maincategory` (`MainCatId`);

--
-- Constraints for table `ccdetails`
--
ALTER TABLE `ccdetails`
  ADD CONSTRAINT `ccdetails_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `cutomers` (`customerId`);

--
-- Constraints for table `ccpayment`
--
ALTER TABLE `ccpayment`
  ADD CONSTRAINT `ccpayment_ibfk_1` FOREIGN KEY (`paymentId`) REFERENCES `payment` (`paymentId`),
  ADD CONSTRAINT `ccpayment_ibfk_2` FOREIGN KEY (`cardId`) REFERENCES `ccdetails` (`cardId`);

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`),
  ADD CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`wearHouseId`) REFERENCES `wearhouse` (`wearHouseId`);

--
-- Constraints for table `log_in`
--
ALTER TABLE `log_in`
  ADD CONSTRAINT `log_in_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `cutomers` (`customerId`);

--
-- Constraints for table `ondeliverypayment`
--
ALTER TABLE `ondeliverypayment`
  ADD CONSTRAINT `ondeliverypayment_ibfk_1` FOREIGN KEY (`paymentId`) REFERENCES `payment` (`paymentId`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `cutomers` (`customerId`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`);

--
-- Constraints for table `phonenumbers`
--
ALTER TABLE `phonenumbers`
  ADD CONSTRAINT `phonenumbers_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `cutomers` (`customerId`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`);

--
-- Constraints for table `productvarient`
--
ALTER TABLE `productvarient`
  ADD CONSTRAINT `productvarient_ibfk_1` FOREIGN KEY (`vTypeId`) REFERENCES `variantypes` (`vTypeId`),
  ADD CONSTRAINT `productvarient_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
