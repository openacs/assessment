--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

create table as_items (
	as_item_id	integer
			constraint as_item_item_id_pk
                        primary key
			constraint as_item_item_id_fk
			references cr_revisions(revision_id),
        item_type_id    integer
			constraint as_item_item_type_id_fk
                        references as_item_types (item_type_id),
	item_display_type_id integer
			constraint as_item_item_display_type_id_fk
			references as_item_display_types (item_display_type_id),
	-- a secondary label, needed for many kinds of questions
	item_subtext	varchar(500),
	-- a short label for use in data output header rows, etc
	field_code	varchar(500),
	-- whether Item is released for actual use
	enabled_p	char(1) default 'f'
			constraint as_item_enabled_p_ck
			check (enabled_p in ('t','f')),
	-- whether Item must be answered (default value, can be overriden)
	required_p	char(1) default 'f'
			constraint as_item_required_p_ck
			check (required_p in ('t','f')),
	-- NOTE Is this correct?
	-- optional field that sets what the Item will display when first output (eg text in a textbox; eg the defaults that ad_dateentrywidget expects: "" for "no date", "0" for "today", or else some specific date set by the author; see  this example)
	item_default	varchar(500),
	-- optional max number of seconds to perform Item
	max_time_to_complete	integer,
	-- NOTE Is this correct?
	-- a denormalization to cache the generated "widget" for the Item (NB: when any change is made to an as_item_choice related to an as_item, this will have to be updated!)
	adp_chunk	varchar(500)
);

create table as_item_choices (
	choice_id       integer
                        constraint as_item_choice_id_pk
                        primary key
			constraint as_item_choice_id_fk
			references cr_revisions(revision_id),
	-- we can stuff both integers and real numbers here
        numeric_value   numeric,
	text_value	varchar(500),
	boolean_value	boolean,
	-- references an item in the CR -- for an image, audio file, or video file
	content_value	integer
			constraint as_item_choice_content_value_fk
                        references cr_revisions,
	-- where optionally some preset feedback can be specified by the author
	feedback_text	varchar(500),
	correct_answer_p	char(1) default 'f'
				constraint as_item_choice_correct_answer_p_ck
				check (correct_answer_p in ('t','f')),
	-- this is where points are stored
	percentage_value		integer
			constraint as_item_choice_value_ck
			check (value <= 100)
);

create table as_item_choice_map (
	as_item_id		integer
		constraint as_item_choice_map_item_id_fk
		references as_items (as_item_id),
	choice_id	integer
		constraint as_item_choice_map_choice_id_fk
		references as_item_choices (choice_id),
	sort_order	integer
);
