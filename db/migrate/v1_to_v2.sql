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

insert into posts (id, subject_id, person_id)
  select id, thread, author from forum_post;

-- assert max(modifications) <= 30
--
-- Python code:
--   values = [(10*(i+1)+i+2, 10*(i+1)+i) for i in xrange(30)]
--   for offset, length in values:
--     print "insert into revisions (post_id, body, created_at)"
--     print "  select id, content, from_unixtime(substr(date, %d, 10))" %offset
--     print "  from forum_post"
--     print "  where length(date) > %d;" % length
--     print

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(left(date, 10))
  from forum_post;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 12, 10))
  from forum_post
  where length(date) > 10;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 23, 10))
  from forum_post
  where length(date) > 21;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 34, 10))
  from forum_post
  where length(date) > 32;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 45, 10))
  from forum_post
  where length(date) > 43;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 56, 10))
  from forum_post
  where length(date) > 54;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 67, 10))
  from forum_post
  where length(date) > 65;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 78, 10))
  from forum_post
  where length(date) > 76;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 89, 10))
  from forum_post
  where length(date) > 87;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 100, 10))
  from forum_post
  where length(date) > 98;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 111, 10))
  from forum_post
  where length(date) > 109;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 122, 10))
  from forum_post
  where length(date) > 120;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 133, 10))
  from forum_post
  where length(date) > 131;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 144, 10))
  from forum_post
  where length(date) > 142;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 155, 10))
  from forum_post
  where length(date) > 153;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 166, 10))
  from forum_post
  where length(date) > 164;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 177, 10))
  from forum_post
  where length(date) > 175;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 188, 10))
  from forum_post
  where length(date) > 186;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 199, 10))
  from forum_post
  where length(date) > 197;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 210, 10))
  from forum_post
  where length(date) > 208;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 221, 10))
  from forum_post
  where length(date) > 219;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 232, 10))
  from forum_post
  where length(date) > 230;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 243, 10))
  from forum_post
  where length(date) > 241;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 254, 10))
  from forum_post
  where length(date) > 252;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 265, 10))
  from forum_post
  where length(date) > 263;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 276, 10))
  from forum_post
  where length(date) > 274;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 287, 10))
  from forum_post
  where length(date) > 285;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 298, 10))
  from forum_post
  where length(date) > 296;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 309, 10))
  from forum_post
  where length(date) > 307;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 320, 10))
  from forum_post
  where length(date) > 318;

insert into revisions (post_id, body, created_at)
  select id, content, from_unixtime(substr(date, 331, 10))
  from forum_post
  where length(date) > 329;

drop table member;
drop table forum;
drop table forum_thread;
drop table forum_post;
