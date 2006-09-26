-- 
-- packages/assessment/sql/oracle/upgrade/upgrade-0.20-0.21.sql
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2006-08-03
-- @cvs-id $Id$
--

update cr_revisions set content=title where item_id in (select item_id from cr_items where content_type='as_items');
update cr_items set storage_type='lob' where content_type='as_items';

alter table as_assessments rename type to type_int;
alter table as_assessments add type varchar2(1000);
update as_assessments set type='survey' where type_int = 1;
update as_assessments set type='test' where type_int = 2;

drop view as_assessmentsx;
drop view as_assessmentsi;

begin
content_type.refresh_view('as_assessments');
end;
/

alter table as_assessments drop type_int;
update acs_attributes set datatype='string' where attribute_name='type' and object_type='as_assessments';

