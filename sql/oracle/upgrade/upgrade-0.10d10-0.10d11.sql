alter table as_assessments add (
	random_p	char(1) default 't'
			constraint as_assessments_random_p_ck
			check (random_p in ('t','f'))
);
