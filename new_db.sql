drop database testeshop;
create database if not exists testeshop;

use testeshop;



create table if not exists cutomers(
	customerId varchar(20),
	first_name varchar(20) not null,
	last_name varchar(20) ,
	nic varchar(10) not null unique ,
	birthday date,
	email varchar(65) not null,
	streetNumber varchar(25),
	streetName varchar(100),
	aptName varchar(25),
	city varchar(25),
	state varchar(25),
	country varchar(25) not null,
	zip varchar(6),
	primary key(customerId)
);


create table if not exists phoneNumbers(
	customerId varchar(20),
	phoneNumber varchar(10),
	primary key(customerId,phoneNumber),
	foreign key (customerId) references cutomers(customerId)

);

CREATE TABLE `maincategory` (
  `MainCatId` varchar(25) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
    primary key(MainCatId)
);

create table if not exists Log_in(
	username varchar(25),
	customerId varchar(20) unique,
	password varchar(100),
	primary key (username),
	foreign key (customerId) references cutomers(customerId)
);





create table if not exists orders (
	orderId varchar(20),
	customerId varchar(20) ,
	deliverDate date ,
	deliverAddress varchar(255) not null,
	deliverStatus varchar(25),
	quantity int not null,
	primary key(orderId),
	foreign key (customerId) references cutomers(customerId)
);



create table if not exists category(
	categoryId varchar(20),
	name varchar(30) not null,
	`MainCatId` varchar(25) NOT NULL,
	`link` varchar(300) NOT NULL,
	primary key(categoryId),
    FOREIGN key (MainCatId) REFERENCES maincategory(MainCatId)
);


create table if not exists Product(
	productId varchar(20),
	title varchar(255) not null,
	weight float not null,
	SKU varchar(100) not null,
	description varchar(1000) not null,
	price float not null,
    categoryId varchar(20),
    link varchar(300),
    brandname varchar(25),
	primary key(productId),
    FOREIGN key (categoryId) REFERENCES category(categoryId)
);
create table if not exists Cart(
	cartId varchar(20),
	totalPrice float,
	customerId varchar(20) unique,
	primary key(cartId),
	foreign key(customerId) references cutomers(customerId)
);


create table if not exists Cart_Items(
	cartId varchar(20),
	productId varchar(20),
	quantity int,
	primary key(cartId,productId),
	foreign key (cartId) references Cart(cartId),
	foreign key (productId) references Product(productId)
);

create table if not exists Order_items(
	orderId varchar(20),
	productId varchar(20),
	quantity int,
	price float,
	primary key(orderId,productId),
	foreign key (orderId) references orders(orderId),
	foreign key (productId) references Product(productId)
);
create table if not exists VarianTypes(
	vTypeId varchar(20),
	variant varchar(30),
	primary key (vTypeId)
);

create table if not exists WearHouse(
	wearHouseId varchar(20),
	country varchar(30) not null,
	state varchar(30) not null,
	primary key (wearHouseId)
);

create table if not exists Inventory(
	productId varchar(20) ,
	wearHouseId varchar(20),
	quantity int,
	primary key(productId,wearHouseId),
	foreign key (productId) references product(productId),
	foreign key (wearHouseId) references WearHouse(wearHouseId)
);

create table if not exists Payment(
	paymentId varchar(20),
	orderId varchar(20),
	primary key(paymentId),
	foreign key (orderId) references orders(orderId)
);

create table if not exists OnDeliveryPayment(
	paymentReciepeint varchar(20),
	paymentId varchar(20) not null,
	primary key (paymentReciepeint),
	foreign key (paymentId) references payment(paymentId)
);

create table if not exists CCdetails(
	cardId varchar(20),
	customerId varchar(20),
	CCNumber varchar(20) not null,
	cvv decimal(3,0) not null,
	expiredate date not null,
	billingAddress varchar(200) ,
	primary key(cardId),
	foreign key (customerId) references cutomers(customerId)
);

create table if not exists CCPayment(
	paymentId varchar(25),
	cardId varchar(20),
	primary key(paymentId,cardId),
	foreign key (paymentId) references payment(paymentId),
	foreign key (cardId) references CCdetails(cardId)
);




INSERT INTO `cutomers` (`customerId`, `first_name`, `last_name`, `nic`, `birthday`, `email`, `streetNumber`, `streetName`, `aptName`, `city`, `state`, `country`, `zip`) VALUES
('ES0001', 'Pinsara', 'Weerasinghe', '950840129v', '1995-03-24', 'pinsara@gmail.com', 'No:57', 'Savijaya road', 'Edment Apartment', 'Wellawaya', 'Uva Province', 'sri lanka', '9200');


INSERT INTO `maincategory` (`MainCatId`, `name`, `link`) VALUES
('1', 'Electronics', 'assets/images/electronic.jpg'),
('2', 'Toys', 'assets/images/toy.jpg');
INSERT INTO `category` (`categoryId`, `name`, `MainCatId`, `link`) VALUES
('c1', 'phones', '1', '/product/c1'),
('c2', 'Laptops', '1', '/product/c2'),
('c3', 'puzzles', '2', '/product/c3'),
('c4', 'building blocks', '2', '/product/c4');
INSERT INTO `product` (`productId`, `title`, `weight`, `SKU`, `description`, `price`, `categoryId`, `link`, `brandname`) VALUES
('E1', 'i phone 7 black', 0.5, 'sku1', 'I phone 7 black,128GB Factory unlocked Full set with same Imei box Brandnew condition With 4n to 4n warranty ', 74500, 'c1', '../assets/images/phones/iphone.png', 'apple'),
('E2', 'Huawei Mate SE', 1, 'sku2', 'GSM / 4G LTE Compatible 16MP & 2MP Dual Rear Cameras 8MP Front Camera HiSilicon Kirin 659 Octa-Core Chipset', 50000, 'c1', '../assets/images/phones/1.jpg', 'Huawei');

INSERT INTO `cart` (`cartId`, `totalPrice`, `customerId`) VALUES
('cart1', 0, 'ES0001');
INSERT INTO `cart_items` (`cartId`, `productId`, `quantity`) VALUES
('cart1', 'E1', 1),
('cart1', 'E2', 1);
