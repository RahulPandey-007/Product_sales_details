# Product_sales_details- MySQL 

In this sales details project we have a company's dataset which contains :
  a. Customer Details file   
  b. Product Details file  
  c. Region file  
  d. Sales Details file
  
1. First,The tables have created in accordance to store the data of respective files by 
   defining primary and foreign key relations(one to many) between Parent tables 
   (Customer_details, Product_details, Region, order_date) and Child table (Sales_details).
   
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
    g. Month wise product sales
    h. Region wisee product sales
    
The code file(sql file) and the csv file is also shared.

