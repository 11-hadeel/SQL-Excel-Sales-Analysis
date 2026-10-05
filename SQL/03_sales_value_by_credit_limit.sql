WITH sales AS
(
    SELECT
        t1.orderNumber,
        t1.customerNumber,
        productCode,
        quantityOrdered,
        priceEach,
        priceEach * quantityOrdered AS sales_value,
        creditLimit
    FROM orders t1

    INNER JOIN orderdetails t2
        ON t1.orderNumber = t2.orderNumber

    INNER JOIN customers t3
        ON t1.customerNumber = t3.customerNumber
)

SELECT
    ordernumber,
    customernumber,

    CASE
        WHEN creditlimit < 75000
            THEN 'a: Less than $75k'
        WHEN creditlimit BETWEEN 75000 AND 100000
            THEN 'b: $75k - $100k'
        WHEN creditlimit BETWEEN 100000 AND 150000
            THEN 'c: $100k - $150k'
        WHEN creditlimit > 150000
            THEN 'd: Over $150k'
        ELSE 'Other'
    END AS creditlimit_group,

    SUM(sales_value) AS sales_value

FROM sales

GROUP BY
    ordernumber,
    customernumber,
    creditlimit_group;
