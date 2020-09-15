-- simple script that copy phpbb2 content to discourse
-- use same id in discourse as set in phpbb2
-- warning remove all content before import !!

CREATE OR REPLACE FUNCTION slugify("value" TEXT)
RETURNS TEXT AS $$
  -- lowercases the string
  WITH "lowercase" AS (
    SELECT lower("value") AS "value"
  ),
  -- replaces anything that's not a letter, number, hyphen('-'), or underscore('_') with a hyphen('-')
  "hyphenated" AS (
    SELECT regexp_replace("value", '[^a-z0-9\\-_]+', '-', 'gi') AS "value"
    FROM "lowercase"
  ),
  -- trims hyphens('-') if they exist on the head or tail of the string
  "trimmed" AS (
    SELECT regexp_replace(regexp_replace("value", '\\-+$', ''), '^\\-', '') AS "value"
    FROM "hyphenated"
  )
  SELECT "value" FROM "trimmed";
$$ LANGUAGE SQL STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION flag("value" INT)
RETURNS TEXT AS $$
  SELECT case 
 	when value=1 then ''
	when value=2 then ':afghanistan:'
	when value=3 then ':albania:'
	when value=4 then ':algeria:'
	when value=5 then ':american_samoa:'
	when value=6 then ':andorra:'
	when value=9 then ':argentina:'
	when value=10 then ':armenia:'
	when value=11 then ':aruba:'
	when value=12 then ':australia:'
	when value=13 then ':austria:'
	when value=14 then ':azerbaijan:'
	when value=15 then ':bahamas:'
	when value=16 then ':bahrain:'
	when value=17 then ':bangladesh:'
	when value=18 then ':barbados:'
	when value=19 then ':belarus:'
	when value=20 then ':belgium:'
	when value=27 then ':botswana:'
	when value=28 then ':brazil:'
	when value=30 then ':bulgaria:'
	when value=32 then ':myanmar:'
	when value=34 then ':cambodia:'
	when value=35 then ':cameroon:'
	when value=36 then ':canada:'
	when value=40 then ':chile:'
	when value=41 then ':cn:'
	when value=42 then ':cote_divoire:'
	when value=43 then ':colombia:'
	when value=44 then ':comoros:'
	when value=46 then ':costa_rica:'
	when value=47 then ':croatia:'
	when value=48 then ':cuba:'
	when value=49 then ':cyprus:'
	when value=50 then ':czech_republic:'
	when value=52 then ':denmark:'
	when value=53 then ':djibouti:'
	when value=56 then ':timor_leste:'
	when value=57 then ':ecuador:'
	when value=58 then ':egypt:'
	when value=59 then ':el_salvador:'
	when value=62 then ':estonia:'
	when value=64 then ':faroe_islands:'
	when value=66 then ':finland:'
	when value=67 then ':fr:'
	when value=68 then ':gabon:'
	when value=71 then ':de:'
	when value=72 then ':ghana:'
	when value=73 then ':greece:'
	when value=77 then ':guatemala:'
	when value=80 then ':guyana:'
	when value=83 then ':hong_kong:'
	when value=84 then ':hungary:'
	when value=85 then ':iceland:'
	when value=86 then ':india:'
	when value=87 then ':indonesia:'
	when value=88 then ':iran:'
	when value=89 then ':iraq:'
	when value=90 then ':ireland:'
	when value=91 then ':israel:'
	when value=92 then ':it:'
	when value=93 then ':jamaica:'
	when value=94 then ':japan:'
	when value=95 then ':jordan:'
	when value=96 then ':kazakhstan:'
	when value=97 then ':kenya:'
	when value=99 then ':kuwait:'
	when value=102 then ':latvia:'
	when value=103 then ':lebanon:'
	when value=107 then ':liechtenstein:'
	when value=108 then ':lithuania:'
	when value=109 then ':luxembourg:'
	when value=110 then ':macau:'
	when value=111 then ':macedonia:'
	when value=112 then ':madagascar:'
	when value=113 then ':malawi:'
	when value=114 then ':malaysia:'
	when value=115 then ':maldives:'
	when value=117 then ':malta:'
	when value=118 then ':marshall_islands:'
	when value=120 then ':mauritius:'
	when value=121 then ':mexico:'
	when value=123 then ':moldova:'
	when value=124 then ':monaco:'
	when value=126 then ':morocco:'
	when value=130 then ':nepal:'
	when value=131 then ':caribbean_netherlands:'
	when value=132 then ':netherlands:'
	when value=133 then ':new_zealand:'
	when value=136 then ':nigeria:'
	when value=138 then ':norway:'
	when value=140 then ':pakistan:'
	when value=142 then ':panama:'
	when value=145 then ':peru:'
	when value=146 then ':philippines:'
	when value=147 then ':poland:'
	when value=148 then ':portugal:'
	when value=149 then ':puerto_rico:'
	when value=150 then ':qatar:'
	when value=151 then ':romania:'
	when value=152 then ':ru:'
	when value=156 then ':sao_tome_principe:'
	when value=157 then ':saudi_arabia:'
	when value=162 then ':singapore:'
	when value=163 then ':slovakia:'
	when value=164 then ':slovenia:'
	when value=167 then ':south_africa:'
	when value=168 then ':kr:'
	when value=169 then ':es:'
	when value=172 then ':st_lucia:'
	when value=173 then ':sudan:'
	when value=176 then ':sweden:'
	when value=177 then ':switzerland:'
	when value=178 then ':syria:'
	when value=179 then ':taiwan:'
	when value=182 then ':thailand:'
	when value=185 then ':trinidad_tobago:'
	when value=186 then ':tunisia:'
	when value=187 then ':turkey:'
	when value=190 then ':united_arab_emirates:'
	when value=191 then ':uganda:'
	when value=192 then ':uk:'
	when value=193 then ':ukraine:'
	when value=194 then ':uruguay:'
	when value=195 then ':us:'
	when value=196 then ':uzbekistan:'
	when value=197 then ':vanuatu:'
	when value=198 then ':vatican_city:'
	when value=199 then ':venezuela:'
	when value=200 then ':vietnam:'
	when value=202 then ':zambia:'
	when value=203 then ':zimbabwe:'
 	else 'bli' end;
