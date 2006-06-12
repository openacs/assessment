-- 
-- packages/assessment/sql/postgresql/upgrade/upgrade-0.15-0.16.sql
-- 
-- @author Roel Canicula (roel@solutiongrove.com)
-- @creation-date 2005-10-30
-- @arch-tag: 4fdc81f0-2150-489c-9fd9-c23595b59559
-- @cvs-id $Id$
--

alter table as_item_display_sb add prepend_empty_p char(1);
alter table as_item_display_sb alter prepend_empty_p set default 'f';
update as_item_display_sb set prepend_empty_p = 'f';