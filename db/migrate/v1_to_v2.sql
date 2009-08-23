drop table session;
drop table read_threads;
drop table svn_privileged;
drop table svn_user;
drop table member_hash;
drop table member_group;

insert into people (id, email, password_hash, name, nick, url, created_at, updated_at)
  select id, email, password, name, screen_name, homepage, from_unixtime(date), from_unixtime(date)
  from member;

insert into forums (name, title, description)
  select id, title, description
  from forum
  where not hidden;

insert into subjects (id, forum_id, title)
  select forum_thread.id, forums.id, forum_thread.subject
  from forum_thread, forums
  where forum_thread.forum = forums.name;

drop table member;
drop table forums;
