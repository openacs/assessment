--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-10-25
--
-- Tables for saving files in content-repository

create table as_files (
	file_id		integer
			constraint as_files_file_id_pk
                        primary key
			constraint as_files_file_id_fk
			references cr_revisions(revision_id)
);

select content_type__create_type (
	'as_files',                    -- content_type
	'content_revision',                     -- super_type
	'Assessment File',                     -- pretty_name
	'Assessment Files',                    -- pretty_plural
	'as_files',                    -- table_name
	'file_id',                                     -- id_column
	null            -- name_method
);

create or replace function inline_0 ()
returns integer as'
declare
    template_id integer;
begin

    -- Create the (default) content type template

    template_id := content_template__new( 
      ''as_files_default'', -- name
      ''@text;noquote@'',               -- text
      true                      -- is_live
    );

    -- Register the template for the content type

    perform content_type__register_template(
      ''as_files'', -- content_type
      template_id,             -- template_id
      ''public'',              -- use_context
      ''t''                    -- is_default
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();
