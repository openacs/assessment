-- 
-- packages/assessment/sql/oracle/upgrade/upgrade-0.20-0.21.sql
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2006-08-03
-- @cvs-id $Id$
--

update cr_revisions set content=title where item_id in (select item_id from cr_items where content_type='as_items');