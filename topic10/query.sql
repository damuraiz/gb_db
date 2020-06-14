/* Построить запрос, который будет выводить следующие столбцы:
имя группы +
среднее количество пользователей в группах +
самый молодой пользователь в группе +
самый старший пользователь в группе +
общее количество пользователей в группе +
всего пользователей в системе+
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
*/

/* 
 * решил добавить несколько человек в группы чтобы общее количество пользователей в системе и 
 * сумма по группам не совпадало
 * 
 * учитывая рандом, скрипт возможно потребуется запускать несколько раз.
 */

insert into communities_users (user_id, community_id )
select id,
(select id from communities c order by rand() limit 1)
from users 
order by rand()
limit 20;

with 
	alls as (select count(*) cnt from profiles)
select distinct 
	c.name, 
	count(*) over () / (select count(*) from communities) as grp_avg,
	last_value(concat_ws(' ', u.first_name, u.last_name, p.birthday)) over w youngest, 
	first_value(concat_ws(' ', u.first_name, u.last_name, p.birthday)) over w oldest,
	count(p.user_id) over w as user_cnt,
	alls.cnt,
	count(p.user_id) over w / alls.cnt * 100 as prcnt
from 
	(communities_users cu
	join communities c on c.id = cu.community_id
	join profiles p on p.user_id = cu.user_id 
	join users u on u.id = p.user_id
	join alls)
window w as (partition by c.id order by p.birthday 
			range between unbounded preceding 
			and unbounded following);

