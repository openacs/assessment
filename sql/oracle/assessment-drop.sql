drop sequence action_log_id_seq;
drop table as_actions_log;
drop table as_param_map;
drop table as_action_params;
drop table as_action_map;
drop table as_actions;

drop package as_inter_item_check;

declare begin
	acs_object_type.drop_type (object_type => 'as_inter_item_check');
end;
/
show errors;

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
