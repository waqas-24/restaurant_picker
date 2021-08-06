create database sales;

show databases;

use sales;

drop table if exists prices;
CREATE TABLE prices (product VARCHAR(20), price_effective_date date,
       price int);

insert into prices VALUES ('product_1',STR_TO_DATE('1-01-2018', '%d-%m-%Y'),50);  
insert into prices VALUES ('product_2',STR_TO_DATE('1-01-2018', '%d-%m-%Y'),40);  
insert into prices VALUES ('product_1',STR_TO_DATE('3-01-2018', '%d-%m-%Y'),25);  
insert into prices VALUES ('product_2',STR_TO_DATE('5-01-2018', '%d-%m-%Y'),20);  
insert into prices VALUES ('product_1',STR_TO_DATE('10-01-2018', '%d-%m-%Y'),50);  
insert into prices VALUES ('product_2',STR_TO_DATE('12-01-2018', '%d-%m-%Y'),40);  

select product, DATE_FORMAT(price_effective_date, '%d/%m/%Y') as price_effective_date,price from prices;

drop table if exists sales;
CREATE TABLE sales (product VARCHAR(20), sales_date date,
       quantity int);

insert into sales VALUES ('product_1',STR_TO_DATE('1-01-2018', '%d-%m-%Y'),10);  
insert into sales VALUES ('product_2',STR_TO_DATE('2-01-2018', '%d-%m-%Y'),12);  
insert into sales VALUES ('product_1',STR_TO_DATE('4-01-2018', '%d-%m-%Y'),50);  
insert into sales VALUES ('product_2',STR_TO_DATE('6-01-2018', '%d-%m-%Y'),70);  
insert into sales VALUES ('product_1',STR_TO_DATE('12-01-2018', '%d-%m-%Y'),8);  
insert into sales VALUES ('product_2',STR_TO_DATE('15-01-2018', '%d-%m-%Y'),9); 

select product, DATE_FORMAT(sales_date, '%d/%m/%Y') as sales_date,quantity from sales
;


-- Transactional Level Revenue
select Y.product, Y.sales_date, Y.price_date_used, Y.quantity, pr.price, pr.price*Y.quantity as revenue  from 

(select X.product,X.sales_date,X.quantity,MAX(X.current_price_date) as price_date_used from

(select s.product,s.sales_date,p.price_effective_date,s.quantity,
CASE
    WHEN s.sales_date >= p.price_effective_date THEN p.price_effective_date
END AS current_price_date
from sales as s
left join prices as p
on s.product = p.product) as X 

group by X.product, X.sales_date,X.quantity
HAVING MAX(X.current_price_date) IS NOT NULL) as Y

left join prices as pr
on (Y.price_date_used = pr.price_effective_date) and (pr.product=Y.product);


-- Total Revenue
select sum(pr.price*Y.quantity) as revenue  from 

(select X.product,X.sales_date,X.quantity,MAX(X.current_price_date) as price_date_used from

(select s.product,s.sales_date,p.price_effective_date,s.quantity,
CASE
    WHEN s.sales_date >= p.price_effective_date THEN p.price_effective_date
END AS current_price_date
from sales as s
left join prices as p
on s.product = p.product) as X 

group by X.product, X.sales_date,X.quantity
HAVING MAX(X.current_price_date) IS NOT NULL) as Y

left join prices as pr
on (Y.price_date_used = pr.price_effective_date) and (pr.product=Y.product);