--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-10-25
--

create table as_files (
	file_id		integer
			constraint as_files_file_id_pk
                        primary key
			constraint as_files_file_id_fk
			references cr_revisions(revision_id)
);
