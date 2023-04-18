
-------- Database creation named sales_db----------------------------------

create database sales_db;
use sales_db;




/* Table schema formation of Customer details table, Product details table,
   Region table and Sales details table */


CREATE TABLE `Customer_details` (
	`Customer Index` DECIMAL(38, 0) NOT NULL, 
	`Customer Names` VARCHAR(19) NOT NULL
);

CREATE TABLE `Product_details` (
	`Product ID` DECIMAL(38, 0) NOT NULL, 
	`Product Name` VARCHAR(24) NOT NULL
);

CREATE TABLE `Region` (
	`Index` DECIMAL(38, 0) NOT NULL, 
	`State` VARCHAR(10) NOT NULL, 
	`City` VARCHAR(22) NOT NULL, 
	`Country` VARCHAR(14) NOT NULL
);

CREATE TABLE `Sales_details` (
	`Order ID` INT NOT NULL primary key, 
	`OrderDate` Date NOT NULL, 
	`Customer Name Index` INT NOT NULL, 
	`Channel` VARCHAR(10) NOT NULL, 
	`Currency Code` VARCHAR(4) NOT NULL, 
	`Code` VARCHAR(8) NOT NULL, 
	`Region ID` int NOT NULL, 
	`Product ID` int NOT NULL, 
	`Quantity` int NOT NULL, 
	`Unit Price` DECIMAL(38, 1) NOT NULL, 
	` Unit Cost` DECIMAL(38, 3) NOT NULL,
    foreign key(`Customer Name Index`) references Customer_details(`Customer Index`),
    foreign key(`Product ID`) references Product_details(`Product ID`),
    foreign key(`Region ID`) references Region(`Index`)
);




-------- Data insertion into above respective tables-----------


load data infile 'E:/NorthSeaExports/Customer_details.csv'
into table Customer_details
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from Customer_details;

load data infile 'E:/NorthSeaExports/Product_details.csv'
into table Product_details
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from Product_details;

load data infile 'E:/NorthSeaExports/Region.csv'
into table Region
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from Region;

load data infile 'E:/NorthSeaExports/Sales_details.csv'
into table Sales_details
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;




-------- An extra 'Total Price' named column created and inserted value into this column--------------


alter table Sales_details add column `Total Price` decimal(10,3);

set sql_safe_updates = 0;

update Sales_details set `Total Price` = (`Unit Price`* Quantity);




-------- An extra 'Total Cost' named column created and inserted value into this column------------------


alter table Sales_details add column `Total cost` decimal(10,3);

update Sales_details set `Total cost` = (`Unit Cost` * Quantity);




-------- An extra 'Profit' named column created and inserted value into this column------------------


alter table Sales_details add column Profit decimal(10,3);

select * from Sales_details;

update Sales_details set Profit = `Total Price` - `Total Cost`;




-------- A Stored Procedure created which contain region wise sales arrenged according to Country names------------------


Delimiter &&
create procedure regional_sales()
Begin
	select r.`Country`, r.`City`, sum(s.`Total Price`) from Sales_details s, Region r 
	where s.`Region ID` = r.`Index` group by `Region ID` order by `Country`;
End &&
Delimiter ;
    
call regional_sales();




-------- A Stored Procedure created which contain Total Purchase made by distinct customer on a date------------------


Delimiter &&
create procedure customer_wise_Sales()
Begin 
	select c.`Customer Names`, OrderDate, s.`Channel`, sum(s.`Total Price`) as `Total Purchase`
    from Sales_details s, Customer_details c 
    where s.`Customer Name Index` = c.`Customer Index`
    group by `Customer Names`;
End &&
Delimiter ;

call customer_wise_Sales();




/* A Stored Procedure created which contain Total sales in terms of 
Customer name, Product name and region (Country and City) */


