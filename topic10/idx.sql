-- создаю структуры которые были описаны на занятии

-- мне удобнее работать в одном окне, запуская отдельные скрипты выделяя их,
-- по этому переделал под свои настройки dbeaver с разделителем ~
delimiter ~

use vk ~

DROP FUNCTION IF EXISTS is_row_exists ~

CREATE FUNCTION is_row_exists (target_id INT, target_type_id INT)
RETURNS BOOLEAN READS SQL DATA
BEGIN
  DECLARE table_name VARCHAR(50);
  SELECT name FROM target_types WHERE id = target_type_id INTO table_name;
  CASE table_name
    WHEN 'messages' THEN
      RETURN EXISTS(SELECT 1 FROM messages WHERE id = target_id);
    WHEN 'users' THEN 
      RETURN EXISTS(SELECT 1 FROM users WHERE id = target_id);
    WHEN 'media' THEN
      RETURN EXISTS(SELECT 1 FROM media WHERE id = target_id);
    WHEN 'posts' THEN
      RETURN EXISTS(SELECT 1 FROM posts WHERE id = target_id);
    ELSE 
      RETURN FALSE;
  END CASE;  
END ~

SELECT is_row_exists(1, 1) ~



-- Создадим триггер для проверки валидности target_id и target_type_id
 
DROP TRIGGER IF EXISTS like_validation~

CREATE TRIGGER likes_validation BEFORE INSERT ON likes
FOR EACH ROW BEGIN
  IF !is_row_exists(NEW.target_id, NEW.target_type_id) THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "Error adding like! Target table doesn't contain row id provided!";
  END IF;
END~

INSERT INTO likes (user_id, target_id, target_type_id) VALUES (34, 560000, 2) ~


CREATE UNIQUE INDEX users_email_uq ON users(email) ~

CREATE INDEX profiles_birthday_idx ON profiles(birthday) ~

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id) ~




-- пойдем по таблицам в алфавитном порядке
desc communities ~

create index communities_name_idx on communities(name) ~

desc communities_users ~

desc friendship ~
-- тут скорее всего потребуется выбирать по составному. 
create unique index friendship_user_id_friend_id_idx on friendship(user_id, friend_id) ~

desc friendship_statuses ~ -- решил не делать так как такую маленькую таблицу движок закеширует целиком

desc likes ~

-- тут скорее всего составного будет достаточно. 
-- будет аналогично автоматическим индексам foreing ключей
create index likes_target_type_id_target_id_idx on likes(target_type_id, target_id) ~ 

-- предположим что нам еще понадобится анализировать лайки по конкретному пользователю
create index likes_user_id_target_type_id_target_id_idx on likes(user_id, target_type_id, target_id) ~ 

desc media ~

-- будем сортировать по дате обновления список контента конкретного пользователя
create index media_user_id_updated_at_idx on media(user_id, updated_at) ~

-- ну и пусть будут отдельные интерфейсы для фоток, аудио и видео
create index media_user_id_media_type_id_updated_at_idx on media(user_id, media_type_id, updated_at) ~

desc media_types ~ -- слишком маленькая.

desc messages ~ 
-- сформируем интерфейс сообщений пользователя как обычно. 
-- список сообщений отсортированный по последнему полученному или отправленному сообщению. 
-- потребуются два составных индекса
create index messages_from_user_id_created_at_to_user_id_idx on messages(from_user_id, created_at, to_user_id) ~  
create index messages_to_user_id_created_at_from_user_id_idx on messages(to_user_id, created_at, from_user_id) ~  

-- ну и когда будем формировать интерфейса конкретного чата между двумя конкретными пользователями
create index messages_from_user_id_to_user_id_created_at_idx on messages(from_user_id, to_user_id, created_at) ~  
create index messages_to_user_id_from_user_id_created_at_idx on messages(to_user_id, from_user_id, created_at) ~  

desc posts ~

-- для ленты пользователя
create index posts_user_id_created_at on posts(user_id, created_at) ~

-- для ленты сообщества
create index posts_community_id_created_at on posts(community_id, created_at) ~

desc profiles ~

-- для поиска пользователей по городу и стране.
-- но обычно пользователь еще может указать пол и возраст при таком поиске
-- пол содержит слишком мало возможных значений по этому пренебрегаем
create index profiles_city_birthday_idx on profiles(city, birthday)~
create index profiles_country_city_birthday_idx on profiles(country, city, birthday) ~

desc target_types ~ -- пока слишком маленькая таблица

desc users ~
-- так как поля мыло и телефон при создании обозначены как уникальны, 
-- то индексы на эти поля создавать не нужно

-- но пользователям надо дать возможности искать по имени и фамилии причем единой строкой
-- причем пользователь может по разному ставить имя и фамилию в зависимости от принятого в своем языке
create index users_first_name_last_name_idx on users(first_name, last_name) ~
create index users_last_name_first_name_idx on users(last_name, first_name) ~







