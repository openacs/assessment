-- 
-- packages/assessment/sql/postgresql/upgrade/upgrade-0.10d5-0.10d6.sql
-- 
-- @author sussdorff aolserver (sussdorff@ipxserver.de)
-- @creation-date 2005-01-29
-- @arch-tag: 4b22596d-906e-487e-a38c-49378e1a7b54
-- @cvs-id $Id$
--

alter table as_inter_item_checks add column assessment_id integer;