Delimiter &&
create procedure Customer_region_Product_sales()
Begin
	
    select c.`Customer Names`, r.country, r.city, s.orderdate, p.`Product Name`, 
    sum(s.`Total Price`) as `Total Purchase`
	from Sales_details s, Region r, Product_details p, customer_details c
	where s.`Customer Name Index` = c.`Customer Index` and  s.`Region ID` = r.`Index` and                                                 
	s.`Product ID` = p.`Product ID` group by c.`Customer Names`, p.`Product Name`, r.country, r.city;

End &&
Delimiter ;

call Customer_region_Product_sales();




/* A Stored Procedure created which contain Top 10 product has highest sales */


Delimiter &&
create procedure Top_10_high_product_sales()
Begin
	
    select p.`Product ID`, p.`Product Name`, s.`Channel`, sum(s.`Total Price`) as `Purchase Price`
	from sales_details s, Product_details p
	where s.`Product ID` = p.`Product ID` 
	group by p.`Product ID` order by `Purchase Price` desc limit 10;
 
 End &&
 Delimiter ;

call Top_10_high_product_sales();




/* A Stored Procedure created which contain Total sales in terms of 
Customer name, Product name and region (Country and City) */


Delimiter $$
create procedure Top_10_high_customer_purchase()
Begin

	select c.`Customer Names`, s.`Channel`, sum(s.`Total Price`) as `Purchase Price`
    from sales_details s, customer_details c 
    where s.`Customer Name Index` = c.`Customer Index`
    group by c.`Customer Names` order by `Purchase Price` desc limit 10; 
    
End $$
Delimiter ; 

call Top_10_high_customer_purchase();

/* Or below query also we can use */

Delimiter &&
create procedure Top_10_high_customer_purchase_by_rank()
Begin
	select c.`Customer Names`, s.`Channel`, sum(s.`Total Price`) as `Purchase Price`, 
	dense_rank() over(order by sum(s.`Total Price`) desc) as `Customer Rank`  
	from sales_details s, customer_details c
	where s.`Customer Name Index` = c.`Customer Index`
	group by c.`Customer Names` limit 10;
 End &&
 Delimiter ;

call Top_10_high_customer_purchase_by_rank();
    



/* Some columns are added to insert time intelligence like Day, Month 
   and by using this we can calculate sales for a specific time (Months wise sales) */


alter table sales_details add column sale_month varchar(10) after OrderDate; 

update sales_details set sale_month = Date_format(OrderDate, '%b');

alter table sales_details add column sale_date int after sale_month; 

update sales_details set sale_date = day(OrderDate);




/* A Stored Procedure created which Month wise product sales */


Delimiter &&
create procedure month_wise_product_sale()
Begin
	select  p.`product Name`, d.month_name, sum(s.`Total Price`) as `Total Purchase`
	from sales_details s, product_details p, order_date d
	where s.`product id` = p.`product id` and s.sale_date = d.month_no
	group by p.`product Name`, d.month_no ; 
End &&
Delimiter ;

call month_wise_product_sale();




/* a order_date named table has been created and inserted data into the Order date tabel */ 


create table order_date(`Order Date` date);

load data infile 'E:/NorthSeaExports/Order_date.csv'
into table order_date
fields terminated by ','
enclosed by '"'
lines terminated by '\n';




/* month and day columns created by extracting details from order date column in Order_date table */ 


select * from order_date;
alter table order_date add column month_no int;
update order_date set month_no = date_format(`Order date`, '%m');
alter table order_date add column month_name varchar(10);
update order_date set month_name = date_format(`Order date`, '%b') order by month_no;




/*  Stored procedure created containing details about Total sales made by 
    a product from a country ina specific month */ 


Delimiter &&
create procedure region_wise_product_sale()
Begin
	select  r.country, d.month_name, p.`product name`, sum(s.`Total Price`) as `Total Purchase`
	from sales_details s, region r, product_details p, order_date d
	where s.`Region id` = r.`Index` and s.`product id` = p.`product id`and s.sale_date = d.month_no
	group by r.country, d.month_no, p.`product name` order by r.country; 
End &&
Delimiter ;

call region_wise_product_sale();

