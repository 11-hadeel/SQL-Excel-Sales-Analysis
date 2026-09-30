/*
Purpose: Find customers who went over their credit limit, and when it happened.

How it works, step by step:
1. cte_sales: Joins orders with their details and customer data, and calculates
   the value of each line item (quantity x price).
2. running_total_sales_cte: Sums the value of each order, and adds the customer's
   next order date using lead.
3. payments_cte: The payments table.
4. main_cte: Links each order to the payments received between its date and the
   customer's next order date, and calculates the running total of sales and the
   running total of payments.
5. Final query:
   - money_owed = running total sales - running total payments (what the customer owes).
   - difference = credit limit - money_owed. A negative value means the customer
     has exceeded their credit limit.
*/
with cte_sales as
(
    select
        orderDate,
        t1.customerNumber,
        t1.ordernumber,
        customername,
        productCode,
        creditLimit,
        quantityOrdered * priceEach as sales_value
    from orders t1
    inner join orderdetails t2
        on t1.orderNumber = t2.orderNumber
    inner join customers t3
        on t1.customerNumber = t3.customerNumber
),

running_total_sales_cte as
(
    select *, lead(orderdate) over (partition by customernumber order by orderdate) as next_order_date
    from
    (
        select orderdate,
               ordernumber,
               customernumber,
               customername,
               creditlimit,
               sum(sales_value) as sales_value
        from cte_sales
        group by
            orderdate,
            ordernumber,
            customernumber,
            customername,
            creditlimit
    ) subquery
),

payments_cte as
(
    select *
    from payments
),

main_cte as
(
    select t1.*,
           sum(sales_value) over (partition by t1.customernumber order by orderdate) as running_total_sales,
           sum(amount) over (partition by t1.customernumber order by orderdate) as running_total_payments
    from running_total_sales_cte t1
    left join payments_cte t2
        on t1.customernumber = t2.customernumber
        and t2.paymentdate between t1.orderdate
            and case when t1.next_order_date is null then current_date else next_order_date end
)

select *, running_total_sales - running_total_payments as money_owed,
       creditlimit - (running_total_sales - running_total_payments) as difference
from main_cte