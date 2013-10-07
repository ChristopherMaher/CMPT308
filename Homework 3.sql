--1.Get the cities of agents booking an order for customer c002. use subquery
select city
from agents
where aid in(
	select aid
	from orders
	where cid = 'c002');

--2.Get the cities of agents booking an order for customer c002. use join
Select a.city
from agents as a join orders as o on a.aid =o.aid
where o.cid =  'c002'
 

--3. Get the pids of products ordered through any agent who makes at least one order fro a customer in kyoto. 
--subquery
Select pid
From orders
where aid in(
	Select aid
	From orders
	where cid in(
		Select cid
		From customers
		where city='Kyoto' ));

--4.Get the pids of products ordered through any agent who makes at least one order for a customer in kyoto join
select o1.pid
from customers as c join orders as o on c.cid = o.cid 
	 join orders as o1 on o.aid = o1.aid
where c.city = 'Kyoto';

--5. Get the names of customers who have never placed an order. use subquery
select name
from customers
where cid not in(
		select cid
		from orders
			);

--6. Get the names of customers who have never placed an order. Use an outer join
select c.name
from customers as c left outer join orders as o on c.cid=o.cid 
where o.cid is null;

--7.Get the names of customers who placed at least one order through an agent in their city, along with those --agents names.
select distinct c.name, a.name
from customers as c join orders as o on c.cid=o.cid
	join agents as a on o.aid=a.aid
where c.city=a.city;
--8. Get the names of customers and agents in the same city, along with the name of the city, regardless of whether --or not the customer has ever placed an order with that agent.
select distinct c.name, a2.name
from customers as c join orders as o on c.cid=o.cid
	join agents as a on o.aid=a.aid join agents as a2 on c.city=a2.city
where c.city=a2.city;

--9. Get the name and city of customers who live in the city where the least number of products are made
select distinct c.name,c.city
from customers as c join orders as o on c.cid=o.cid join products as p on p.pid=o.pid join products as p2 on c.city=p2.city
where c.city=p2.city  
and p2.city in
		(select city
		from products
		Group by city
		order by count(*)
		limit 1);
	
--10. Get the name and city of customers who live in a city where the most number of products are made.
select distinct c.name,c.city
from customers as c join orders as o on c.cid=o.cid join products as p on p.pid=o.pid join products as p2 on c.city=p2.city
where c.city=p2.city  
and p2.city in
		(select city
		from products
		Group by city
		order by count(*) desc
		limit 1);
--11. Get the name and city of customers who live in any city where the most number of products are made

select distinct c.name,c.city
from customers as c join orders as o on c.cid=o.cid join products as p on p.pid=o.pid join products as p2 on c.city=p2.city
where c.city=p2.city  
and p2.city in ( 
		select city
		from products
		group by city
		having count(city) =
				( select max(cnt) 
				from( select city, count(city) cnt
    				from products
   				 group by city
 						 ) as d
						));

--12. List the products whose priceUSD is above the average priceUSD
select *
from products
group by pid
having avg(priceUSD)> (select avg(PriceUSD) 
from products);

--13. Show the customer name,pid ordered, and the dollars for all customer orders, sorted by dollars from high to --low

select o.dollars, c.name,o.pid
from customers as c join orders as o on c.cid=o.cid 
group by o.dollars, c.name, o.pid
order by o.dollars desc;

--14. Show all customer names(in order) and their total ordered, and nothing more. Use coalesce
select c.name,sum(o.dollars)
from customers as c join orders as o on c.cid=o.cid
group by c.name
order by c.name 

--15. show the names of all customers who bought products from agents based in New York along with the names --of the products they ordered, and the names of the agents who sold it to them
select c.name, p.name, a.name
from customers as c join orders as o on c.cid=o.cid join products as p on o.pid=p.pid join agents as a on a.aid=o.aid
where a.city= 'New York'
 
--16. write a query to check the accuracy of the dollars column in orders table. 
select *
from orders as o join customers as c on o.cid=c.cid join products as p on p.pid=o.pid
where (p.priceUSD*o.qty*((100-c.discount)/100)=o.dollars)

--17. create an error in the dollars column of the orders table so that you can verify your accuracy checking query.
update orders
set dollars= 700
where ordno=1011