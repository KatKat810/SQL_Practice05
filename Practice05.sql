--Average Population of Each Continent
Select Continent,
FLOOR(AVG(City.population))
from City
INNER JOIN Country
on City.CountryCode=Country.Code
group by Continent;

-- Signup Activation Rate
SELECT 
ROUND((CAST(SUM(CASE
WHEN signup_action='Confirmed' Then 1
ELSE 0
END)as decimal)/(CAST(COUNT(signup_action)as Decimal))),2) As confirm_rate
from texts
inner join emails
ON texts.email_id=emails.email_id

--Sending vs. Opening Snaps
SELECT age_bucket,
ROUND((SUM(CASE WHEN activity_type='send' THEN time_spent ELSE 0 End)/
(SUM(CASE WHEN activity_type='send' THEN time_spent ELSE 0 End)+
SUM(CASE WHEN activity_type='open' THEN time_spent ELSE 0 End)))*100.0,2)as send_perc,
ROUND((SUM(CASE WHEN activity_type='open' THEN time_spent ELSE 0 End)/
(SUM(CASE WHEN activity_type='send' THEN time_spent ELSE 0 End)+
SUM(CASE WHEN activity_type='open' THEN time_spent ELSE 0 End)))*100.0,2)as open_perc
FROM activities
inner JOIN age_breakdown
ON activities.user_id=age_breakdown.user_id
GROUP BY age_bucket

-- Supercloud Customer 
SELECT customer_id
FROM customer_contracts
LEFT JOIN products
ON customer_contracts.product_id=products.product_id
WHERE product_category IN ('Analytics','Containers','Compute')
GROUP BY customer_id
HAVING COUNT(DISTINCT(product_category)) =3

--1731. The Number of Employees Which Report to Each Employee
select mgr.employee_id, mgr.name,
CASE WHEN emp.reports_to IS NOT NULL THEN count(emp.employee_id)  ELSE 0 End
as reports_count,
round(avg(emp.age),0) as average_age
from Employees as emp
join Employees as mgr
on emp.reports_to =mgr.employee_id
Group by employee_id, name

--1327. List the Products Ordered in a Period
select product_name,
sum(unit) as unit
from Products
inner join Orders 
on Products.product_id=Orders.product_id
where month (order_date)=2 and year (order_date)=2020
GROUP by product_name
Having sum(unit) >=100

--Page With No Likes 
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
ON pages.page_id=page_likes.page_id
GROUP BY pages.page_id
HAVING COUNT(user_id)=0
ORDER BY page_id ASC
