create table as_item_types (
	item_type_id	integer
			constraint as_item_type_id_pk
			primary key,
	item_type_default_locale	varchar(30),
	item_type_name	varchar(500)
			constraint as_item_type_name_nn
			not null,
	item_type_description	varchar(500),
	-- This is the expected data_type of the answer
	data_type	varchar(25)
			constraint as_item_types_data_type_nn
			not null,
			constraint as_item_types_data_type_ck
			check (data_type in ('integer','numeric','varchar','text','date','boolean','timestamp','content_type',''))
);

create table as_item_type_attributes (
	attribute_id	integer
			constraint as_item_type_attribute_id_pk
			primary key,
	item_type_id	integer
			constraint as_item_type_attributes_item_type_id_fk
                        references as_item_types (item_type_id),
	attribute_name	varchar(500)
			constraint as_item_type_attributes_attribute_name_nn
			not null,
	-- NOTE Is this correct?
	-- type of the attribute (could be varchar, integer, cr_item)
	attribute_type	integer
			constraint as_item_type_attributes_attribute_type_nn
			not null,
	per_instance_p	char(1) default 'f'
			constraint as_item_type_attributes_per_instance_p_ck
			check (per_instance_p in ('t','f'))
);

create table as_item_display_types (
	item_display_type_id	integer
			constraint as_item_display_type_id_pk
			primary key,
	-- name like "Select box, aligned right"
	item_type_name	varchar(500)
			constraint as_item_display_types_type_name_nn
			not null,
	presentation_type	varchar(25)
			constraint as_item_display_types_presentation_type_nn
			not null,
			constraint as_item_display_types_presentation_type_ck
			check (presentation_type in ('textbox','textarea','radiobutton','checkbox','select','pop-up_date','typed_date','image_map','file_upload')),
	choice_orientation	varchar(25)
			constraint as_item_display_types_choice_orientation_nn
			not null,
			constraint as_item_display_types_choice_orientation_ck
			check (choice_orientation in ('horizontal','vertical','matrix_col-row','matrix_row-col')),
	item_choice_alignment	varchar(25)
			constraint as_item_display_types_item_choice_alignment_nn
			not null,
			constraint as_item_display_types_item_choice_alignment_ck
			check (item_choice_alignment in ('beside_left','beside_right','below','above')),
	-- field to specify other stuff like textarea dimensions ("rows=10 cols=50" eg)
	display_options	varchar(500)
);

create table as_items (
	-- NOTE should it be an acs_object? What about using CR?
	item_id		integer
			constraint as_item_item_id_pk
                        primary key,
        item_type_id    integer
			constraint as_item_item_type_id_fk
                        references as_item_types (item_type_id),
	item_display_type_id integer
			constraint as_item_item_display_type_id_fk
			references as_item_display_types (item_display_type_id),
	-- NOTE Is this correct?
	-- locale that is used for the item within this table (as_items). For additional locales, check as_item_locale
	default_locale	varchar(30),
	-- some phrase used in admin UIs
	name		varchar(500)
                        constraint as_item_name_nn
                        not null,
	-- the primary "label" attached to an Item's display
	item_text	varchar(500),
	-- a secondary label, needed for many kinds of questions
	item_subtext	varchar(500),
	-- a short label for use in data output header rows, etc
	field_code	varchar(500),
	-- some descriptive text
	definition	varchar(500),
	-- whether Item is shareable; defaults to 't' since this is the whole intent of this "repository" approach, but authors' should have option to prevent reuse
	shareable_p	char(1) default 't'
			constraint as_item_shareable_p_ck
			check (shareable_p in ('t','f')),
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

create table as_item_localized (
	item_id		integer
			constraint as_item_localized_item_id_fk
			references as_items (item_id),
	locale		varchar(30)
			constraint as_item_localized_locale_nn
                        not null,
	-- the primary "label" attached to an Item's display
	item_text	varchar(500),
	-- a secondary label, needed for many kinds of questions
	item_subtext	varchar(500),
	-- some descriptive text
	definition	varchar(500),
	-- optional text displayed on user pages
	instructions	varchar(500)
);

create table as_item_attributes (
	item_id		integer
			constraint as_item_attributes_item_id_fk
                        references as_items (item_id),
	attribute_id	integer
			constraint as_item_attributes_attribute_id_fk
                        references as_item_type_attributes (attribute_id),
	-- NOTE Is this correct?
	-- which of the value columns has the information this Choice conveys
	data_type	integer,
	-- we can stuff both integers and real numbers here - this is where "points" could be stored for each Choice
        numeric_value   numeric,
	text_value	varchar(500),
	boolean_value	boolean,
	-- references an item in the CR -- for an image, audio file, or video file
	content_value	integer
			constraint as_item_choice_content_value_fk
                        references cr_revisions
);

create table as_item_choices (
	choice_id       integer
                        constraint as_item_choice_id_pk
                        primary key,
        name            varchar(500),
	-- what is displayed in the choice's "label"
        choice_text     varchar(500),
	-- NOTE Is this correct?
	-- which of the value columns has the information this Choice conveys
	data_type	integer,
	-- we can stuff both integers and real numbers here - this is where "points" could be stored for each Choice
        -- might be useful for averaging or whatever, generally null
        numeric_value   numeric,
	text_value	varchar(500),
	boolean_value	boolean,
	-- references an item in the CR -- for an image, audio file, or video file
	content_value	integer
			constraint as_item_choice_content_value_fk
                        references cr_revisions,
	-- whether Choice is shareable; defaults to 't' since this is the whole intent of this "repository" approach, but authors' should have option to prevent reuse
	shareable_p	char(1) default 't'
			constraint as_item_choice_shareable_p_ck
			check (shareable_p in ('t','f')),
	-- where optionally some preset feedback can be specified by the author
	feedback_text	varchar(500)
);

create table as_item_choice_map (
	item_id		integer
		constraint as_item_choice_map_item_id_fk
		references as_items (item_id),
	choice_id	integer
		constraint as_item_choice_map_choice_id_fk
		references as_item_choices (choice_id),
	sort_order	integer
);
