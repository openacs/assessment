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


drop package as_inter_item_check;


declare begin
	acs_object_type.drop_type (object_type 	=>	'as_inter_item_checks');
end;
/
show errors;


drop table as_inter_item_checks;

