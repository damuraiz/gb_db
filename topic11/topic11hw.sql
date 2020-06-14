delimiter ~

use shop ~

/* 
 * Создайте таблицу logs типа Archive.
 * Пусть при каждом создании записи в таблицах users, catalogs и products 
 * в таблицу logs помещается время и дата создания записи, название таблицы, 
 * идентификатор первичного ключа и содержимое поля name.
 */

drop table if exists logs ~

create table logs(
	id serial,
	dt timestamp not null default current_timestamp,
	table_name varchar(20) not null, 
	pk_id bigint not null,
	name_val varchar(255)
) engine = Archive ~

desc logs ~

drop procedure if exists log_insert ~
create procedure log_insert(in table_name varchar(20), in table_pk bigint, in name_val varchar(255))
begin 
	insert into logs(table_name, pk_id, name_val) values (table_name, table_pk, name_val);
end~

drop trigger if exists users_logger ~
create trigger users_logger after insert on users
for each row
begin
	call log_insert('users', new.id, new.name);	
end ~

drop trigger if exists catalogs_logger ~
create trigger catalogs_logger after insert on catalogs
for each row
begin
	call log_insert('catalogs', new.id, new.name);	
end ~

drop trigger if exists products_logger ~
create trigger products_logger after insert on products
for each row
begin
	call log_insert('products', new.id, new.name);	
end ~

-- проверяем 
insert into users(name, birthday_at) values ('Дамир', '1985-04-10')~
select * from users~
select * from logs ~

insert into catalogs(name) values ('Системы охлаждения'), ('Блоки питания') ~
select * from catalogs~
select * from logs ~

insert into products(name, price, catalog_id) values
('Cooler Master Hyper 212', 2700, 6),
('IN WIN IP-S600BQ3-3 600W', 3300, 7) ~
select * from products ~
select * from logs~

/*
 * (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей
 */

-- если бы мне было запрещено менять системные переменные на сервере,
-- то можно было бы взять произведение двух временных таблиц num
set @t_max_recursion_depth = @@cte_max_recursion_depth ~
set @@cte_max_recursion_depth = 1000000 ~

insert into users(name, birthday_at)
with recursive num(n) as
(
	select 0 
	union all
	select n+1 from num where n < 999999
)
select
	concat('dummy',lpad(n, 6, 0)) uname,
	from_unixtime(unix_timestamp('1980-01-01') + floor(0 + rand() * 946080000)) ubirthday -- 30 лет рандома
from num ~

set @@cte_max_recursion_depth = @t_max_recursion_depth~
select @@cte_max_recursion_depth~

-- результат 4 минуты. Машина амазон минимальная. Имхо норм. 

select * from logs~

delimiter ;