-- На MySQL 8 я мигрировал. Ошибку с текущим годом в ДЗ подправил. 
-- В этом задании просили не использовать джойны

-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

-- Было уточнение считать лайки именно профилей пользователей и не учитывать их посты, сообщения и медиа.
-- В разрезе.
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



-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
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
order by total_points;


select * from likes limit 10;
	