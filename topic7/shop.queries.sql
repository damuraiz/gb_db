-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

-- заполним заказы
insert into orders(user_id)
	select (select id from users order by rand() limit 1)
	from users;

-- вариант 1
select distinct u.id, u.name 
from users u left join orders o on u.id = o.user_id;

-- вариант 2 
select u.id, u.name 
from users u left join orders o on u.id = o.user_id
group by u.id, u.name;
-- брал вместе с id так как в общем случае name может совпадать.

-- Выведите список товаров products и разделов catalogs, который соответствует товару.

select p.name, c.name 
from products p join catalogs c on p.catalog_id = c.id;

-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

drop table if exists flights;
create table flights(id int, `from` varchar(10), `to` varchar(10));
insert into flights 
values 
	(1, 'moscow', 'omsk'),
	(2, 'novgorod', 'kazan'),
	(3, 'irkutsk', 'moscow'),
	(4, 'omsk', 'irkutsk'),
	(5, 'moscow', 'kazan');

drop table cities;
create table cities(label varchar(10), name varchar(10));
insert into cities
values
	('moscow','Москва'),
	('irkutsk','Иркутск'),
	('novgorod','Новгород'),
	('kazan','Казань'),
	('omsk','Омск');

select concat_ws('-', cf.name, ct.name) 
from flights f 
join cities cf on f.from = cf.label
join cities ct on f.to = ct.label;