$$ LANGUAGE SQL STRICT IMMUTABLE;


-- Purge

delete from categories;
delete from category_groups;
delete from topics;
delete from posts;
delete from custom_emojis;
delete from uploads where id>0;
delete from post_uploads;

-- delete from users where id > 1;
-- delete from user_emails where user_id > 1;
-- delete from user_options where user_id > 1;
-- delete from user_profiles where user_id > 1;
-- delete from user_stats where user_id > 1;

-- Insert users

-- insert into users (id, username, name, active, created_at, updated_at, previous_visit_at, username_lower, trust_level, approved)
-- select user_id, username, username, user_active, to_timestamp(user_regdate), to_timestamp(user_regdate), to_timestamp(user_lastvisit), lower(username), 1, true
-- from "database".busobj_users
-- where user_id > 1;

-- insert into user_emails (id, user_id, email, "primary", created_at, updated_at)
-- select user_id, user_id, user_email, true, to_timestamp(user_regdate), to_timestamp(user_regdate)
-- from "database".busobj_users
-- where user_id > 1;

-- insert into user_options (user_id)
-- select user_id
-- from "database".busobj_users
-- where user_id > 1;

-- insert into user_profiles (user_id)
-- select user_id
-- from "database".busobj_users
-- where user_id > 1;

-- insert into user_stats (user_id, new_since)
-- select user_id, to_timestamp(user_regdate)
-- from "database".busobj_users
-- where user_id > 1;

-- Insert categories as categories (3 categories)

insert into categories (id, name, sort_order, created_at, updated_at, user_id, slug, name_lower)
select cat_id, cat_title, cat_order, now(), now(), -1, slugify(cat_title), lower(cat_title) from database.busobj_categories c;

-- Insert forums as sub-categories

