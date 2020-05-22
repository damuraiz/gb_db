/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
 * Заполните их текущими датой и временем.
 * 
 * Считаю что в задание имеется ввиду что ВСЕ поля были незаполненными, по этому update без where
 */

update users set
	created_at = now(),
	updated_at = now();

select * from users;

/*
 * Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались
 *  значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME,
 *  сохранив введеные ранее значения.
 */ 

-- подготовим "неудачную" таблицу, и сделаем задание на ней.
create table bad_users like users;

alter table bad_users 
	modify column created_at varchar(20),
	modify column updated_at varchar(20);
desc bad_users;

insert bad_users(name, birthday_at, created_at, updated_at) 
select name, birthday_at, date_format(created_at, '%d.%m.%Y %k:%i'), date_format(updated_at, '%d.%m.%Y %k:%i')from users;

alter table bad_users 
	add created_at_new datetime,
	add updated_at_new datetime;

update bad_users set
	created_at_new = str_to_date(created_at, '%d.%m.%Y %k:%i'),
	updated_at_new = str_to_date(updated_at, '%d.%m.%Y %k:%i');

alter table bad_users 
	drop created_at,
	drop updated_at;

-- упс, я упустил из виду, что стоило поставить версию 8 mysql и поставил 5.7 по этому не могу использовать rename и приходится change.
alter table bad_users 
	change created_at_new created_at datetime,
	change updated_at_new updated_at datetime;

select * from bad_users;

/*
	В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
	0, если товар закончился и выше нуля, если на складе имеются запасы. 
	Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
	Однако, нулевые запасы должны выводиться в конце, после всех записей.
*/

-- нагенерил склады
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('1', 'velit', '2019-11-27 01:32:55', '2010-10-20 11:42:18');
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('2', 'sed', '2017-07-22 18:15:42', '2012-01-12 19:30:50');
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('3', 'velit', '2015-06-18 11:45:39', '2020-01-06 06:40:43');
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('4', 'quod', '2019-04-11 13:00:10', '2016-02-18 14:41:55');
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('5', 'nemo', '2012-04-03 06:11:40', '2011-11-05 08:26:08');
update storehouses set updated_at = now() where created_at > updated_at;

select * from storehouses;

-- нагенерил остатки на складах
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('1', 1, 4, 4, '2020-04-23 17:42:59', '2020-05-07 00:49:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('2', 2, 4, 3, '2020-04-28 23:51:20', '2020-05-18 08:10:32');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('3', 3, 3, 1, '2020-05-12 22:52:59', '2020-05-06 14:02:31');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('4', 4, 1, 5, '2020-05-05 20:52:04', '2020-05-18 08:36:58');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('5', 5, 6, 0, '2020-04-30 18:37:02', '2020-05-14 00:30:47');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('6', 1, 6, 5, '2020-04-28 22:25:48', '2020-05-14 09:32:08');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('7', 2, 5, 4, '2020-04-23 19:33:09', '2020-05-12 14:02:40');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('8', 3, 7, 2, '2020-04-29 12:18:37', '2020-05-14 10:19:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('9', 4, 4, 5, '2020-04-30 22:36:07', '2020-05-16 03:06:10');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('10', 5, 2, 5, '2020-04-30 05:55:06', '2020-04-25 03:41:01');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('11', 1, 2, 3, '2020-05-22 10:43:51', '2020-05-16 05:14:46');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('12', 2, 1, 3, '2020-04-23 11:24:38', '2020-05-14 05:28:17');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('13', 3, 3, 1, '2020-05-05 09:37:22', '2020-05-16 17:38:54');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('14', 4, 1, 2, '2020-04-24 11:01:21', '2020-04-27 09:26:38');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('15', 5, 5, 5, '2020-04-23 22:15:36', '2020-05-16 19:24:17');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('16', 1, 7, 4, '2020-05-02 17:27:05', '2020-05-08 18:33:34');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('17', 2, 7, 4, '2020-05-03 01:29:11', '2020-05-07 12:58:58');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('18', 3, 2, 3, '2020-05-07 05:51:19', '2020-04-28 13:29:32');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('19', 4, 7, 4, '2020-05-08 05:37:38', '2020-05-12 11:51:08');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('20', 5, 1, 2, '2020-05-19 05:37:25', '2020-04-26 23:02:17');

update storehouses_products set updated_at = now() where created_at > updated_at;

-- добавим чуть больше нулей
update storehouses_products  set value = 0 where rand() < 0.3;


-- не уверен что правильно понял задачу. Вариант в лоб по описанию как на картинке.
select p.value from storehouses_products p order by if(p.value> 0,1,0) desc, p.value;

/* (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий ('may', 'august')*/

select * from users where monthname(birthday_at) in ('may', 'august');

/* (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
 *  SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN. */

-- опять не совсем понятно. Насколько я знаю в множестве порядок не имеет значения, значит единственный способ это жестко зашить скаляры.
select * from catalogs 
where id in (5,1,2)
order by case 
	when id = 5 then 1
	when id = 1 then 2
	when id = 2 then 3
end;


/* Подсчитайте средний возраст пользователей в таблице users */
select avg(timestampdiff(year, birthday_at, now())) average_age from users;


/* Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения. */
-- Формулировки конечно...
select date_format(birthday_at, '%W') week_day, count(id) from users group by week_day ;


/* (по желанию) Подсчитайте произведение чисел в столбце таблицы */
-- не нашел функцию product в мускуле аналогично excel пришлось изголяться
-- немного упростил себе задачу, считая что в списке для произведения только положителные числа, как в примере. Ну и null тоже быть не может.
select exp(sum(ln(id))) product from storehouses;

-- если добавить возможность нуля...
select if(
	(select count(1) from storehouses_products where value = 0) > 0,
	0, 
	(select exp(sum(ln(value))) from storehouses_products)
) product;

-- если добавить еще и отрицательные числа...
drop table ints;
create temporary table ints(value int not null);
insert into ints values (-1), (-2), (3), (-4), (5);
select * from ints;

select if(t.zero > 0,
	0,
	if(t.odd_negative, -1, 1) * exp(t.sum_ln)) product
from 
(select sum(if(value = 0, 1, 0)) zero, sum(if(value < 0, 1, 0)) % 2 odd_negative, sum(ln(abs(value))) sum_ln from ints) t;
 
	

