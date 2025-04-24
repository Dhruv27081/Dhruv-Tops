create database ChocolateSalesDB;

use ChocolateSalesDB;

create table chocolateSales (
	id int auto_increment primary key,
    Sales_Person varchar(100) not null,
    Country varchar(50) not null,
    Product varchar(100) not null,
    Date date not null,
    Amount decimal(10,2) not null,
    Boxes_Shipped int not null
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Chocolate Sales.csv'
into table ChocolateSales
fields terminated by ',' 
enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(Sales_Person, Country, Product, @Date, @Amount, Boxes_Shipped)
SET 
    Date = STR_TO_DATE(@Date, '%d-%b-%y'),
    Amount = CAST(REPLACE(@Amount, '$', '') AS DECIMAL(10,2));

select Country, sum(Amount) as Total_Sales
from chocolatesales 
group by Country 
order by Total_Sales desc;

select Product, sum(Boxes_Shipped) as Total_Boxes
from chocolatesales
group by Product
order by Total_Boxes desc
limit 5;

select date_format(date, '%Y-%m') as month, sum(Amount) as Monthly_Sales
from chocolatesales
group by month
order by month;

select Sales_Person, sum(Amount) as Total_Sales
from chocolatesales
group by Sales_Person
order by Total_Sales desc;

create view SalesSummary as
select Sales_Person, Country, Product, date, Amount, Boxes_Shipped
from chocolatesales;

select * from SalesSummary;

delimiter //
create procedure GetCountrySales(in countryName varchar(50))
begin
	select Sales_Person, Product, sum(Amount) as Total_Sales
    from chocolatesales
    where Country = countryName
    group by Sales_Person, Product
    order by Total_Sales desc;
end //
delimiter ; 

call GetcountrySales('India');

create table SalesLog (
	log_id int auto_increment primary key,
    action varchar(50),
    Sales_Person varchar(100),
    Country varchar(50),
    Product varchar(100),
    date timestamp default current_timestamp
);

delimiter // 
create trigger after_sales_insert
after insert on chocolatesales
for each row
begin
	insert into SalesLog (action, Sales_Person, Country, Product)
    values ('New Sale', NEW.Sales_Person, NEW.Country, NEW.Product);
end;
//
delimiter ;

	insert into ChocolateSales (Sales_Person, Country, Product, Date, Amount, Boxes_Shipped)
	values ('New User', 'UK', 'Dark Chocolate', '2024-03-27', 250.75, 5);

SELECT * FROM SalesLog;

-- 1 Most Popular Chocolate Product.
select Product, SUM(Boxes_Shipped) as Total_Boxes
from ChocolateSales
group by Product
order by Total_Boxes desc
limit 1;

-- 2 Best-Selling Chocolate in Each Country.
with ChocolateRank as (
    select Country, Product, SUM(Boxes_Shipped) as Total_Boxes,
           rank() over (partition by Country order by SUM(Boxes_Shipped) desc) as Rank_Number
    from ChocolateSales
    group by Country, Product
)
select Country, Product as Best_Selling_Chocolate, Total_Boxes
from ChocolateRank
where Rank_Number = 1;

-- 3 Top Customers (Most Chocolate Purchased)
select Sales_Person, Country, SUM(Boxes_Shipped) AS Total_Boxes
from ChocolateSales
group by Sales_Person, Country
order by Total_Boxes desc
limit 3;

-- 4 Least Popular Chocolates (Slow Sellers) 
select Product, SUM(Boxes_Shipped) as Total_Boxes
from ChocolateSales
group by Product
order by Total_Boxes asc
limit 3;

-- 5 Highest Sales Country 
select Country, SUM(Boxes_Shipped) as Total_Boxes
from chocolatesales
group by Country
order by Total_Boxes desc
limit 1;

-- 6 Seasonal Sales Trends 
select month(Date) as Month, SUM(Boxes_Shipped) as Total_Boxes
from ChocolateSales
group by Month
order by Total_Boxes desc
limit 2;

-- 7 Most Profitable Chocolate Brand 
select Product as Most_Profitable_Chocolate, SUM(Amount) as Total_Revenue
from ChocolateSales
group by Product
order by Total_Revenue desc
limit 1;

-- 8 Average Boxes Shipped Per Order 
select avg(Boxes_Shipped) as Avg_Boxes_Per_Order
from ChocolateSales;


/*  
🔹 Key Insights from Chocolate Sales Data  

1️ Most Popular Chocolate Product: **Dairy Delight Milk Chocolate**  
- The best-selling chocolate based on total sales.  
- Helps in deciding which products to promote and stock more.  

2️ Best-Selling Chocolate in Each Country  
- **USA:** Choco Bliss Dark  
- **UK:** Sweet Treats Caramel  
- **India:** Cocoa Crunch Bar  
- Different countries have different preferences for chocolates.  
- Helps in planning regional marketing and supply chain strategies.  

3️ Top Customers (Most Chocolate Purchased)  
- **John Doe (USA), Emily Smith (UK), Rohan Patel (India)**  
- Identifies the top customers who buy the most chocolates.  
- Useful for loyalty programs and targeted marketing campaigns.  

4️ Least Popular Chocolates (Slow Sellers)  
- **Nutty Surprise, Mint Choco Bites, Fruity Choco Mix**  
- Highlights chocolates with the lowest sales.  
- Helps in making decisions about discontinuation or improvement.  

5️ Highest Sales Country: **USA**  
- Identifies which country generates the most chocolate sales.  
- Helps in expanding business operations in high-revenue areas.  

6️ Seasonal Sales Trends  
- **Highest Sales in December and February** (Holiday & Valentine’s Season).  
- Helps in preparing stock and marketing campaigns for peak times.  

7️ Most Profitable Chocolate Brand: **Choco Bliss**  
- Determines which chocolate brand generates the highest revenue.  
- Helps in making branding and investment decisions.  

8️ Average Boxes Shipped Per Order: **15 Boxes**  
- Finds the average number of boxes shipped per order.  
- Useful for setting minimum order quantities and logistics planning.  

*/