insert into categories (id, name, sort_order, created_at, updated_at, user_id, slug, name_lower, parent_category_id)
select forum_id+100, forum_name, forum_order, now(), now(), -1, slugify(forum_name), lower(forum_name), cat_id
from "database".busobj_forums
where parent_forum_id=0;

-- Insert sub-forums as sub-sub-categories

insert into categories (id, name, sort_order, created_at, updated_at, user_id, slug, name_lower, parent_category_id)
select forum_id+100, substring(forum_name,1,50), forum_order, now(), now(), -1, substring(slugify(forum_name),1,50), substring(lower(forum_name),1,50), parent_forum_id+100
from "database".busobj_forums
where parent_forum_id!=0;

-- Insert forum security -> Adm only to be more precise after

insert into category_groups (category_id, group_id, created_at, updated_at, permission_type)
select forum_id+100, 1 /* Adm */, now(), now(), 1 from "database".busobj_forums where auth_view <> 0;

update categories set read_restricted=true where id in
(select forum_id+100 from "database".busobj_forums where auth_view <> 0);

-- Insert topics with all stats!

insert into topics (id, title, category_id, created_at, updated_at, last_post_user_id, bumped_at, user_id, last_posted_at, "views", reply_count, posts_count, pinned_at )
select t.topic_id, t.topic_title, t.forum_id+100, to_timestamp(fp.post_time), to_timestamp(lp.post_time ), 
lp.poster_id, to_timestamp(lp.post_time), fp.poster_id, to_timestamp(lp.post_time), t.topic_views, t.topic_replies, t.topic_replies+1,
case when t.topic_type=1 then now() else null end
from database.busobj_topics t
join "database".busobj_posts fp on t.topic_first_post_id = fp.post_id 
join "database".busobj_posts lp on t.topic_last_post_id = lp.post_id;

-- Insert posts

insert into posts (id, user_id, topic_id, post_number, raw, cooked, created_at, updated_at, last_version_at, sort_order)
select p.post_id, p.poster_id, p.topic_id, p.post_id, 
t.post_text  || chr(10) || chr(10) || '---' || chr(10) || chr(10) || '**' || p.post_username || '**' ||
flag(p.flag_id)  || '_(BOB member since ' || to_char(to_timestamp(p.user_join_date), 'YYYY-MM-DD')  || ')_',
t.post_text, to_timestamp(p.post_time), 
case when p.post_edit_time is null then to_timestamp(p.post_time) else to_timestamp(p.post_edit_time) end, 
case when p.post_edit_time is null then to_timestamp(p.post_time) else to_timestamp(p.post_edit_time) end, 
1 from database.busobj_posts p
join database.busobj_posts_text t on p.post_id=t.post_id and p.post_edit_count=t.post_version;

-- Update bbcode issues (like [quote:0681c43013="Michael"])

-- update bbcode quote (add extra line-break because discourse parser limitation https://meta.discourse.org/t/bbcode-quote-tag-and-mixed-newlines/103708/3)
-- remove bbcode color (https://meta.discourse.org/t/discourse-bbcode-color/65363 doable but plugin)
-- remove bbcode size (https://meta.discourse.org/t/discourse-bbcode/65425 doable but plugin)
update posts set raw = 
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(raw, 
    '\[quote:(\w*)="([a-zA-Z0-9_ ]*)"\]', chr(10) || '[quote="\2"]' || chr(10), 'g'), 
    '\[quote:(\w*)\]', chr(10) || '[quote]' || chr(10), 'g'), 
    '\[/quote:(\w*)\]', chr(10) || '[/quote]' || chr(10), 'g'), 
    '\[color=(#\w*):(\w*)\]', '', 'g'), 
    '\[/color:(\w*)\]', '', 'g'), 
    '\[size=\d+:(\w*)\]', '', 'g'),
    '\[/size:(\w*)\]', '', 'g')
where position('[' in raw)>0;

-- update bbcode b-i-u
update posts set raw = 
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(raw, 
    '\[/u:(\w*)\]', '[/u]', 'g'), 
    '\[u:(\w*)\]', '[u]', 'g'), 
    '\[/i:(\w*)\]', '[/i]', 'g'), 
    '\[i:(\w*)\]', '[i]', 'g'), 
    '\[/b:(\w*)\]', '[/b]', 'g'), 
    '\[b:(\w*)\]', '[b]', 'g')
