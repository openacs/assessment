--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

create table as_section_display_types (
	section_display_type_id	integer
				constraint as_section_display_types_id_pk
				primary key,
	section_type_name	varchar(25),
	pagination_style	varchar(25)
				constraint as_section_display_types_pagination_style_nn
				not null,
	branched_p		char(1) default 'f'
				constraint as_section_display_types_branched_p_ck
				check (branched_p in ('t','f')),
	item_orientation	varchar(25) default 'horizontal'
				constraint as_section_display_types_item_orientation_ck
				check (item_orientation in ('horizontal','vertical','matrix_col-row','matrix_row-col')),
	item_labels_as_headers_p char(1) default 't'
				 constraint as_section_display_types_item_labels_as_headers_p_ck
				 check (item_labels_as_headers_p in ('t','f')),
	-- May actually be superfluous
	presentation_type	varchar(25),
	item_aligment		varchar(25)
				constraint as_section_display_types_ck
				check (item_aligment in ('beside_left','beside_right','below','above')),
	display_options		varchar(25)
);

-- Represents logically-grouped set of items 
create table as_sections (
	section_id	integer
			constraint as_sections_section_id_pk
			primary key
			constraint as_sections_section_id_fk
			references cr_revisions(revision_id),
	section_display_type_id	integer
				constraint as_sections_section_display_type_id_fk
				references as_section_display_types (section_display_type_id),
	definition	text
			constraint as_sections_definition_nn
			not null,
	instructions	text,
	enabled_p	char(1) default 'f'
			constraint as_sections_enable_p_ck
			check (enable_p in ('t','f')), 
	-- Maybe this isnt really useful
	required_p	char(1) default 't'
			constraint as_sections_required_p_ck
			check (required_p in ('t','f')), 
	-- References an item in the CR
	content_value	integer,
	numeric_value	integer,
	feedback_text	text,
	max_time_to_complete	integer
);

-- Are the highest-level container in the hierarchical structure
-- They define the key by which all other entities are assembled into meaningful order during:
-- display, processing and retrieval of Assessment information
create table as_assessments (
	-- A revision_id inherited from cr_revisions
	assessment_id	integer
			constraint as_assessments_assessment_id_pk
			primary key,
	short_name	varchar(500),
	author	varchar(500),
	definition	text,
	instructions	text,
	scaled_p	char(1) default 'f'
			constraint as_assessments_scaled_p_ck
			check (scaled_p in ('t','f')),
	mode	varchar(25),
	validate_p	char(1) default 'f'
			constraint as_assessments_validate_p_ck
			check (validate_p in ('t','f')),
	enabled_p	char(1) default 'f'
			constraint as_assessments_enable_p_ck
			check (enable_p in ('t','f')),
	editable_p	char(1) default 'f'
			constraint as_assessments_editable_p_ck
			check (editable_p in ('t','f')),
	as_template	integer
);

create table as_assessment_section_map (
	assessment_id	integer
			constraint as_assessment_section_map_assessment_id_fk
			references as_assessments (assessment_id),
	section_id	integer
			constraint as_assessment_section_map_section_id_fk
			references as_sections (section_id),
	feedback_text	text,
	max_time_to_complete	integer,
	sort_order	integer
);

-- Defines the items of a section
create table as_item_section_map (
	as_item_id	integer
		constraint as_item_section_map_item_id_fk
		references as_items (as_item_id),
	section_id	integer
			constraint as_item_section_map_section_id_fk
			references as_sections (section_id),
	enabled_p	char(1) default 't'
			constraint as_item_section_map_enabled_p_ck
			check (enabled_p in ('t','f')),
	required_p	char(1) default 'f'
			constraint as_item_section_map_required_p_ck
			check (required_p in ('t','f')),
	item_default	integer,
	content_value	integer,
	numeric_value	integer,
	feedback_text	text,
	max_time_to_complete	integer,
	adp_chunk	varchar(25),
	sort_order	integer
);