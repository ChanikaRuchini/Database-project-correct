
create database if not exists test23;

use test23;
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
 DELIMITER ;



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
DELIMITER $$
CREATE TRIGGER `checking` BEFORE INSERT ON `cutomers` FOR EACH ROW CALL check_nic(new.nic)
$$
DELIMITER ;

create table if not exists phoneNumbers(
	customerId varchar(20),
	phoneNumber varchar(10),
	primary key(customerId,phoneNumber),
	foreign key (customerId) references cutomers(customerId)

);
DELIMITER $$
CREATE TRIGGER `check_phone` BEFORE INSERT ON `phonenumbers` FOR EACH ROW CALL check_pn(new.phoneNumber)
$$
DELIMITER ;

CREATE TABLE `maincategory` (
  `MainCatId` varchar(25) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
    primary key(MainCatId)
);

create  table if not exists Admin(
  adminId varchar(255) ,
  firstname  varchar(255) not null,
  lastname varchar(255) ,
  telephone int(10) not null ,
  email varchar(255) not null,
  primary key(adminId)
);


create table if not exists courier (
   courierId varchar(40),
   telephoneNo int(11),
   firstname varchar(255),
   lastname varchar(255),
   country varchar(200),
   primary key(courierId)
   
);

create table if not exists Log_in(
	username varchar(255),
	customerId varchar(255) unique,
	password varchar(100),
	primary key (username),
	foreign key (customerId) references cutomers(customerId)
);


create table if not exists Log_in_admin(
	username varchar(255),
	adminID varchar(255) unique,
	password varchar(255),
	foreign key(adminId) references  Admin(adminID);
	
);

create table if not exists Log_in_courier(
    username varchar(255),
	courierId varchar(255) unique,
	password varchar(255),
	foreign key(courierId) references Courier(courierId)

);


DELIMITER $$
create trigger before_log_in_admin_insert
       BEFORE INSERT ON log_in_admin
       FOR EACH ROW
       BEGIN
	    IF char_length(new.password)<8 THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'password length must be greater than 8 charactors!';
		ELSE
         SET NEW.password= SHA1(NEW.password);
		END IF;
         
      END 
       $$
 DELIMITER;



DELIMITER $$
create trigger before_log_in_insert
       BEFORE INSERT ON log_in
       FOR EACH ROW
       BEGIN
	    IF char_length(new.password)<8 THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'password length must be greater than 8 charactors!';
		ELSE
         SET NEW.password= SHA1(NEW.password);
		END IF;
         
      END 
       $$
 DELIMITER;

 DELIMITER $$
create trigger before_log_in_courier
       BEFORE INSERT ON log_in_courier
       FOR EACH ROW
       BEGIN
	    IF char_length(new.password)<8 THEN
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'password length must be greater than 8 charactors!';
		ELSE
         SET NEW.password= SHA1(NEW.password);
		END IF;
         
      END 
       $$
 DELIMITER;

 /* admin authentication function*/
DELIMITER $$
create function checkLogin_admin(password varchar(40),username varchar(40))
returns boolean deterministic
begin
   IF(select  count(*) from log_in_admin where log_in_admin.password= sha1(password) and log_in_admin.username=username) THEN
      return TRUE;
   ELSE
     return FALSE;
   END IF;
end
$$
DELIMITER ;
 

/*courier authentication function*/
DELIMITER $$
create function checkLogin_courier(password varchar(40),username varchar(40))
returns boolean deterministic
begin
   IF(select  count(*) from log_in_courier where log_in_courier.password= sha1(password) and log_in_courier.username=username) THEN
      return TRUE;
   ELSE
     return FALSE;
   END IF;
end
$$
DELIMITER ;


/*authentication function*/
DELIMITER $$
create function checkLogin(password varchar(40),username varchar(40))
returns boolean deterministic
begin
   IF(select  count(*) from log_in where log_in.password= sha1(password) and log_in.username=username) THEN
      return TRUE;
   ELSE
     return FALSE;
   END IF;
end
$$
DELIMITER ;
 
 





create table if not exists orders (
	orderId varchar(20),
	customerId varchar(20) ,
	deliveredDate DateTime ,
	deliverAddress varchar(255) not null,
	deliverStatus varchar(25),
    orderedDate Date,
	totalPrice numeric(10,2),
	courierId  varchar(40),
	primary key(orderId),
	foreign key (customerId) references cutomers(customerId),
	foreign key (curiorId) references courier(courierId)
);

/*Trigger on insert*/
DELIMITER $$
create trigger before_order_insert
       BEFORE INSERT ON orders
       FOR EACH ROW
             IF new.totalPrice <=0 THEN
            SIGNAL SQLSTATE '45000'  
            SET MESSAGE_TEXT = 'Invalid TotalPrice!';
       ELSE
          set new.orderedDate=sysDate();
          set new.deliveredDate=null;
          set new.deliveryStatus=FALSE;
  
         select courierId into @id   from courier  where country like new.shippingAddress limit 0,1;
          if(@id!=null) then
            set new.courierId=@id;
          else
            set new.courierId=null;
        end if;
      END IF;
       END
       $$
 DELIMITER;

