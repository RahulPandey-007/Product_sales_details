create database sales_db;
use sales_db;

CREATE TABLE `Sales_details` (
	`Order ID` INT NOT NULL primary key, 
	`OrderDate` VARCHAR(10) NOT NULL, 
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

select * from Sales_details;

alter table Sales_details add column `Total Price` decimal(10,3);

set sql_safe_updates = 0;

update Sales_details set `Total Price` = (`Unit Price`* Quantity);

alter table Sales_details add column `Total cost` decimal(10,3);

update Sales_details set `Total cost` = (`Unit Cost` * Quantity);

alter table Sales_details add column Profit decimal(10,3);

select * from Sales_details;

update Sales_details set Profit = `Total Sales` - `Total Cost`;


Delimiter &&
create procedure regional_sales()
Begin
	select r.`Country`, r.`City`, sum(s.`Total Price`) from Sales_details s, Region r where s.`Region ID` = r.`Index` group by `Region ID` order by `Country`;
End &&
Delimiter ;
    
call regional_sales();


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


Delimiter &&
create procedure Customer_region_Product_sales()
Begin
	
    select c.`Customer Names`, r.country, r.city, s.orderdate, p.`Product Name`, sum(s.`Total Price`) as `Total Purchase`
	from Sales_details s, Region r, Product_details p, customer_details c
	where s.`Customer Name Index` = c.`Customer Index` and  s.`Region ID` = r.`Index` and                                                 
	s.`Product ID` = p.`Product ID` group by c.`Customer Names`, p.`Product Name`, r.country, r.city;

End &&
Delimiter ;

call Customer_region_Product_sales();


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
    







