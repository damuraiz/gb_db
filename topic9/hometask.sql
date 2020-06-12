-- ДЗ из раздела про транзакции 

-- первоначально создал пустные базы shop и sample
-- создаю структуру и наполнение shop предоставленным скриптом
use shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание', -- тут была ошибка в названии столбца 
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

-- создаем аналогичную структуру в sample но без наполнения.

use sample;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание', -- тут была ошибка в названии столбца 
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


/*
 * В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
 * Используйте транзакции.

 */

select * from shop.users;
select * from sample.users;

start transaction;
insert into sample.users select * from shop.users where id = 1;
delete from shop.users where id = 1;
commit;

/*
 * Создайте представление, которое выводит название name товарной позиции из таблицы products 
 * и соответствующее название каталога name из таблицы catalogs.
 */
use shop;

drop view if exists product_catalogs;

create view product_catalogs as
select p.name prod, c.name cat from products p 
	join catalogs c on p.catalog_id = c.id;

select * from product_catalogs;

/*  Пусть имеется таблица с календарным полем created_at. 
 *  В ней размещены разряженые календарные записи за август 2018 года
 *  '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 * Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
 *  если дата присутствует в исходном таблице и 0, если она отсутствует.
 */

drop table if exists august;
create table august(dt date);
insert into august values('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');

select * from august;

-- для интереса сделал так чтобы запрос изначально не знал о месяце и годе в датах которые находятся в таблице
with recursive num(n) as
(
	select 1 
	union all
	select n+1 from num where n < 31
)
select date(concat_ws('-', year((select dt from august limit 1)),
						month((select dt from august limit 1)), 
						n)) as dt,
		if(dt is null, 0, 1) status
from num
left join august on n = day(dt);


/* 
 * Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
 */

drop table if exists temp_dates;
create table temp_dates(id serial, created_at date);

-- заполняю таблицу 50ю рандомными датами за 2020 год. 
insert into temp_dates(created_at) 
with recursive num(n) as
(
	select 1 
	union all
	select n+1 from num where n < 50
)
select from_unixtime(unix_timestamp('2020-01-01') + floor(0 + rand() * 31536000)) from num;

-- смотрим что получилось 
select * from temp_dates order by created_at desc;

-- удаляю все кроме 5 самых свежих
delete from temp_dates where id not in (
	select * from 
		(select id from temp_dates order by created_at desc limit 5) t
	);

-- смотрим что получилось
select * from temp_dates;


-- ДЗ из раздела про процедуры и функции

/* Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 *  С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
 *  с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер",
 *  с 00:00 до 6:00 — "Доброй ночи".
 */
 
-- тут мне пришлось в настройках dbeaver выставить delimiter равным ~, так как он не умеет этого делать скриптом

set time_zone = '+03:00' ~ -- этой командой я игрался чтобы проверить скрипт.

drop function if exists hello ~

create function hello()
returns text no sql
begin 
	if curtime() < '06:00' then 
		return 'Доброй ночи';
	elseif curtime() < '12:00' then 
		return 'Доброе утро';
	elseif curtime() < '18:00' then
		return 'Добрый день';
	else
		return 'Добрый вечер';
	end if;
end ~


select hello() ~


/* 
 * В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 * Допустимо присутствие обоих полей или одно из них. 
 * Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.
 */

select * from products ~

drop trigger if exists product_checker_insert ~
create trigger product_checker_insert before insert on products 
for each row 
begin 
	if new.name is null and new.description is null then
		signal sqlstate '45000' set message_text = 'name and description cannot be null at the same time! Insert operation is aborted!';
	end if;
end ~

drop trigger if exists product_checker_update ~
create trigger product_checker_update before update on products
for each row
begin 
	if new.name is null and new.description is null then
		signal sqlstate '45000' set message_text = 'name and description cannot be null at the same time! Update operation is aborted!';
	end if;
end ~

-- проверим insert
insert into products (price, catalog_id) values (1000, 1) ~ -- ошибка

-- проверим update
select * from products ~
update products 
	set name = null 
where id = 1 ~ -- успешно

update products 
	set description = null 
where id = 2 ~  -- успешно

update products 
	set name = null 
where id = 2 ~  -- ошибка

/*
 *  Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
 *  Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
 *  Вызов функции FIBONACCI(10) должен возвращать число 55.
 */

drop function if exists fibonacci ~
create function fibonacci(n int unsigned)
returns int unsigned deterministic
begin
	declare t1 int unsigned default 0;
	declare t2 int unsigned default 1;
	declare t int unsigned;
	declare i int unsigned default 1;
	if n < 2 then
		return n;
	else
		repeat
			set t = t1;
			set t1 = t2;
			set t2 = t + t1;
			set i = i + 1;
		until i >= n
		end repeat;
		return t2;
	end if;
end ~

-- проверим
with recursive num(n) as
(
	select 0 
	union all
	select n+1 from num where n < 10
)
select n, fibonacci(n) from num ~



