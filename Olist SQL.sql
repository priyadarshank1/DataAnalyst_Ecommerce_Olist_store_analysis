#weekday vs weekend payment statistics

select
w.day_type,
concat(round(w.total_payments / (select sum(payment_value) from olist_order_payments_dataset) *100,2),'%') as percentage_values
from
(select o.day_type,sum(p.payment_value) as total_payments
from olist_order_payments_dataset as p
join
(select order_id,
case
when weekday(order_purchase_timestamp) in (5,6) then "weekend"
else "weekday"
end as day_type
from olist_orders_dataset) as o
on
 o.order_id=p.order_id
 group by o.day_type) as w; 


-----------------------------------------------------kpi 2-------------------------

#no.of orders with review score is 5 and payment_type is credit_card.

create database ecommerce_project;
select count(*) from olist_order_payments_dataset;
select count(*) from olist_order_reviews_dataset;
select
count(pt.order_id)as total_orders
from olist_order_payments_dataset pt
inner join
olist_order_reviews_dataset rev on pt.order_id=rev.order_id
where rev.review_score=5
and pt.payment_type="credit_card";



-----------------------------------------------kpi 3-----------------------------------------

#avg no. of days taken for order delivery customer date for pet_shop

select prod.product_category_name,
avg(datediff(ord.order_delivered_customer_date,ord.order_purchase_timestamp)) as avg_delivery_days
from olist_orders_dataset ord
join
(select product_id,order_id,product_category_name from olist_products_dataset
join olist_order_items_dataset using(product_id)) as prod
on ord.order_id=prod.order_id
where prod.product_category_name="pet_shop"
group by prod.product_category_name;

----------------------------------------------kpi4----------------------------------------
#avg price and payment_values from customers of sao paulo city

select avg(item.price) as avg_price
from olist_order_items_dataset item
join olist_orders_dataset ord
on item.order_id=ord.order_id
join
olist_customers_dataset cust
on ord.customer_id=cust.customer_id
where cust.customer_city="sao paulo";

select avg(pt.payment_value) as avg_payment
from olist_order_payments_dataset pt
join olist_orders_dataset ord
on pt.order_id=ord.order_id
join
olist_customers_dataset cust
on ord.customer_id=cust.customer_id
where cust.customer_city="sao paulo";


------------------------------------------------------------kpi5----------------------------------
#relationship b/w shipping days(order_delivered_customer_date-order_purchase_timestamp)vs review score

select rev.review_score,
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) as avg_shipping_days
from olist_orders_dataset as o
join olist_order_reviews_dataset as rev 
on o.order_id=rev.order_id
group by rev.review_score
order by rev.review_score;


