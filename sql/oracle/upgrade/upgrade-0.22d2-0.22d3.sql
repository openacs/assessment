alter table as_session_sections drop constraint as_sess_sect_section_fk;

alter table as_session_sections drop constraint as_sess_sect_session_fk;

alter table as_session_sections add constraint as_sess_sect_section_fk foreign key (section_id) references as_sections(section_id) on delete cascade;

alter table as_session_sections add constraint as_sess_sect_session_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;

alter table as_session_items drop constraint as_sess_items_item_fk;

alter table as_session_items drop constraint as_sess_items_section_fk;

alter table as_session_items drop constraint as_sess_items_session_fk;

alter table as_session_items add constraint as_sess_items_item_fk foreign key (as_item_id) references as_items(as_item_id) on delete cascade;

alter table as_session_items add constraint as_sess_items_section_fk foreign key (section_id) references as_sections(section_id) on delete cascade;

alter table as_session_items add constraint as_sess_items_session_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;

alter table as_session_item_map drop constraint as_sess_imap_item_data_fk;

alter table as_session_item_map drop constraint as_sess_imap_session_fk;

alter table as_session_item_map add constraint as_sess_imap_item_data_fk foreign key (item_data_id) references as_item_data(item_data_id) on delete cascade;

alter table as_session_item_map add constraint as_sess_imap_session_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;

alter table as_item_data_choices drop constraint as_idata_cho_choice_id_fk;

alter table as_item_data_choices drop constraint as_idata_cho_data_id_fk;

alter table as_item_data_choices add constraint as_idata_cho_choice_id_fk foreign key (choice_id) references as_item_choices(choice_id) on delete cascade;

alter table as_item_data_choices add constraint as_idata_cho_data_id_fk foreign key (item_data_id) references as_item_data(item_data_id) on delete cascade;

alter table as_session_choices drop constraint as_sess_cho_choice_fk;

alter table as_session_choices drop constraint as_sess_cho_item_fk;

alter table as_session_choices drop constraint as_sess_cho_section_fk;

alter table as_session_choices drop constraint as_sess_cho_session_fk;

alter table as_session_choices add constraint as_sess_cho_choice_fk FOREIGN KEY (choice_id) REFERENCES as_item_choices(choice_id) on delete cascade;

alter table as_session_choices add constraint as_sess_cho_item_fk FOREIGN KEY (as_item_id) REFERENCES as_items(as_item_id) on delete cascade;

alter table as_session_choices add constraint as_sess_cho_section_fk FOREIGN KEY (section_id) REFERENCES as_sections(section_id) on delete cascade;

alter table as_session_choices add constraint as_sess_cho_session_fk FOREIGN KEY (session_id) REFERENCES as_sessions(session_id) on delete cascade;


alter table as_assessment_section_map drop constraint as_assessment_smap_a_id_fk;
alter table as_assessment_section_map drop constraint as_assessment_smap_s_id_fk;

alter table as_assessment_section_map add constraint as_assessment_smap_a_id_fk FOREIGN KEY (assessment_id) REFERENCES as_assessments(assessment_id) ON DELETE CASCADE;
alter table as_assessment_section_map add constraint as_assessment_smap_s_id_fk FOREIGN KEY (section_id) REFERENCES as_sections(section_id) ON DELETE CASCADE;
alter table as_session_results drop constraint as_sess_res_res_id_fk;
alter table as_session_results add constraint as_sess_res_res_id_fk FOREIGN KEY (result_id) REFERENCES cr_revisions(revision_id) on delete cascade;
alter table as_session_results drop constraint as_sess_res_tgt_id_fk;
alter table as_session_results add constraint as_sess_res_tgt_id_fk FOREIGN KEY (target_id) REFERENCES cr_revisions(revision_id) on delete cascade;