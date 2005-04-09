alter table as_assessments add column random_p char(1) constraint as_assessments_random_p_ck check (random_p in ('t','f'));
alter table as_assessments alter column random_p set default 't';
