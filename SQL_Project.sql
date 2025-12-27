		/*****
				ONLINE SALES ANALYSIS - 2018
                                              *****/
----------------------------------------------------------------------------------------------
-- Database & Table Creation
----------------------------------------------------------------------------------------------
Create Database Sales_analysis;
use Sales_analysis;
 
----------------------------------------------------------------------------------------------
-- Order Table
----------------------------------------------------------------------------------------------
CREATE TABLE Orders (
    Order_ID VARCHAR(20) PRIMARY KEY NOT NULL,
    Order_Date DATE,
    Customer_Name VARCHAR(30),
    State VARCHAR(50),
    City VARCHAR(50)
);

---------------------------------------------------------------------------------------------
-- Order Detail Table
---------------------------------------------------------------------------------------------
CREATE TABLE Order_Details (
    Order_Detail_ID INT PRIMARY KEY NOT NULL,
    Order_ID VARCHAR(20),
    Amount DECIMAL(10 , 2 ),
    Profit DECIMAL(10 , 2 ),
    Quantity INT,
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Payment_Mode VARCHAR(30),
    CONSTRAINT Fk_Details FOREIGN KEY (Order_ID)
        REFERENCES Orders (Order_ID)
);

--------------------------------------------------------------------------------------
-- Total Sales & Profit by Category
--------------------------------------------------------------------------------------
SELECT 
    Category,
    SUM(Amount) AS 'Total Sales',
    SUM(Profit) AS 'Total Profit'
FROM
    Order_details
GROUP BY Category 
UNION ALL SELECT 
    '   Total' AS Category,
    SUM(Amount) AS 'Total Sales',
    SUM(Profit) AS 'Total Profit'
FROM
    Order_details
ORDER BY 'Total Sales' DESC;

---------------------------------------------------------------------------------------
-- Monthly Sales trend 
---------------------------------------------------------------------------------------
SELECT 
    MONTH(O.Order_Date) AS 'Month',
    SUM(D.Amount) AS 'Monthly Sales'
FROM
    Orders O
        JOIN
    Order_details D ON O.Order_ID = D.Order_ID
GROUP BY MONTH
ORDER BY MONTH;

----------------------------------------------------------------------------------------
-- Top Selling Products (Sub Category Analysis)
----------------------------------------------------------------------------------------
SELECT 
    Category, Sub_Category, Sales, Profit
FROM
    (SELECT 
        Category,
            Sub_Category,
            SUM(Amount) AS Sales,
            SUM(Profit) AS Profit
    FROM
        Order_Details
    GROUP BY Category , Sub_Category) AS SubCategory_Summary
ORDER BY Sales DESC;

----------------------------------------------------------------------------------------
-- Top 5 Markets by City Level
----------------------------------------------------------------------------------------
Select o.City, sum(d.Amount) as Sales from Orders o
Join Order_Details d
On o.Order_ID = d.Order_ID
Group by City
Order by Sales desc
Limit 5;

-----------------------------------------------------------------------------------------
-- Statewise Sales Analysis
-----------------------------------------------------------------------------------------
SELECT 
    State, SUM(d.Amount) AS Sales
FROM
    Orders o
        JOIN
    Order_Details d ON o.Order_ID = d.Order_ID
GROUP BY State
ORDER BY Sales DESC
LIMIT 5;

-----------------------------------------------------------------------------------------
-- Loyalty Program Eligible Customers
-----------------------------------------------------------------------------------------
SELECT *
FROM (
    SELECT
        Customer_Name,
        SUM(D.Amount) AS Total_spent,
        DENSE_RANK() OVER (ORDER BY SUM(D.Amount) DESC) as spend_rank
    FROM Orders O
    JOIN Order_Details D
        ON O.Order_ID = D.Order_ID
    GROUP BY O.Customer_Name
) Ranked_Customers
WHERE spend_rank <= 10;

--------------------------------------------------------------------------------------------
-- Most Frequently used Payment Mode
--------------------------------------------------------------------------------------------
SELECT 
    Payment_Mode, COUNT(Order_ID) AS Total_Orders
FROM
    Order_Details
GROUP BY Payment_Mode;