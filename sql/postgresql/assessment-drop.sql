drop table as_item_types_map;

drop table as_item_choices;
drop table as_item_attributes;
drop table as_item_localized;

drop table as_item_section_map;

drop table as_items;
drop table as_item_display_types;
drop table as_item_type_attributes;
drop table as_item_types;

drop table as_assessment_section_map;
drop table as_assessments;
drop table as_sections;
drop table as_section_display_types;
drop table as_param_map;
drop table as_action_params;
drop table as_actions_log;
drop table as_action_map;
drop table as_actions;

-- drop functions

drop function as_inter_item_check__new (integer,boolean,integer,integer,varchar,varchar,varchar,boolean,integer,integer,integer,integer);

drop function as_inter_item_check__delete (integer);

create function inline_0()
returns integer as '
declare
	object_rec	record;
begin 

	-- drop objects
 	for object_rec in select object_id from acs_objects where object_type = ''as_inter_item_check''
	loop
		PERFORM acs_object__delete ( object_rec.object_id );
	end loop;

	return 0;
end;' language 'plpgsql';

select inline_0();

drop function inline_0();

-- drop type

select acs_object_type__drop_type (
	'as_inter_item_check',
	't'
	);

drop table as_inter_item_checks;

