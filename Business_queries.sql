select * from customer
select * from product
select * from store
select * from sales


--What is the overall business performance in terms of revenue and order volume?

select 
   sum(S.quantity * P.list_price) as Total_Revenue,
   count(Distinct S.transaction_id) as Total_Orders
from sales as S
Left join product as P
on S.product_id=P.product_id


--Insights:
--1. The business generated 12M+ total revenue from total orders 48156 indicating  overall sales perfomance is good.
--2. High number of orders indicates high customer demand and good purchasing activity.

--Which product categories contribute the most revenue?

select top 1
   P.category, 
   round(Sum(P.list_price * S.quantity),3) as Revenue
from Sales as S
join Product as P
ON S.product_id=P.product_id
GROUP BY P.category
ORDER BY Revenue Desc

--Insights:
--1. 'Shoes' category generating $2.49M  revenue indicating best performing category.
--2. High revenue means higher customer demand, marketing and inventory must focus on Shoes category for higher sales perfomance.

--How much revenue does an average store generate?

select 
  Round(AVG(total_revenue_per_store),3) as avg_revenue_per_store
from (
select 
  sum(S.quantity * P.list_price) as total_revenue_per_store
from 
Sales as S 
left JOIN Product as P
on S.product_id=P.product_id
Group by S.store_id
) as total_revenue_store

--Insights:
--1. Average revenue per store is 2.05M  indicating overall strong store level perfomance
--2. If some stores perfoming under or above this average , then it is called perfomance gaps ,then marketing and operational improvements needed.

--How does revenue vary month by month?

select  
 S.month, 
 SUM(S.quantity * P.list_price) as total_revenue_per_month
from Sales as S
left join Product as P
on S.product_id=P.product_id
Group by S.month
Order by total_revenue_per_month desc

--Insights:
--1. Revenue is around 1M+ stable for all months suggesting good sales perfomance.
--2. May month showing highest revenue than others indicating succesful promotions or seasonal demand.
--3. Febraury showing lowest revenue require more promotions strategies.

----------------------------------------------------------------------------------------------------------------------------------------
--Product Behavior Analysis
--Which 5 products generate the highest revenue?

select * from customer
select * from product
select * from store
select * from sales

select top 5
P.product_id, SUM(P.list_price * S.quantity) as Total_revenue
from Sales as S 
JOIN Product as P
on S.product_id=P.product_id
GROUP BY P.product_id
ORDER BY Total_revenue DESC

--Insights:
--1. These products are highest revenue drivers so focus on proper inventory availability and marketing strategies.
--2. Since they are highest revenue generators , stock outs may cause major loss to Business.

--Which products generate the least revenue?

select top 5
P.product_id, SUM(P.list_price * S.quantity) as Total_revenue
from Sales as S 
JOIN Product as P
on S.product_id=P.product_id
GROUP BY P.product_id
ORDER BY Total_revenue ASC

--Insights:
--1. These products are low performing products only giving revenue around $10.
--2. Keeping these products, increases warehouse storage space and holding costs so they must be reviewed by discounting, discontinuation , bundling.

--Which products are not selling or barely selling?

SELECT
P.product_id
from Product as P
left join Sales as S
on P.product_id=S.product_id
WHERE S.product_id is NULL

--Insights:
--1. These are products which have zeros sales are likely DEAD STOCK, no customer demand, increases holding cost and occupies warehouse storage space
--2. Must reviewed for discounting , bundling, change pricing or else discontinue.

--What is the average revenue generated per product?

select AVG(product_revenue) as avg_revenue_per_product
from
(select P.product_id, 
       sum(P.list_price * S.quantity) as product_revenue
	from Sales as S
	LEFT JOIN Product as P
	on P.product_id=S.product_id
	GROUP BY P.product_id
	) as revenue_table

--Insights:
--1. $412 is the average revenue per product which can considered as benchmark for performance indicator for products.
--2. Products producing revenue above $412  are strong contributors and must priortised inventory and marketing planning,  stock availability adn more promotions for strong products.
--3. Products producing revenue below $412 are inderperfoming and need pricing , promotions and stock review.

