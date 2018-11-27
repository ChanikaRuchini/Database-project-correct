-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 07, 2018 at 04:13 PM
-- Server version: 10.1.30-MariaDB
-- PHP Version: 5.6.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eshop`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cartId` varchar(20) NOT NULL,
  `totalPrice` float DEFAULT NULL,
  `customerId` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `cartId` varchar(20) NOT NULL,
  `productId` varchar(20) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `country` varchar(25) DEFAULT NULL,
  `zip` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cutomers`
--

INSERT INTO `cutomers` (`customerId`, `first_name`, `last_name`, `nic`, `birthday`, `email`, `streetNumber`, `streetName`, `aptName`, `city`, `state`, `country`, `zip`) VALUES
('c1', 'hucsuccc', 'cece', '', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `productId` varchar(20) NOT NULL,
  `wearHouseId` varchar(20) NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_in`
--

CREATE TABLE `log_in` (
  `username` varchar(25) NOT NULL,
  `customerId` varchar(20) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `maincategory`
--

CREATE TABLE `maincategory` (
  `MainCatId` varchar(25) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `categoryId` varchar(25) NOT NULL,
  `link` varchar(300) NOT NULL,
  `brandname` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `variantypes`
--

CREATE TABLE `variantypes` (
  `vTypeId` varchar(20) NOT NULL,
  `variant` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  ADD PRIMARY KEY (`categoryId`);

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
  ADD PRIMARY KEY (`productId`);

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
