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
