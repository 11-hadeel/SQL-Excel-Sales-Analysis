/*
Purpose:
Identify different product line combinations that were purchased
within the same order.

The query returns the order number and the two different product
lines purchased together in that order.

The frequency of each product line combination (times purchased
together) is calculated later in Excel using a PivotTable.
*/

WITH prod_sales AS
(
    SELECT
        ordernumber,
        t1.productcode,
        productline
    FROM orderdetails t1
    INNER JOIN products t2
        ON t1.productcode = t2.productcode
)

SELECT DISTINCT
    t1.ordernumber,
    t1.productline AS product_one,
    t2.productline AS product_two
FROM prod_sales t1
LEFT JOIN prod_sales t2
    ON t1.ordernumber = t2.ordernumber
    AND t1.productline <> t2.productline;
