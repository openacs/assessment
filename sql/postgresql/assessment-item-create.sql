--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

create table as_items (
	as_item_id	integer
			constraint as_items_item_id_pk
                        primary key
			constraint as_items_item_id_fk
			references cr_revisions(revision_id),
	-- a secondary label, needed for many kinds of questions
	subtext	varchar(500),
	-- a short label for use in data output header rows, etc
	field_code	varchar(500),
	-- some descriptive text
	definition text,
	-- whether Item must be answered (default value, can be overriden)
	required_p	char(1) default 'f'
			constraint as_items_required_p_ck
			check (required_p in ('t','f')),
	data_type	varchar(50),
	-- optional max number of seconds to perform Item
	max_time_to_complete	integer,
	-- a denormalization to cache the generated "widget" for the Item (NB: when any change is made to an as_item_choice related to an as_item, this will have to be updated!)
	adp_chunk	varchar(500),
	-- feedback 
	feedback_text text
);

create table as_item_choices (
	choice_id       integer
                        constraint as_item_choices_id_pk
                        primary key
			constraint as_item_choices_id_fk
			references cr_revisions(revision_id),
	mc_id		integer
			constraint as_item_choices_parent_id_fk
			references as_item_type_mc(as_item_type_id),
	data_type	varchar(20),
	-- we can stuff both integers and real numbers here
        numeric_value   numeric,
	text_value	varchar(500),
	boolean_value	boolean,
	-- references an item in the CR -- for an image, audio file, or video file
	content_value	integer
			constraint as_item_choices_content_value_fk
                        references cr_revisions,
	-- where optionally some preset feedback can be specified by the author
	feedback_text	varchar(500),	
	selected_p	char(1) default 'f'
			constraint as_item_choices_selected_p_ck
			check (selected_p in ('t','f')),
	correct_answer_p	char(1) default 'f'
			constraint as_item_choices_correct_answer_ck
			check (correct_answer_p in ('t','f')),
	sort_order	integer,
	-- this is where points are stored
	percent_score		integer
			constraint as_item_choices_percent_score_ck
			check (percent_score <= 100)	
);

create table as_messages (
	message_id	integer
			constraint as_messages_message_id_pk
			primary key,
	message		varchar(500)
);

create table as_item_help_map (
	as_item_id		integer
		constraint as_item_help_map_as_item_id_fk
		references as_items (as_item_id),
	message_id	integer
		constraint as_item_help_map_message_id_fk
		references as_messages (message_id),
	sort_order	integer
);
