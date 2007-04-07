--
-- Assessment Package
--
-- @author nperper@it.uc3m.es
-- @creation-date 2004-08-05
--

-- Assessment Sessions: provides the central definition of a given subject's performance of an Assessment.
create table as_sessions (
	session_id integer
		constraint as_sessions_session_id_pk
		primary key
		constraint as_sessions_session_id_fk
		references cr_revisions(revision_id),
	assessment_id integer
		constraint as_sessions_assessment_id_fk
		references as_assessments(assessment_id),
	-- References a Subjects entity that we don't define in this package.
	-- if subjects can't be "persons" then Assessment will have to define an as_subjects table for its own use.
	subject_id integer
		constraint as_sessions_subject_id_fk
		references persons(person_id),
	-- references Users if someone is doing the Assessment as a proxy for the real subject
	staff_id integer
		constraint as_sessions_staff_id_fk
		references users(user_id),
	-- when the subject should do the Assessment
	target_datetime timestamptz,
	-- when the subject initiated the Assessment
	creation_datetime timestamptz,
	-- when the subject first sent something back in
	first_mod_datetime timestamptz,
	-- the most recent submission
	last_mod_datetime timestamptz,
	-- when the final submission produced a complete Assessment
	completed_datetime timestamptz,
	session_status varchar(20),
	assessment_status varchar(20),
	-- current percentage of the subject achieved so far
	percent_score integer
		constraint as_sessions_percent_score_ck
		check (percent_score <= 100)
);

create index as_sessions_assessment_id_idx on as_sessions (assessment_id);
create index as_sessions_subject_id_idx on as_sessions (subject_id);

--Assessment Section Data: tracks the state of each Section in the Assessment.
create table as_section_data (
	section_data_id integer
		constraint as_section_data_section_data_id_pk
		primary key
		constraint as_section_data_section_data_id_fk
		references cr_revisions(revision_id),
	session_id integer
		constraint as_section_data_session_id_fk
		references as_sessions(session_id),
	section_id integer
		constraint as_section_data_section_id_fk
		references as_sections(section_id),
-- if subjects can't be "persons" then Assessment will have to define an as_subjects table for its own use.
	subject_id integer
		constraint as_section_data_subject_id_fk
		references persons(person_id),
	staff_id integer
		constraint as_section_data_staff_id_fk
		references users(user_id),
	points integer,
	-- when the subject initiated the section
	creation_datetime timestamptz,
	-- when the final submission produced a complete section
	completed_datetime timestamptz
);

create unique index as_section_data_pk2 on as_section_data (session_id, section_id);
create unique index as_section_data_pk3 on as_section_data (section_id, session_id);
create index as_section_data_subject_id_idx on as_section_data (subject_id);

-- Assessment Item Data: is the "long skinny table" where all the primary data go
create table as_item_data (
	item_data_id integer
		constraint as_item_data_item_data_id_pk
		primary key
		constraint as_item_data_item_data_id_fk
		references cr_revisions(revision_id),
	session_id integer
		constraint as_item_data_session_id_fk
		references as_sessions(session_id),
	-- if subjects can't be "persons" then Assessment will have to define an as_subjects table for its own use
	subject_id integer
		constraint as_item_data_subject_id_fk
		references persons(person_id),
	-- missing foreign key
	staff_id integer
		constraint as_item_data_staff_id_fk
		references users(user_id),
 	as_item_id integer
		constraint as_item_data_item_id
		references as_items(as_item_id),
 	section_id integer
		constraint as_item_data_section_id
		references as_sections(section_id),
	is_unknown_p char(1) default 'f'
		constraint as_item_data_is_unknown_p_ck
		check (is_unknown_p in ('t','f')),
	boolean_answer boolean,
	clob_answer text,
	numeric_answer numeric,
	integer_answer integer,
	-- presumably can store both varchar and text datatypes 
	text_answer varchar(500),
	timestamp_answer timestamptz,
	-- references cr_revisions
	content_answer integer
		constraint as_item_data_content_answer_fk
		references cr_revisions,
	-- This field stores the signed entered data
	signed_data varchar(500),
	points integer,
	file_id integer
		constraint as_item_data_file_id_fk
		references cr_revisions(revision_id)
	-- to do: figure out how attachment answers should be supported; the Attachment package is still in need of considerable help. Can we rely on it here?
);

create index as_item_data_pk2 on as_item_data (session_id, section_id, as_item_id);
create index as_item_data_pk3 on as_item_data (as_item_id, section_id, session_id);
create index as_item_data_subject_id_idx on as_item_data (subject_id);
create index as_item_data_as_item_id_idx on as_item_data (as_item_id);

create table as_session_results (
       result_id   integer
                   constraint as_session_results_result_id_pk
                   primary key
                   constraint as_session_results_result_id_fk
                   references cr_revisions(revision_id),
       target_id   integer
                   constraint as_session_results_target_id_fk
                   references cr_revisions(revision_id),
       points      integer
);

create index as_session_results_target_idx on as_session_results (target_id);

-- here the selected choices are stored
create table as_item_data_choices (
	item_data_id	integer
			constraint as_item_data_choices_data_id_fk
			references as_item_data,
	-- references as_item_choices
	choice_id	integer
			constraint as_item_data_choices_choice_id_fk
			references as_item_choices,
	constraint as_item_data_choices_pk
	primary key (item_data_id, choice_id)
);

create unique index as_item_data_choices_pk2 on as_item_data_choices (choice_id, item_data_id);

-- here the order of the displayed sections is stored per session
create table as_session_sections (
	session_id	integer
			constraint as_session_sections_session_fk
			references as_sessions,
	section_id	integer
			constraint as_session_sections_section_fk
			references as_sections,
	sort_order	integer,
	constraint as_session_sections_pk
	primary key (session_id, section_id)
);

create unique index as_session_sections_pk2 on as_session_sections (section_id, session_id);

-- here the order of the displayed items is stored per session
create table as_session_items (
	session_id	integer
			constraint as_session_items_session_fk
			references as_sessions,
	section_id	integer
			constraint as_session_items_section_fk
			references as_sections,
	as_item_id	integer
			constraint as_session_items_item_fk
			references as_items,
	sort_order	integer,
	constraint as_session_items_pk
	primary key (session_id, section_id, as_item_id)
);

create unique index as_session_items_pk2 on as_session_items (as_item_id, section_id, session_id);

-- here the order of the displayed item choices is stored per session
create table as_session_choices (
	session_id	integer
			constraint as_session_choices_session_fk
			references as_sessions,
	section_id	integer
			constraint as_session_choices_section_fk
			references as_sections,
	as_item_id	integer
			constraint as_session_choices_item_fk
			references as_items,
	choice_id	integer
			constraint as_session_choices_choice_fk
			references as_item_choices,
	sort_order	integer,
	constraint as_session_choices_pk
	primary key (session_id, section_id, as_item_id, choice_id)
);

create unique index as_session_choices_pk2 on as_session_choices (choice_id, as_item_id, section_id, session_id);

-- here all references to answers of a session are stored
create table as_session_item_map (
	session_id	integer
			constraint as_session_item_map_session_fk
			references as_sessions on delete cascade,
	item_data_id	integer
			constraint as_session_item_map_item_data_fk
			references as_item_data on delete cascade,
	constraint as_session_item_map_pk
	primary key (session_id, item_data_id)
);

create unique index as_session_item_map_pk2 on as_session_item_map (item_data_id, session_id);
