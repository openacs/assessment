alter table as_section_data add column creation_datetime timestamptz;
alter table as_section_data add column completed_datetime timestamptz;

alter table as_assessments add column ip_mask varchar(100);

alter table as_assessment_section_map add constraint as_assessment_section_map_pk primary key (assessment_id, section_id);
create unique index as_assessment_section_map_pk2 on as_assessment_section_map (section_id, assessment_id);
create index as_assessment_section_map_sort_order_idx on as_assessment_section_map (assessment_id, sort_order);

alter table as_item_section_map add constraint as_item_section_map_pk primary key (section_id, as_item_id);
create unique index as_item_section_map_pk2 on as_item_section_map (as_item_id, section_id);
create index as_item_section_map_sort_order_idx on as_item_section_map (section_id, sort_order);

create index as_item_choices_sort_order_idx on as_item_choices (mc_id, sort_order);

alter table as_item_types_map add constraint as_item_types_map_pk primary key (item_type, display_type);

create index as_sessions_assessment_id_idx on as_sessions (assessment_id);
create index as_sessions_subject_id_idx on as_sessions (subject_id);

create unique index as_section_data_pk2 on as_section_data (session_id, section_id);
create unique index as_section_data_pk3 on as_section_data (section_id, session_id);
create index as_section_data_subject_id_idx on as_section_data (subject_id);

create index as_item_data_pk2 on as_item_data (session_id, section_id, as_item_id);
create index as_item_data_pk3 on as_item_data (as_item_id, section_id, session_id);
create index as_item_data_subject_id_idx on as_item_data (subject_id);

create unique index as_item_data_choices_pk2 on as_item_data_choices (choice_id, item_data_id);

create unique index as_session_sections_pk2 on as_session_sections (section_id, session_id);

create unique index as_session_items_pk2 on as_session_items (as_item_id, section_id, session_id);

create unique index as_session_choices_pk2 on as_session_choices (choice_id, as_item_id, section_id, session_id);

create unique index as_session_item_map_pk2 on as_session_item_map (item_data_id, session_id);
