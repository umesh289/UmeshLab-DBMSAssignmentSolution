
create database ecommerce;
use ecommerce;
drop table Supplier;
drop table Customer;
-- Question 1

create table Supplier (
SUPP_ID int,
SUPP_NAME varchar(55),
SUPP_CITY varchar(55),
SUPP_PHONE bigint,
primary key (SUPP_ID)
);

create table Customer( 
CUS_ID int,
CUS_NAME varchar(55),
CUS_PHONE bigint,
CUS_CITY varchar(55),
CUS_GENDER varchar(1),
primary key (CUS_ID)

);

create table Category (
CAT_ID int,
CAT_NAME varchar(55),
primary key (CAT_ID)
);

create table Product (
PRO_ID int,
PRO_NAME varchar(55),
PRO_DESC varchar(55),
CAT_ID int,
primary key (PRO_ID)
);

create table ProductDetails(
PROD_ID int, 
PRO_ID int, 
SUPP_ID int,
PRICE float,
primary key (PROD_ID)
);

create table Orders (
ORD_ID int,
ORD_AMOUNT float,
ORD_DATE date,
CUS_ID int,
PROD_ID int,
primary key (ORD_ID)
);

create table Rating(
RAT_ID int,
CUS_ID int,
SUPP_ID int, 
RAT_RATSTARS int,
primary key (RAT_ID)
);

-- Question 2

insert into Supplier values 
(1, "Rajesh Retails",  "Delhi", 1234567890), 
(2, "Appario Ltd.", "Mumbai", 2589631470),
(3,  "Knome products", "Banglore", 9785462315),
(4, "Bansal Retails", "Kochi", 8975463285),
(5, "Mittal Ltd.", "Lucknow", 7898456532);

insert into Customer values 
(1, "AAKASH", 9999999999, "DELHI", "M"),
(2, "AMAN", 9785463215, "NOIDA", "M"),
(3, "NEHA", 9999999999, "MUMBAI", "F"),
(4, "MEGHA", 9994562399, "KOLKATA", "F"),
(5, "PULKIT", 7895999999, "LUCKNOW", "M");

insert into Category values
(1, "BOOKS"),
(2, "GAMES"),
(3, "GROCERIES"),
(4, "ELECTRONICS"),
(5, "CLOTHES");

insert into Product values
(1, "GTA V", "DFJDJFDJFDJFDJFJF", 2),
(2, "TSHIRT", "DFDFJDFJDKFD", 5),
(3, "ROG LAPTOP", "DFNTTNTNTERND", 4),
(4, "OATS", "REURENTBTOTH", 3),
(5, "HARRY POTTER", "NBEMCTHTJTH", 1);

insert into ProductDetails values
(1, 1, 2, 1500),
(2, 3, 5, 30000),
(3, 5, 1, 3000),
(4, 2, 3, 2500),
(5, 4, 1, 1000);

insert into Orders values
(20, 1500, "2021-10-12", 3, 5),
(25, 30500, "2021-09-16", 5, 2),
(26, 2000, "2021-10-05", 1, 1),
(30, 3500, "2021-08-16", 4, 3),
(50, 2000, "2021-10-06", 2, 1);

insert into Rating values
(1, 2, 2, 4),
(2, 3, 4, 3),
(3, 5, 1, 5),
(4, 1, 3, 2),
(5, 4, 5, 4);



/*  3. Display the number of the customer group by their genders who have placed any order
of amount greater than or equal to Rs.3000. */

SELECT Customer.CUS_GENDER, count(*) as COUNT
FROM Orders 
INNER JOIN Customer
ON Orders.CUS_ID = Customer.CUS_ID where Orders.ORD_AMOUNT > 3000 group by Customer.CUS_GENDER;

/*
4) Display all the orders along with the product name ordered by a customer having
Customer_Id=2. */

Select Orders.*, Product.PRO_NAME from Orders, Product, ProductDetails 
where Orders.CUS_ID = 2 and Orders.PROD_ID = ProductDetails.PROD_ID and ProductDetails.PRO_ID = Product.PRO_ID;

/*
5) Display the Supplier details who can supply more than one product.
*/
select Supplier.* from Supplier where Supplier.SUPP_ID in
(
   Select ProductDetails.SUPP_ID from ProductDetails 
   group by ProductDetails.SUPP_ID  
   having Count(ProductDetails.SUPP_ID) > 1
) group by Supplier.SUPP_ID;

/*
6) Find the category of the product whose order amount is minimum.
*/

Select Category.* from Orders inner join ProductDetails on Orders.PROD_ID=ProductDetails.PROD_ID
inner join Product on Product.PRO_ID=ProductDetails.PRO_ID 
inner join Category on Category.CAT_ID=Product.CAT_ID order by Orders.ORD_AMOUNT asc limit 1;

/*
7) Display the Id and Name of the Product ordered after “2021-10-05”.
*/

Select Product.PRO_ID, Product.PRO_NAME from Orders inner join ProductDetails
on ProductDetails.PROD_ID= Orders.PROD_ID inner join Product on ProductDetails.PRO_ID=Product.PRO_ID
where Orders.ORD_DATE > "2021-10-05";

/*
8) Print the top 3 supplier name and id and their rating on the basis of their rating along
with the customer name who has given the rating.
*/

Select Supplier.SUPP_ID, Supplier.SUPP_NAME, Customer.CUS_NAME from Supplier inner join Rating
on Supplier.SUPP_ID= Rating.SUPP_ID inner join Customer on Rating.CUS_ID=Customer.CUS_ID order by Rating.RAT_RATSTARS desc limit 3;

/*
9) Display customer name and gender whose names start or end with character 'A'.
*/
Select Customer.CUS_NAME, Customer.CUS_GENDER from Customer where Customer.CUS_NAME like "A%" or
Customer.CUS_NAME like "%A";
/*
10) Display the total order amount of the male customers.
*/
Select SUM(Orders.ORD_AMOUNT) as total_amt_males from Orders left outer join Customer on Orders.CUS_ID=Customer.CUS_ID where Customer.CUS_GENDER="M";
/*
11) Display all the Customers left outer join with the orders.
*/
Select * from Customer left outer join Orders on Customer.CUS_ID=Orders.CUS_ID;
/*
12) Create a stored procedure to display the Rating for a Supplier if any along with the
Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average
Supplier” else “Supplier should not be considered”
*/

DELIMITER &&
create procedure proc()
BEGIN
Select Rating.SUPP_ID, Rating.RAT_RATSTARS,
CASE
    WHEN Rating.RAT_RATSTARS > 4 THEN "Genuine Supplier"
    WHEN Rating.RAT_RATSTARS > 2 THEN "Average Supplier"
    ELSE "Supplier should not be considered"
END AS Verdict
FROM Rating inner join Supplier on Supplier.SUPP_ID=Rating.SUPP_ID;
END &&

call proc();