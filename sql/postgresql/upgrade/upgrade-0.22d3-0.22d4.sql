alter table as_item_rels drop constraint as_item_rels_item_fk;
alter table as_item_rels drop constraint as_item_rels_target_fk;
alter table as_item_rels add constraint as_item_rels_item_fk foreign key (item_rev_id) references acs_objects(object_id) on delete cascade;
alter table as_item_rels add constraint as_item_rels_target_fk foreign key (target_rev_id) references acs_objects(object_id) on delete cascade;

alter table as_item_section_map drop constraint as_item_section_map_item_id_fk;
alter table as_item_section_map drop constraint as_item_section_map_section_id_fk;
alter table as_item_section_map add constraint as_item_section_map_item_id_fk foreign key (as_item_id) references as_items(as_item_id) on delete cascade;
alter table as_item_section_map add constraint as_item_section_map_section_id_fk foreign key (section_id) references as_sections(section_id) on delete cascade;

alter table as_item_choices drop constraint as_item_choices_content_value_fk;
alter table as_item_choices drop constraint as_item_choices_id_fk;
alter table as_item_choices drop constraint as_item_choices_parent_id_fk;
alter table as_item_choices add constraint as_item_choices_content_value_fk foreign key (content_value) references cr_revisions(revision_id) on delete cascade;
alter table as_item_choices add constraint as_item_choices_id_fk foreign key (choice_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_choices add constraint as_item_choices_parent_id_fk foreign key (mc_id) references as_item_type_mc(as_item_type_id) on delete cascade;

alter table as_item_sa_answers drop constraint as_item_sa_answers_id_fk;
alter table as_item_sa_answers drop constraint as_item_sa_answers_parent_id_fk;
alter table as_item_sa_answers add constraint as_item_sa_answers_id_fk foreign key (choice_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_sa_answers add constraint as_item_sa_answers_parent_id_fk foreign key (answer_id) references as_item_type_sa(as_item_type_id) on delete cascade;

alter table as_item_help_map drop constraint as_item_help_map_as_item_id_fk;
alter table as_item_help_map drop constraint as_item_help_map_message_id_fk;
alter table as_item_help_map add constraint as_item_help_map_as_item_id_fk foreign key (as_item_id) references as_items(as_item_id) on delete cascade;
alter table as_item_help_map add constraint as_item_help_map_message_id_fk foreign key (message_id) references as_messages(message_id) on delete cascade;

alter table as_sections drop constraint as_sections_display_type_id_fk;
alter table as_sections drop constraint as_sections_section_id_fk;
alter table as_sections add constraint  as_sections_display_type_id_fk foreign key (display_type_id) references as_section_display_types(display_type_id) on delete cascade;
alter table as_sections add constraint as_sections_section_id_fk foreign key (section_id) references cr_revisions(revision_id) on delete cascade;

alter table as_sessions drop constraint as_sessions_assessment_id_fk;
alter table as_sessions drop constraint as_sessions_session_id_fk;
alter table as_sessions drop constraint as_sessions_staff_id_fk;
alter table as_sessions drop constraint as_sessions_subject_id_fk;
alter table as_sessions add constraint as_sessions_assessment_id_fk foreign key (assessment_id) references as_assessments(assessment_id) on delete cascade;
alter table as_sessions add constraint as_sessions_session_id_fk foreign key (session_id) references cr_revisions(revision_id) on delete cascade;
alter table as_sessions add constraint as_sessions_staff_id_fk foreign key (staff_id) references users(user_id) on delete cascade;
alter table as_sessions add constraint as_sessions_subject_id_fk foreign key (subject_id) references persons(person_id) on delete cascade;

alter table as_section_data drop constraint as_section_data_section_data_id_fk;
alter table as_section_data add constraint as_section_data_section_data_id_fk foreign key (section_data_id) references cr_revisions(revision_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_section_id_fk;
alter table as_section_data add constraint as_section_data_section_id_fk foreign key (section_id) references as_sections(section_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_session_id_fk;
alter table as_section_data add constraint as_section_data_session_id_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_staff_id_fk;
alter table as_section_data add constraint as_section_data_staff_id_fk foreign key (staff_id) references users(user_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_subject_id_fk;
alter table as_section_data add constraint as_section_data_subject_id_fk foreign key (subject_id) references persons(person_id) on delete cascade;

alter table as_item_type_mc drop constraint as_item_type_mc_as_item_type_id_fk;
alter table as_item_type_mc add constraint as_item_type_mc_as_item_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_type_oq drop constraint as_item_type_oq_as_item_type_id_fk;
alter table as_item_type_oq add constraint as_item_type_oq_as_item_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_rb drop constraint as_item_display_rb_as_item_display_id_fk;
alter table as_item_display_rb add constraint as_item_display_rb_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_cb drop constraint as_item_display_cb_as_item_display_id_fk;
alter table as_item_display_cb add constraint as_item_display_cb_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_sb drop constraint as_item_display_sb_as_item_display_id_fk;
alter table as_item_display_sb add constraint as_item_display_sb_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_tb drop constraint as_item_display_tb_as_item_display_id_fk;
alter table as_item_display_tb add constraint as_item_display_tb_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_sa drop constraint as_item_display_sa_as_item_display_id_fk;
alter table as_item_display_sa add constraint as_item_display_sa_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_type_sa drop constraint as_item_type_sa_as_item_type_id_fk;
alter table as_item_type_sa add constraint as_item_type_sa_as_item_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_ta drop constraint as_item_display_ta_as_item_display_id_fk;
alter table as_item_display_ta add constraint as_item_display_ta_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_type_fu drop constraint as_item_type_fu_as_item_type_id_fk;
alter table as_item_type_fu add constraint as_item_type_fu_as_item_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_f drop constraint as_item_display_f_as_item_display_id_fk;
alter table as_item_display_f add constraint as_item_display_f_as_item_display_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_items drop constraint as_items_item_id_fk;
alter table as_items add constraint as_items_item_id_fk foreign key (as_item_id) references cr_revisions(revision_id) on delete cascade;
alter table as_section_display_types drop constraint as_section_display_types_id_fk;
alter table as_section_display_types add constraint as_section_display_types_id_fk foreign key (display_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_assessments drop constraint as_assessments_assessment_id_fk;
alter table as_assessments add constraint as_assessments_assessment_id_fk foreign key (assessment_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_content_answer_fk;
alter table as_item_data add constraint as_item_data_content_answer_fk foreign key (content_answer) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_file_id_fk;
alter table as_item_data add constraint as_item_data_file_id_fk foreign key (file_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_item_data_id_fk;
alter table as_item_data add constraint as_item_data_item_data_id_fk foreign key (item_data_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_item_id;
alter table as_item_data add constraint as_item_data_item_id foreign key (as_item_id) references as_items(as_item_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_section_id;
alter table as_item_data add constraint as_item_data_section_id foreign key (section_id) references as_sections(section_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_session_id_fk;
alter table as_item_data add constraint as_item_data_session_id_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_staff_id_fk;
alter table as_item_data add constraint as_item_data_staff_id_fk foreign key (staff_id) references users(user_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_subject_id_fk;
alter table as_item_data add constraint as_item_data_subject_id_fk foreign key (subject_id) references persons(person_id) on delete cascade;

drop function as_action__delete(integer);

select define_function_args ('as_action__del','action_id');



--
-- procedure as_action__del/1
--
CREATE OR REPLACE FUNCTION as_action__del(
   del__action_id integer
) RETURNS integer AS $$
DECLARE 
BEGIN
        
                
        delete from as_action_params where action_id=del__action_id;
        
        delete from as_actions where action_id = del__action_id;

        PERFORM acs_object__delete (del__action_id);    
        return del__action_id;  

END;
$$ LANGUAGE plpgsql;       

alter table as_session_items drop constraint as_session_items_item_fk;
alter table as_session_items drop constraint as_session_items_section_fk;
alter table as_session_items drop constraint as_session_items_session_fk;
alter table as_session_items add constraint "as_session_items_item_fk" FOREIGN KEY (as_item_id) REFERENCES as_items(as_item_id) on delete cascade;
alter table as_session_items add constraint "as_session_items_section_fk" FOREIGN KEY (section_id) REFERENCES as_sections(section_id) on delete cascade;
alter table as_session_items add constraint "as_session_items_session_fk" FOREIGN KEY (session_id) REFERENCES as_sessions(session_id) on delete cascade;
