-- 
-- packages/assessment/sql/postgresql/upgrade/upgrade-0.16-0.17.sql
-- 
-- @author Roel Canicula (roel@solutiongrove.com)
-- @creation-date 2006-01-25
-- @arch-tag: 63dc39c9-c94d-454b-ac93-b81135ebb6ae
-- @cvs-id $Id$
--

alter table as_items add validate_block text;
