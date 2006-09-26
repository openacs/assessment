-- 
-- packages/assessment/sql/postgresql/upgrade/upgrade-0.20-0.21.sql
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2006-08-03
-- @cvs-id $Id$
--

update cr_revisions set content=title where item_id in (select item_id from cr_items where content_type='as_items');
update cr_items set storage_type='text' where content_type='as_items';

alter table as_assessments rename type to type_int;
alter table as_assessments add type varchar(1000);
update as_assessments set type='survey' where type_int = 1;
update as_assessments set type='test' where type_int = 2;
alter table as_assessments drop type_int;
update acs_attributes set datatype='string' where attribute_name='type' and object_type='as_assessments';

