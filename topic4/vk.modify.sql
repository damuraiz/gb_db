use vk;

show tables;

select * from users limit 10;

-- users
-- корректируем даты
update users set
	updated_at =now()
where created_at > updated_at;

select count(1) from users u where created_at > updated_at;

-- media_types
-- не увидел особенность filldb по добавлению лишних пробелов при использовании randomElement
select * from media_types mt;
update media_types set name = trim(name);

-- profiles
select * from profiles limit 10;

-- ого оказывается я косякнул когда в filldb заполнял пол. Наверное пробел затесался в финальной попытке....
update profiles set
	gender = 'f'
where gender <> 'm';

-- добавляю пропущенный photo_id, добавил то, что пользователь может его не указать, допустим в 10% случаев. 
alter table profiles add column photo_id int unsigned;

desc profiles;

update profiles set
	photo_id = (
select m.id 
from media m, media_types mt
where m.media_type_id = mt.id
and mt.name = 'photo'
order by rand() limit 1)
where rand()>0.1

-- community 
-- действительно их обычно меньше чем пользователей.
delete from communities where id > 20;

-- messages 
select * from messages m limit 10;

-- по записи вебинара понял, что все-таки речь шла не о групповых чатах, 
-- а о чатах между людьми но внутри группы. Ок, возвращаем столбец. Пусть 5% диалогов идут в группе. 
alter table messages add column community_id int unsigned after to_user_id;

update messages m set
	m.community_id = (select id from communities order by rand() limit 1)
where rand()<0.05;

-- проверка на отправку самому себе
select * from messages m where from_user_id = to_user_id;

-- нашлось 9 сообщений, подправим.
update messages m set 
	m.to_user_id = (select u.id from users u where u.id <> m.from_user_id order by rand() limit 1)
where m.from_user_id = m.to_user_id ;

-- media
select * from media m limit 100;

-- корректирую даты
update media set
	updated_at =now()
where created_at > updated_at;

-- размер от 10КБ до  100МБ
update media set
	`size` = floor(10000 + rand()*100000000) 
where `size` < 10000

-- заполняю метаданные и меняю тип на JSON
update media m set
m.metadata = (
	select concat(
	'{"owner": "', u.first_name, ' ', u.last_name, '"}')
	from users u where u.id = m.user_id 
);

desc media

alter table media modify column metadata JSON;


-- friendship_statuses
select * from friendship_statuses; 

-- подправим лишние пробелы
update friendship_statuses  set 
	name = trim(name);

-- friendship
select * from friendship limit 10;
desc friendship;
-- тут неплохо было бы все-таки добавить данных. но я бы делал это в цикле, по этому, расширю когда дойду до темы процедур.

-- подправим даты. порядок.
update friendship  set 
	confirmed_at = now()
where requested_at > confirmed_at;

-- уберем confirmed_at для записей с типом requested. Специально оставляю для declined так как в vk отказ оставляет запросившего в подписчиках. Дата будет как раз подтверждением отказа.
update friendship set
	confirmed_at = null
where status_id = (select id from friendship_statuses  where name = 'requested');

-- community_users
select * from communities_users cu;

-- подправим community_id в связи с изменением количества групп. Запрос не очень, так как может рандомно приводить к ошибкам дублирования первичного ключа. 
-- Раза с 10го зашло. Лучше конечно будет потом процедуркой перезаполнить.
update communities_users set
	community_id = (select id from communities order by rand() limit 1),
	user_id = (select id from users  order by rand() limit 1)
where community_id not in (select id from communities);












