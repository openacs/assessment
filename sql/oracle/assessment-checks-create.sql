-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06

begin 
	-- create the inter_item_check object
        acs_object_type.create_type (
		supertype	=>	'acs_object',
		object_type 	=>	'as_inter_item_check',
		pretty_name	=>	'As_Inter_item_check',
		pretty_plural	=>	'As_Inter_item_checks',
		table_name	=>	'as_inter_items_checks',
		id_column	=>	'inter_item_check_id'
);
end;
/
show errors;

declare 

	attr_id acs_attributes.attribute_id%TYPE;

begin
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'name',
		pretty_name	=>	'Name',
		pretty_plural	=>	'Names',
		datatype	=>	'string'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'action_p',
		pretty_name	=>	'Action_p',
		pretty_plural	=>	'Action_p',
		datatype	=>	'string'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'section_id_from',
		pretty_name	=>	'From',
		pretty_plural	=>	'from',
		datatype	=>	'integer'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'section_id_to',
		pretty_name	=>	'To',
		pretty_plural	=>	'to',
		datatype	=>	'integer'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'check_sql',
		pretty_name	=>	'check_sql',
		pretty_plural	=>	'check_sql',
		datatype	=>	'string'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'description',
		pretty_name	=>	'Description',
		pretty_plural	=>	'descriptions',
		datatype	=>	'string'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'postcheck_p',
		pretty_name	=>	'postcheck_p',
		pretty_plural	=>	'postcheck_p',
		datatype	=>	'string'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'item_id',
		pretty_name	=>	'item_id',
		pretty_plural	=>	'item_id',
		datatype	=>	'integer'
	);
	attr_id := acs_attribute.create_attribute (
		object_type	=> 	'as_inter_item_check',
		attribute_name 	=>	'assessment_id',
		pretty_name	=>	'assessment_id',
		pretty_plural	=>	'assessment_id',
		datatype	=>	'integer'
	);

end;
/
show errors;

 
----------------------------------------------------------
--	table as_inter_item_checks
----------------------------------------------------------

create table as_inter_item_checks (
	inter_item_check_id	integer
				constraint as_inter_item_checks_id_fk
				references acs_objects(object_id)
				on delete cascade
				constraint as_inter_item_checks_pk
				primary key,
	action_p		varchar(1) not null,
	section_id_from		integer not null,
	section_id_to		integer,
	check_sql		varchar(4000)
				constraint as_inter_item_checks_nn not null,
	name			varchar(200),
	description		varchar(200),
	postcheck_p		varchar(1) not null,
	item_id			integer,
	assessment_id		integer
);




	
	