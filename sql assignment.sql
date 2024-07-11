

create database joins;

## Problem 1: For an online purchasing database, create entity relationship diagrams. Create a database object from your entity diagram.

## Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

## Product table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2),
    Stock INT
);

## Order table
CREATE TABLE `Order` (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

## OrderItem table
CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

## Payment table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentDate DATE,
    Amount DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
);

## Shipment table
CREATE TABLE Shipment (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ShipmentDate DATE,
    Carrier VARCHAR(100),
    TrackingNumber VARCHAR(100),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
);

## Problem 2: Create a SQL store process to register the use of the database, complete it with proper validation and transaction rollback and commit.

DELIMITER //

CREATE PROCEDURE RegisterCustomer(
    IN p_Name VARCHAR(100),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(20),
    IN p_Address VARCHAR(255)
)
BEGIN
    DECLARE v_CustomerID INT;
    DECLARE v_ErrorOccurred BOOLEAN DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_ErrorOccurred := TRUE;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    ## Validation
    IF p_Name IS NULL OR p_Email IS NULL OR p_Phone IS NULL OR p_Address IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All fields are required.';
    END IF;
    
    ## Insert customer
    INSERT INTO Customer (Name, Email, Phone, Address)
    VALUES (p_Name, p_Email, p_Phone, p_Address);
    
    SET v_CustomerID := LAST_INSERT_ID();
    
    IF v_ErrorOccurred = FALSE THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
    
END //

DELIMITER ;

## Problem 3: List the SQL aggregate function and demonstrate how to utilize it.

## Count() - The COUNT() function counts the number of rows that match a specified condition.
## Example: Count the number of customers in the Customer table.
SELECT COUNT(*) AS TotalCustomers
FROM Customer;

## SUM() - The SUM() function calculates the sum of values in a column.
## Example: Calculate the total amount of payments in the Payment table.
SELECT SUM(Amount) AS TotalPayments
FROM Payment;

## AVG() - The AVG() function calculates the average (mean) value of a numeric column.
## Example: Calculate the average price of products in the Product table.
SELECT AVG(Price) AS AveragePrice
FROM Product;

## Min() - The MIN() function returns the minimum value in a column.
## Example: Find the lowest stock level among products in the Product table.
SELECT MIN(Stock) AS LowestStock
FROM Product;

## Max() - The MAX() function returns the maximum value in a column.
## Example: Find the highest price among products in the Product table.
SELECT MAX(Price) AS HighestPrice
FROM Product;

## Group_concat() - The GROUP_CONCAT() function concatenates the values of a column into a single string, with optional separators. 
## Example: Concatenate all product names into a single comma-separated string.
SELECT GROUP_CONCAT(Name ORDER BY Name SEPARATOR ', ') AS AllProductNames
FROM Product;

## Problem 4: In SQL, create a pivot query.

## Let's say we have a table Sales that records monthly sales data for products:
## Sales Table Structure:
## ProductID
## Month
## Amount

## Pivot Query Example: Suppose we want to pivot the monthly sales data so that each month becomes a column, and each product's total sales for that month are displayed under each column.

## Sample data setup (for demonstration purposes)
CREATE TABLE Sales (
    ProductID INT,
    Month VARCHAR(10),
    Amount DECIMAL(10, 2)
);

INSERT INTO Sales (ProductID, Month, Amount)
VALUES
    (1, 'January', 1000),
    (1, 'February', 1500),
    (2, 'January', 800),
    (2, 'February', 1200);

## Pivot query to transform rows to columns
SELECT
    ProductID,
    SUM(CASE WHEN Month = 'January' THEN Amount ELSE 0 END) AS January,
    SUM(CASE WHEN Month = 'February' THEN Amount ELSE 0 END) AS February
FROM
    Sales
GROUP BY
    ProductID;

## Problem 5: With an example, describe how to join in SQL.

create table customers
(
customerid int not null,
customername varchar(100),
contactname varchar(100),
address varchar(100),
city varchar(100),
postalcode varchar(10),
country varchar(20),
PRIMARY KEY (customerid)
);

create table orders
(
orderid int not null,
customerid int,
employeeid int,
orderdate datetime,
shipperid int,
primary key (orderid)
);


insert into customers values (1, 'Dhruv', 'Dhruv', 'BTM Layout', 'Bangalore', '000000', 'India');
insert into customers values (2, 'Deepti', 'Deepti', 'Jaduguda', 'Jamshedpur', '004560', 'India');
insert into customers values (3, 'Pratyush', 'Pratyush', 'Lahore', 'Lahore', '000087', 'Pakistan');
insert into customers values (4, 'Barsha', 'Barsha', 'Berlin', 'Berlin', '007536', 'Germany');
insert into customers values (5, 'Shivam', 'Shivam', 'Pilano', 'Texas', '000741', 'USA');
insert into customers values (6, 'Subrat', 'Subrat', 'Rio', 'Rio', '854900', 'Brazil');
insert into customers values (7, 'Shubham', 'Shubham', 'Tampa Bay', 'Florida', '088000', 'USA');
insert into customers values (8, 'Soumya', 'Soumya', 'Dhaka', 'Dhaka', '985000', 'Bangaladesh');
insert into customers values (9, 'Rahul', 'Rahul', 'Pataya', 'Bangkok', '456789', 'Thailand');
insert into customers values (10, 'Arpita', 'Arpita', 'Akisima', 'Tokyo', '145033', 'Japan');

select * from customers;

insert into orders values(901, 1, 1, sysdate(), 12345);
insert into orders values(902, 1, 1, sysdate(), 12121);
insert into orders values(903, 4, 4, sysdate(), 12543);
insert into orders values(904, 5, 5, sysdate(), 12453);
insert into orders values(905, 6, 6, sysdate(), 12435);
insert into orders values(906, 11, 11, sysdate(), 12545);

select * from orders;

## left Join
select * from customers c left join orders o
on c.customerid = o.customerid;

## right join
select c.customerid, c.customername, c.country, o.orderid, o.orderdate
from customers c right join orders o
on c.customerid = o.customerid;

## inner joint
select c.customerid, c.customername, c.country, o.orderid, o.orderdate
from customers c inner join orders o
on c.customerid = o.customerid;
## or
select c.customerid, c.customername, c.country, o.orderid, o.orderdate
from customers c, orders o where c.customerid = o.customerid;

## outer join using left outer join and right outer join
select c.customerid, c.customername, c.country, o.orderid, o.orderdate
from customers c left outer join orders o
on c.customerid = o.customerid
union
select c.customerid, c.customername, c.country, o.orderid, o.orderdate
from customers c right outer join orders o
on c.customerid = o.customerid;

## cross join
select c.customerid, c.customername, c.country, o.orderid, o.orderdate
from customers c cross join orders o
on c.customerid = o.customerid;

## Problem 6: How to locate the 4th highest value in a column in a row. Create your table.

CREATE TABLE Scores (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Score INT
);

INSERT INTO Scores (Score) VALUES (85), (92), (78), (91), (88), (95), (80), (89), (83), (87);

SELECT Score AS FourthHighestScore
FROM Scores
ORDER BY Score DESC
LIMIT 1 OFFSET 3;

