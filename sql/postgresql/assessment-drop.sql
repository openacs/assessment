drop sequence as_actions_log_action_log_id;
drop table as_actions_log;
drop table as_param_map;
drop table as_action_params;
drop table as_action_map;
drop table as_actions;

-- drop functions

drop function as_inter_item_check__new (integer,boolean,integer,integer,varchar,varchar,varchar,boolean,integer,integer,integer,integer);

drop function as_inter_item_check__delete (integer);



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
	object_rec	record;
BEGIN 

	-- drop objects
 	for object_rec in select object_id from acs_objects where object_type = 'as_inter_item_check'
	loop
		PERFORM acs_object__delete ( object_rec.object_id );
	end loop;

	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();

-- drop type

select acs_object_type__drop_type (
	'as_inter_item_check',
	't'
	);

drop table as_inter_item_checks;

drop table as_item_rels;
drop table as_item_types_map;

drop table as_session_item_map;
drop table as_session_choices;
drop table as_session_items;
drop table as_session_sections;
drop table as_item_data_choices;
drop table as_item_data;
drop table as_section_data;
drop table as_sessions;

drop table as_item_section_map;
drop table as_assessment_section_map;
drop table as_assessment_styles;
drop table as_assessments;
drop table as_sections;
drop table as_section_display_types;

drop table as_item_help_map;
drop table as_messages;
drop table as_item_sa_answers;
drop table as_item_choices;
drop table as_items;

drop table as_item_display_ta;
drop table as_item_display_tb;
drop table as_item_display_sb;
drop table as_item_display_sa;
drop table as_item_display_cb;
drop table as_item_display_rb;
drop table as_item_type_sa;
drop table as_item_type_oq;
drop table as_item_type_mc;
