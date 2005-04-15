-- 
-- 
-- 
-- @author Victor Guerra (guerra@galileo.edu)
-- @creation-date 2005-04-14
-- @arch-tag: 2d974b78-55b8-4f2a-bb8b-759b518700a3
-- @cvs-id $Id$
--

alter table as_assessments add column random_p char(1);
alter table as_assessments alter random_p set default 't';
alter table as_assessments add constraint as_assessments_random__ck check (random_p in ('t','f'));
