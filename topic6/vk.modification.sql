-- создаем таблицы постов по предложенному на вебинаре скрипту
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Заполнение постов
insert into posts(user_id, community_id, head, body, media_id, created_at)
	select
		floor(1+rand()*100),
		if(rand()<0.1, floor(1+rand()*20), null), -- заполняю только для 10% полей
		(select substring(body, 1, 100) from messages order by rand() limit 1), -- пусть для заголовка используются первые 100 символов из сообщений 
		(select body from messages order by rand() limit 1),
		if(rand()<0.5, (select id from media order by rand() limit 1), null), -- заполним для 50%
		from_unixtime(unix_timestamp(now()) - floor(rand() * 31536000)) -- рандомное время за последний год
	from messages;			


-- создаем таблицы лайков по предложенным на вебинаре скриптам

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
 
 -- Заполним лайки отдельно для каждого типа
desc likes;

-- для сообщений
insert into likes(user_id, target_id, target_type_id)
 	select 
		floor(1 + rand()*100),
		floor(1 + rand()*1000),
		(select id from target_types where name = 'messages')
	from messages;


-- для пользователей (беру из messages чтобы было больше данных)
insert into likes(user_id, target_id, target_type_id)
 	select 
		floor(1 + rand()*100),
		floor(1 + rand()*100),
		(select id from target_types where name = 'users')
	from messages;

-- для пользователей (беру из messages чтобы было больше данных)
insert into likes(user_id, target_id, target_type_id)
 	select 
		floor(1 + rand()*100),
		floor(1 + rand()*100),
		(select id from target_types where name = 'users')
	from messages;

-- для медиа (беру из messages чтобы было больше данных)
insert into likes(user_id, target_id, target_type_id)
 	select 
		floor(1 + rand()*100),
		floor(1 + rand()*100),
		(select id from target_types where name = 'media')
	from messages;

-- для постов (перемножил posts и communities для объема)
insert into likes(user_id, target_id, target_type_id)
 	select 
		floor(1 + rand()*100),
		floor(1 + rand()*1000),
		(select id from target_types where name = 'posts')
	from 
		posts, communities;


-- проверим на дубли
select count(*) from likes l1, likes l2 
where l1.user_id = l2.user_id
and l1.target_id =l2.target_id 
and l1.target_type_id = l2.target_type_id 
and l1.id <> l2.id;

-- у меня оказалось 4048. Зачистим дубли

create temporary table bad_like_ids (id int not null);

insert into bad_like_ids  
	select l2.id from likes l1, likes l2 
	where l1.user_id = l2.user_id
	and l1.target_id =l2.target_id 
	and l1.target_type_id = l2.target_type_id 
	and l1.id <> l2.id;

select count(1) from bad_like_ids;

-- Удалилось порядка 3000 дублирующих строк. 
delete from likes where id in (
	select id from bad_like_ids
);

select target_type_id, count(1) from likes group by target_type_id;