-----------------------------------------------------------------------------------------------------------------------------------------
--Customer Value Queries
--Which customers generate the highest revenue for the business?

select * from customer
select * from product
select * from store
select * from sales

select top 10
customer_id, sum(P.list_price*S.quantity) as total_revenue
from Sales as S
join Product as P
on S.product_id=P.product_id
GROUP BY customer_id
Order by total_revenue DESC

--Insights:
--1. Highest value customer is C011508 have purchase amount of %3675.5 than others.
--2. These customers are high value customers, suggesting Business must give loyalty programs, personalized offers to increase their engagement and increase revenue.

--How much does each customer spend on average per order?

select customer_id, sum(P.list_price*S.quantity)/count(distinct transaction_id) as AOV_customer
from sales as S
join Product as P
on S.product_id=P.product_id
GROUP BY customer_id
ORDER BY  AOV_customer DESC

--Insights:
--1. Highest AOV customers have AOV of $700-800 indicating these customers are buying premium/multiple products per order, business must offer them Premium offers.
--2. Business must increase purchasing power of  Lowest AOV customers via promotions or bundle/combo offers to increase their AOV.

-- Which customers purchase most frequently?

select customer_id, 
 count(distinct transaction_id) as num_orders
 from Sales
 GROUP BY customer_id
 Order BY num_orders DESC

 --Insights:
 --1. Highest number of orders made by customers are 9, suggesting business must reward them loyalty programs, personalized offers.
 --2. These customers are loyal customers, repeat purchasing customers and business must focus on encourage them for more repeat purchase.
 --3. One time buyers must offer with promotions or bundle offers


 
 select C.city , sum(XYZ.total_revenue)  as total_revenue1
 from 
 (select S.customer_id, SUM(P.list_price * S.quantity) as total_revenue
 from 
 Sales as S 
 join Product as P
 on P.product_id=S.product_id
 GROUP BY S.customer_id) as xyz
 join Customer as C
 on C.customer_id=xyz.customer_id
 group by C.City
 order by total_revenue1 desc

 --Store Performance Queries

 --Which stores generate the highest revenue  and lowest revenue for the business?

 select St.store_name, 
 sum(total_revenue_store) as total_revenue_store1,
 RANK() OVER (ORDER BY sum(total_revenue_store) DESC) as store_rank
 from 
 (select S.store_id, sum(P.list_price * S.quantity) as total_revenue_store
 from sales as S 
 join Product as P 
 on S.product_id=P.product_id
 group by S.store_id) as xyz
 join Store as St
 on xyz.store_id=St.store_id
 GROUP BY St.store_name
 ORDER BY store_rank ASC

  --Which stores perform the best and worst in terms of total revenue?


--Insights
--1. Faro outlet and Lisbon Flagship are top store performers , business must allocate more on inventory and more makrketing budget.
-- 2. All stores are generating similar revenue , suggesting less performing stores can be fixed by product mix, promotions.

--Which stores receive the most orders?

select St.store_name, count(S.transaction_id) as number_orders
from
Sales as S
join Store as St
on St.store_id=S.store_id
GROUP BY St.store_name
Order by number_orders desc

--Insights:
--1. 'Lisbon Flagship' have highest no. of orders than others indicating high customer traffic, suggesting business must focus on allocating enough resources , marketing and inventory.
--2. Almost all stores recieving similar no. of orders , less recieving stores needed promotions, marketing.

--Which is best selling product category in each store?

select * from store
select * from product
select * from sales

select * from
(
select 
xyz.store_name,
Pr.category, 
SUM(total_sales) as total_category, 
row_number() over(partition by xyz.store_name order by SUM(total_sales) desc) as rank_num
from
(select St.store_name, S.product_id, sum(P.list_price * S.quantity) as total_sales
from Product as P 
join Sales as S
on P.product_id=S.product_id
join Store as St
on S.store_id=St.store_id
group by St.store_name, S.product_id
) as xyz
join Product as Pr
on xyz.product_id=Pr.product_id
group by xyz.store_name,Pr.category
) as t
where rank_num=1

--Insights:
--1.Shoes and Dresses are best sellers product across the stores.
--2. Business must focus highly on these products inventory and promotions.





  


