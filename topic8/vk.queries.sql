
-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

-- Было уточнение считать лайки именно профилей пользователей и не учитывать их посты, сообщения и медиа.
-- В разрезе.
-- WITHOUT JOIN
select
	p.user_id,
	(select concat_ws(' ', u.first_name, u.last_name) from users u where u.id = p.user_id) name,
	p.birthday,
	(select count(1) from likes l where l.target_id = p.user_id and l.target_type_id = 2
	) received_likes
from profiles p order by p.birthday desc limit 10;

-- Всего
select sum(t.received_likes) from 
	(select
		p.user_id,
		(select concat_ws(' ', u.first_name, u.last_name) from users u where u.id = p.user_id) name,
		p.birthday,
		(select count(1) from likes l where l.target_id = p.user_id and l.target_type_id = 2
		) received_likes
	from profiles p order by p.birthday desc limit 10) t;
 
-- WITH JOIN
select p.user_id, concat_ws(' ', u.first_name, u.last_name) uname, p.birthday, count(l.id) from profiles p
join users u 
	on u.id = p.user_id 
left join likes l
	on p.user_id = l.target_id 
join target_types tt
	on l.target_type_id = tt.id 
where tt.name = 'users'
group by p.user_id, uname, p.birthday
order by p.birthday desc
limit 10;

/* хотел опционально разобраться с более красивым вариантом с ИТОГО.
 * Обычно такие вещи делаются в отчетах а не средствами СУБД, но было интересно.
 * К сожалению не понял почему не получилось отфильтровать только 1 строчку.
 * Если включено первое having фильтрует 10 строк нормально без итого (ожидаемо)
 * Если включено второе having фильтруется 1 нужная строчка итого (ожидаемо)
 * Но если включить через or вместо 11 ожидаемых строк выходит 21.
 * 
 * Если не сложно прошу ответить в комментарии к ДЗ, почему так выходит. 
 */
select 
	if(grouping(p.user_id), 'All', p.user_id) u_id,
	p.birthday,
	count(u.id) like_count		
from
	(select user_id, birthday from profiles order by birthday desc limit 10) p
join users u 
	on u.id = p.user_id
left join likes l
	on p.user_id = l.target_id 
join target_types tt
	on l.target_type_id = tt.id 
where tt.name = 'users'
group by p.user_id, p.birthday with rollup
-- having p.birthday is not null
-- having u_id = 'All'
having p.birthday is not null or u_id = 'All'
order by p.birthday desc;

-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- WITHOUT JOIN
-- Развертка
select 
	count(id),
	(select gender from profiles p where p.user_id = l.user_id) gender
from likes l
group by gender 

-- Ну или вообще итоговый ответ одним запросом
select concat('Most likes is putted by ', if(t.gender='m', 'MALE', 'FEMALE'), ' gender people' )
from (
	select 
		count(id) total,
		(select gender from profiles p where p.user_id = l.user_id) gender
	from likes l
	group by gender
	order by total desc 
	limit 1) t

-- WITH JOIN
select p.gender, count(l.id) total
from likes l
join profiles p 
	on p.user_id = l.user_id 
group by p.gender
order by total desc

	

/* 5. Найти 10 пользователей, которые проявляют наименьшую активность в

использовании социальной сети

(критерии активности необходимо определить самостоятельно). */
	
-- критерии будут следующими:
-- поставленный лайк - 1 балл
-- написанное сообщение человеку - 3 балла
-- написаное сообщение в группе - 5 балла
-- залитое медиа - 7 баллов
-- написанный пост - 10 баллов
-- 

/* по хорошему нас должны интересовать данные за последний период - например месяц. 
 * А за самый последний период (неделя например) умножать баллы на добавочный коэффициент.
Но учитывая запрет на джойны, в коде возникнет куча дублирования
		created_at between date_sub(now(), interval 1 month) and date_sub(now(), interval 1 week)
По этому этот не стал учитывать этот фактор. 
*/

-- WITHOUT JOIN
select 
	t.id,
	t.first_name,
	t.last_name,
	t.like_points + t.message_points + t.community_points + t.media_points + t.post_points total_points,
	t.like_points,
	t.message_points,
	t.community_points,
	t.media_points,
	t.post_points
from (
	select 
		id,
		first_name, 
		last_name,
		(select count(1) from likes l where l.user_id = u.id) like_points,
		(select count(1) from messages m where m.from_user_id = u.id and m.community_id is null) * 3 message_points,
		(select count(1) from messages m2 where m2.from_user_id = u.id and m2.community_id is not null) * 5 community_points,
		(select count(1) from media m3 where m3.user_id = u.id) * 7 media_points,
		(select count(1) from posts p where p.user_id = u.id) * 10 post_points
	from users u) t
order by total_points
limit 10;


-- WITH JOIN
-- без индексов пока не понятно какой вариант лучше, но по читабельности этот вариант ад.
select 
	t.id,
	t.first_name,
	t.last_name,
	t.lp+t.mp+t.cp+t.mmp+t.pp total,
	t.lp,
	t.mp,
	t.cp,
	t.mmp,
	t.pp
from 
	(select u.id, u.first_name, u.last_name,
			if(tlikes.points, tlikes.points, 0) lp,
			if(tmessages.points, tmessages.points, 0) mp,
			if(tcommunity.points, tcommunity.points, 0) cp,
			if(tmedia.points, tmedia.points, 0) mmp,
			if(tposts.points, tposts.points, 0) pp
		from users u
		left join 
			(select u.id, count(l.id) points
			from users u join likes l on u.id = l.user_id 
			group by u.id) tlikes
			on u.id = tlikes.id
		left join 
			(select u.id, count(m.id) * 3 points 
			from users u join messages m on u.id = m.from_user_id 
			where m.community_id is null
			group by u.id) tmessages
			on u.id = tmessages.id
		left join
			(select u.id, count(m.id) * 5 points 
			from users u join messages m on u.id = m.from_user_id 
			where m.community_id is not null
			group by u.id) tcommunity
			on u.id = tcommunity.id 
		left join 
			(select u.id, count(m.id) * 7 points
			from users u join media m on u.id = m.user_id 
			group by u.id) tmedia
			on u.id = tmedia.id
		left join 
			(select u.id, count(p.id) * 10 points
			from users u join posts p on u.id = p.user_id 
			group by u.id) tposts
			on u.id = tposts.id) t
order by total
limit 10
;


	