# Product_sales_details- MySQL 

In this sales details project we have a company's dataset which contains :
  a. Customer Details file   
  b. Product Details file  
  c. Region file  
  d. Sales Details file
  
1. First I have created tables in accordance to store data of respective 
   file with defining of primary and foreign key relationship(one to many)
   between Parent tables (Customer_details, Product_details, Region) and 
   Child table(Sales_details).
2. I have added some new columns in Sales_details(Child table) for further calculations :
    a. Total Price
    b. Total Cost
    c. Profit
3. I have created some stored procedure containing details of :
    a. Regional Sales details
    b. Customer wise Sales value
    c. Sales details according to customer, region, product
    d. Top 10 high sales Product
    e. Top 10 high sales by customer 
    f. Top 10 high sales by customer(By Dense Rank Function)
    
The code file(sql file) and the csv file is also shared.

