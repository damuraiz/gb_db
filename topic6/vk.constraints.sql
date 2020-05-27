
-- Взял первый пример из приложенного файла, отличие в стиле по этой причине. 
-- В дальнейшем исходил из того, что стратегии "on delete", "on update" не пояснялись на уроке
-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
 
-- communities
desc communities;

-- communities_users
desc communities_users;

alter table communities_users 
	add constraint communities_users_community_id_fk
		foreign key (community_id) references communities(id),
	add constraint communities_users_user_id_fk
		foreign key (user_id) references users(id);
	
-- friendship
desc friendship;

alter table friendship 
	add constraint friendship_user_id_fk
		foreign key (user_id) references users(id),
	add constraint friendship_friend_id_fk
		foreign key (friend_id) references users(id),
	add constraint friendship_status_id_fk
		foreign key (status_id) references friendship_statuses(id);

-- friendship_statuses
desc friendship_statuses;

-- likes
desc likes;

alter table likes 
	add constraint likes_user_id_fk
		foreign key (user_id) references users(id),
	add constraint likes_target_type_id_fk
		foreign key (target_type_id) references target_types(id);

-- media
desc media;

alter table media 
	add constraint media_type_id_fk
		foreign key (media_type_id) references media_types(id),
	add constraint media_user_id_fk
		foreign key (user_id) references users(id);

-- media_types
desc media_types;


-- messages
desc messages;

alter table messages 
	add constraint messages_from_user_id_fk
		foreign key (from_user_id) references users(id),
	add constraint messages_to_user_id_fk
		foreign key (to_user_id) references users(id),
	add constraint messages_community_id_fk
		foreign key (community_id) references communities(id);

-- posts
desc posts;

alter table posts 
	add constraint posts_user_id_fk
		foreign key (user_id) references users(id),
	add constraint posts_community_id_fk
		foreign key (community_id) references communities(id),
	add constraint posts_media_id_fk
		foreign key (media_id) references media(id);
	
		
-- target_types
desc target_types;  
 
