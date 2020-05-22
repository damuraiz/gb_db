use vk;

-- реализация лайков.

/*
У лайков есть достаточно специфическая фишка - для системы гораздо важнее их количество, чем кто их поставил.
Кроме того на вебинаре обозначалось, что нужна общая система не завязанная на сущности.
*/

-- Вариант в лоб, который позволил бы сохранить и нормальную форму и определенную гибкость
drop table likes;
create table likes(
	id serial,
	user_id int unsigned not null,
	post_id int unsigned,
	media_id int unsigned,
	comment_id int unsigned,
	message_id int unsigned,
	-- и другие поля добавляемые по мере изменения системы
	dt datetime default current_timestamp
	); 
	
desc likes;
/* 
  тут можно будет запилить внешние ключи. можно даже сделать проверку уникальности по user_id и всем полям сущностей.
  но во первых это фигово, так как считать каждый раз при отображении поста, количество лайков это слишком жестко.
  во вторых добавление нового поля будет очень плохой операцией которая заблокирует всю таблицу, и потребует перестройки индекса
*/

-- Нормальный вариант.
drop table content_types;
create table content_types(
	id int unsigned not null auto_increment primary key,
	code varchar(10) not null
);

desc content_types;

insert into content_types(code) values
('post'),
('media'),
('comment'),
('community'),
('message');

drop table content_likes;
create table content_likes(
	user_id int unsigned not null, 
	content_id int unsigned not null,
	content_type_id int unsigned not null,
	dt datetime default current_timestamp,
	primary key(user_id, content_id, content_type_id)
);
desc content_likes;

drop table content_likes_summury;

create table content_likes_summury(	
	content_id int unsigned not null,
	content_type_id int unsigned not null,
	like_sum int unsigned not null,
	primary key(content_id, content_type_id)
);
desc content_likes_summury;

/*
 * этот подход мне кажется более правильным, так как за счет справочника я смогу спокойно добавлять новые типы сущностей.
 * Вплоть до лайков на контент расположенный на внешних ресурсах от сторонних разработчиков (хотя тут я бы тоже расширил для секьюрити) 
 * Сумма будет считаться триггерами или программно и будет быстро доставляться на интерфейс.
 * Лайки можно будет спокойно выделить в отдельный кластер машин. 
 * Шардинг для таблицы сумм сделать по составному ключу. 
 * Шардинг для таблицы конкретных лайков я бы сделал с дублированием. Отдельно по полю user_id и по составному content_id, content_type_id)
 * Шарды по user_id я бы использовал для формирования ленты действий пользователей. Что лайкал он сам и его друзья.
 * Шарды по составному полю - для отображения интерфейса списка лайков под самим контентом. 
 * 
 * При таком подходе мы вводим большое дублирование и теряем ссылочную целостность на уровне БД, но преимущества получаем гораздо более значимые 
 */