where position('[' in raw)>0;

-- update bbcode list-img-code
update posts set raw = 
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(
    regexp_replace(raw, 
    '\[list:(\w*)\]', '[list]', 'g'), 
    '\[/list:(\w*)\]', '[/list]', 'g'), 
    '\[/list:\w:(\w*)\]', '[/list]', 'g'), 
    '\[img:(\w*)\]', '[img]', 'g'), 
    '\[/img:(\w*)\]', '[/img]', 'g'), 
    '\[code:\d:(\w*)\]', chr(10) || '[code]' || chr(10), 'g'),
    '\[/code:\d:(\w*)\]', chr(10) || '[/code]' || chr(10), 'g')
where position('[' in raw)>0;

-- Insert emoji !
-- we must put the gif in /uploads/default/original/1X/ folder

insert into custom_emojis (id, name, upload_id, created_at, updated_at)
select smilies_id, replace(code,':',''),  smilies_id, now(), now() 
from "database".busobj_smilies
where code like ':%:';

insert into uploads (id, user_id, original_filename, url, created_at, updated_at, extension, filesize)
select smilies_id, 1, smile_url, '/uploads/default/original/1X/' || smile_url, now(), now(), 'gif', 300
from "database".busobj_smilies
where code like ':%:';

-- Insert uploads (add 100 to let 100 emoji max before)
-- we must put the files in /uploads/default/original/1X/ folder

insert into uploads (id, user_id, original_filename, filesize, url, created_at, updated_at, "extension")
select a.attach_id+100, a.user_id_1, d.real_filename, d.filesize, '/uploads/default/original/1X/' || d.physical_filename, to_timestamp(d.filetime), to_timestamp(d.filetime), d."extension" from "database".busobj_attachments a
join "database".busobj_attachments_desc d on a.attach_id=d.attach_id;

insert into post_uploads (id, post_id, upload_id)
select attach_id, post_id, attach_id+100 from "database".busobj_attachments;

-- Add in posts the images

DO $$
declare
    temprow record;
begin
	for temprow in
		select  a.post_id post_id,
		'![' || d.real_filename || '](/uploads/default/original/1X/' || d.physical_filename || ')' markdown
		from "database".busobj_attachments a
		join "database".busobj_attachments_desc d on a.attach_id=d.attach_id
		where substring(d.mimetype,1,5)='image'
	loop
		update posts set raw = replace(raw, 
            chr(10) || chr(10) || '---' || chr(10) || chr(10), 
            chr(10) /* new line */ || temprow.markdown || chr(10) || chr(10) || '---' || chr(10) || chr(10))
        where id = temprow.post_id;
	end loop;
end
$$;

-- Add in posts the other files

DO $$
declare
    temprow record;
begin
	for temprow in
		select  a.post_id post_id,
		'[' || d.real_filename || '|attachment](/uploads/default/original/1X/' || d.physical_filename || ') (' || round(d.filesize/1000,1) || ' KB)' markdown
		from "database".busobj_attachments a
		join "database".busobj_attachments_desc d on a.attach_id=d.attach_id
		where substring(d.mimetype,1,5)!='image'
	loop
		update posts set raw = replace(raw, 
            chr(10) || chr(10) || '---' || chr(10) || chr(10), 
            chr(10) /* new line */ || temprow.markdown || chr(10) || chr(10) || '---' || chr(10) || chr(10))
        where id = temprow.post_id;
	end loop;
end
$$;

-- Reset sequences

select setval('users_id_seq', max(id)) from users;
select setval('user_emails_id_seq', max(id)) from user_emails;
select setval('categories_id_seq', max(id)) from categories;
select setval('topics_id_seq', max(id)) from topics;
select setval('posts_id_seq', max(id)) from posts;
select setval('uploads_id_seq', max(id)) from uploads;
select setval('post_uploads_id_seq', max(id)) from post_uploads;
select setval('custom_emojis_id_seq', max(id)) from custom_emojis;