/*
Purpose:
Provide an overview of sales for 2004, broken down by product,
country, and city.
Only orders placed during 2004 are included.

-- The resulting dataset was then imported into Excel,
-- where a PivotTable was created to provide an overview
-- And The query calculates:
- Sales Value = quantityOrdered × priceEach
- Cost of Sales = quantityOrdered × buyPrice
- Net Profit = Sales Value - Cost of Sales
*/


select t1.orderDate, quantityOrdered, t1.orderNumber,priceEach,productLine , buyprice, city , country , productName
from orders t1
inner join orderdetails t2
on t1.orderNumber=t2.orderNumber
inner join products t3 
on t2.productCode= t3.productcode
inner join customers t4 
on t1.customerNumber=t4.customerNumber
where year(orderDate) = 2004;




/* Another way to calcuate : 
- Sales Value = quantityOrdered × priceEach
- Cost of Sales = quantityOrdered × buyPrice
- Net Profit = Sales Value - Cost of Sales 
using SQL */



SELECT
    p.productName,
    c.country,
    c.city,
    SUM(od.quantityOrdered * od.priceEach) AS sales_value,
    SUM(od.quantityOrdered * p.buyPrice) AS cost_of_sales,
    SUM(
        (od.quantityOrdered * od.priceEach)
        - (od.quantityOrdered * p.buyPrice)
    ) AS net_profit
FROM orders o
JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
JOIN products p
    ON od.productCode = p.productCode
JOIN customers c
    ON o.customerNumber = c.customerNumber
WHERE o.orderDate >= '2004-01-01'
  AND o.orderDate < '2005-01-01'
GROUP BY
    p.productName,
    c.country,
    c.city
ORDER BY
    sales_value DESC;
    