/*Trigger on order6 update*/
DELIMITER $$
create trigger before_order_update
    Before update on orders
	for each ROW
	BEGIN
     IF(old.deliveredDate!=new.deliveredDate) THEN
         set new.deliveredDate=sysDate();
	 END IF;
	 END
	 $$
DELIMITER;


create table if not exists category(
	categoryId varchar(20),
	name varchar(30) not null,
	`MainCatId` varchar(25) NOT NULL,
	`link` varchar(300) NOT NULL,
	primary key(categoryId),
    FOREIGN key (MainCatId) REFERENCES maincategory(MainCatId)
);

/*product table*/
create table if not exists Product(
	productId varchar(20),
	title varchar(255) not null,
	weight float not null,
	SKU varchar(100) not null,
	description varchar(1000) not null,
	price numeric(8,2) not null,
    categoryId varchar(20),
    link varchar(300),
    brandname varchar(25),
	primary key(productId),
    FOREIGN key (categoryId) REFERENCES category(categoryId)
);


DELIMITER $$
create trigger after_price_update_cart
       AFTER Update ON Product
       FOR EACH ROW
       BEGIN
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
 DELIMITER;
DELIMITER $$
CREATE TRIGGER `checking_price` BEFORE INSERT ON `product` FOR EACH ROW CALL check_product(new.price,new.weight)
$$
DELIMITER ;

create table if not exists Cart(
	cartId varchar(20),
	totalPrice numeric(8,2) default 0,
	customerId varchar(20) unique,
	primary key(cartId),
	foreign key(customerId) references cutomers(customerId)
	on update cascade on delete cascade
);

DELIMITER $$
CREATE TRIGGER `checkingprice` BEFORE INSERT ON `cart` FOR EACH ROW CALL check_price(new.totalPrice)
$$
DELIMITER ;


DELIMITER $$
create trigger update_price_on_cart
       BEFORE INSERT ON cart_items
       FOR EACH ROW
       BEGIN
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
 DELIMITER;




 DELIMITER $$
create trigger update_price_cart_delete
       After delete ON cart_items
       FOR EACH ROW
       BEGIN
	       UPDATE cart set totalPrice=totalPrice-old.unitPrice*old.quantity where cart.cartid=old.cartid;
       END 
       $$
 DELIMITER;


 DELIMITER $$
 create trigger update_price_on_cart_update
       AFTER update ON cart_items 
       FOR EACH ROW
	   BEGIN
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
 DELIMITER;


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


DELIMITER $$
create trigger before_insert_order_items
       BEFORE INSERT ON order_items
       FOR EACH ROW
       BEGIN
	     IF(new.quantity<=0) THEN
	        	SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid quantity for an product';
		 ELSE
		   select price into @price from prouct where productId=new.productId;
		   set new.price=@price*quantity;
		 END IF;
       END 
       $$
 DELIMITER;

 DELIMITER $$
create trigger after_insert_order_items
       AFTER INSERT ON order_items
       FOR EACH ROW
       BEGIN 
	     select cartId into @cartId from cart where customerId in (select customerId from orders where orderId=new.orderId);
	     delete from cart_items  where cartId=@cartId and productId=new.productId;
       END 
       $$
 DELIMITER;




DELIMITER $$
create trigger update_price_on_cart
       BEFORE INSERT ON cart_items
       FOR EACH ROW
       BEGIN
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
 DELIMITER;




create table if not exists VariantTypes(
	vTypeId varchar(20),
	variant varchar(30),
	primary key (vTypeId)
);
create table if not exists productVarient(
  productId varchar(20),
  varientValue varchar(20),
  vTypeId varchar(20),
  primary key(varientValue,productId),
  foreign key(vTypeId) references VariantTypes(vTypeId),
  Foreign key(productId) references Product(ProductId)
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
DELIMITER $$
CREATE TRIGGER `check_quntity` BEFORE INSERT ON `inventory` FOR EACH ROW call check_price(new.quantity)
$$
DELIMITER ;

create table if not exists Payment(
	paymentId varchar(20),
	orderId varchar(20),
	primary key(paymentId),
	foreign key (orderId) references orders(orderId)
);


create table if not exists OnDeliveryPayment(
	paymentId varchar(40) not null,
	paymentStatus boolean,
	primary key (paymentID,courierId),
	foreign key (paymentId) references payment(paymentId),
	foreign key(courierId)  references courior(courierId)
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


DELIMITER $$
CREATE TRIGGER `check_cc` BEFORE INSERT ON `ccdetails` FOR EACH ROW CALL check_cc(new.expiredate)
$$
DELIMITER ;



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
