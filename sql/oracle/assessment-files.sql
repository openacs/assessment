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

declare
begin
  content_type.create_type (
	content_type => 'as_files',
	super_type => 'content_revision',
	pretty_name => 'Assessment File',
	pretty_plural => 'Assessment Files',
	table_name => 'as_files',
	id_column => 'file_id',
	name_method => null
  );
end;
/

declare
  v_template_id integer;
begin
  -- Create the (default) content type template

  v_template_id := content_template.new ( 
      name => 'as_files_default',
      text => '@text;noquote@',
      is_live => 't'
  );

  -- Register the template for the content type

  content_type__register_template(
      content_type => 'as_files',
      template_id => v_template_id,
      use_context => 'public',
      is_default => 't'
  );
end;
/
