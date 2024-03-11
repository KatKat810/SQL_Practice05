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

-- Mid course Test:
----Question 1:
-----Topic: DISTINCT
-----Task: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Select distinct(replacement_cost) From Film 
-----Question: Chi phí thay thế thấp nhất là bao nhiêu?
Select Min(distinct(replacement_cost))From Film 

----Question 2:
-----Topic: CASE + GROUP BY
-----Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
-----1.	low: 9.99 - 19.99
-----2.	medium: 20.00 - 24.99
-----3.	high: 25.00 - 29.99
Select 
sum(Case WHEN Replacement_cost >=9.99 and Replacement_cost <20 THEN 1
Else 0 END) as low,
sum(Case WHEN Replacement_cost >=20 and Replacement_cost <24.99 THEN 1
Else 0 END) as medium,
sum(Case WHEN Replacement_cost >=25 THEN 1
Else 0 END) as high
From Film
------Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
Select Sum(Case WHEN Replacement_cost >=9.99 and Replacement_cost <20 THEN 1
Else 0 END) as low
From Film

----Question 3:
-----Topic: Join
-----Task: Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Select film.title, film.length,category.name as category_name
from film
inner join film_category on film.film_id=film_category.film_id
inner join category on film_category.category_id=category.category_id
WHeRE category.name in ('drama','sports')
order by category_name asc

------Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
không có - cíu

----Question 4: 
----Topic: JOIN & GROUP BY
----Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
  ----Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
  Select category.name as category_name,Count(film.title)
from film
inner join film_category on film.film_id=film_category.film_id
inner join category on film_category.category_id=category.category_id
Group by category_name
order by category_name asc

----Question 5:
----Topic: JOIN & GROUP BY
----Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
----Question: Diễn viên nào đóng nhiều phim nhất?
Select actor.first_name, actor.last_name, count(film_actor.film_id)
from actor
inner join film_Actor 
on actor.actor_id=film_Actor.film_id
Group by actor.first_name, actor.last_name
Order by count(film_actor.film_id) desc

----Question 6:
----Topic: LEFT JOIN & FILTERING
----Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Select address.address, customer.customer_id from address
Left join customer
On customer.address_id = address.address_id
WHERE customer.customer_id is null
GROUP By address.address,customer.customer_id
----Question: Có bao nhiêu địa chỉ như vậy?
Select 
Sum (case 
when customer.customer_id is null then 1
else 0 end)
from address
Left join customer
On customer.address_id = address.address_id

----Question 7:
----Topic: JOIN & GROUP BY
----Task: Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Select distinct (City.city), sum (payment.amount)
from payment
inner join customer on payment.customer_id =customer.customer_id
Inner join address on customer.address_id=address.address_id
inner join city on address.city_id=city.city_id
Group by City.city
----Question:Thành phố nào đạt doanh thu cao nhất?
Select distinct (City.city), sum(payment.amount)
from payment
inner join customer on payment.customer_id =customer.customer_id
Inner join address on customer.address_id=address.address_id
inner join city on address.city_id=city.city_id
Group by City.city
Order by sum(payment.amount) desc
limit (1)

----Question 8:
----Topic: JOIN & GROUP BY
----Task: Tạo danh sách trả ra 2 cột dữ liệu: 
------	cột 1: thông tin thành phố và đất nước ( format: “city, country")
------	cột 2: doanh thu tương ứng với cột 1
Select concat_ws(', ',City.city,country.country), sum (payment.amount)
from payment
inner join customer on payment.customer_id =customer.customer_id
Inner join address on customer.address_id=address.address_id
inner join city on address.city_id=city.city_id
Inner join country on city.country_id=country.country_id
Group by concat_ws(', ',City.city, country.country)
----Question: thành phố của đất nước nào đat doanh thu cao nhất
Select concat_ws(', ',City.city,country.country), sum (payment.amount)
from payment
inner join customer on payment.customer_id =customer.customer_id
Inner join address on customer.address_id=address.address_id
inner join city on address.city_id=city.city_id
Inner join country on city.country_id=country.country_id
Group by concat_ws(', ',City.city, country.country)
Order by sum (payment.amount) asc limit 1








