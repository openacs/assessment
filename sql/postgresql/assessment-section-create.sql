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
				constraint as_section_display_types_item_alignment_ck
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
	definition	text,
	instructions	text,
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
			primary key
			constraint as_assessments_assessment_id_fk
			references cr_revisions(revision_id),
	creator_id integer,
	instructions	text,
	-- whether this is a standalone assessment (like current surveys), or if it provides an "assessment service" to another OpenACS app, or a "web service" via SOAP etc
	mode	varchar(25),
	editable_p	char(1) default 'f'
			constraint as_assessments_editable_p_ck
			check (editable_p in ('t','f')),
	anonymous_p	char(1) default 'f'
			constraint as_assessments_anonymous_p_ck
			check (anonymous_p in ('t','f')),
	secure_access_p	char(1) default 'f'
			constraint as_assessments_secure_access_p_ck
			check (secure_access_p in ('t','f')),		
	reuse_responses_p	char(1) default 'f'
			constraint as_assessments_reuse_responses_p_ck
			check (reuse_responses_p in ('t','f')),
	show_item_name_p	char(1) default 'f'
			constraint as_assessments_show_item_name_p_ck
			check (show_item_name_p in ('t','f')),
	-- The customizable entry page that will be displayed before the first response.
	entry_page varchar(50),
	-- Customizable exit / thank you page that will be displayed once the assessment has been responded.
	exit_page varchar(50),
	consent_page text,
	return_url varchar(50),
	start_time timestamptz,
	end_time timestamptz,
	number_tries integer,
	wait_between_tries integer,
	time_for_response integer,
	show_feedback varchar(50) default 'none'
			constraint as_assessments_show_feedback_ck
			check (show_feedback in ('none', 'all', 'incorrect', 'correct')),
	section_navigation varchar(50) default 'default path'
			constraint as_assessments_section_navigation_ck
			check (section_navigation in ('default path', 'randomized', 'rule-based branching'))
);

-- Style Options 
-- Each assessment has a special style associated with it. As styles can be reused.
create table as_assessment_styles (
       custom_header	varchar(500), 
       custom_footer	varchar(500), 
       form_template	varchar(500),
       progress_bar 	varchar(20) default 'no'       
			constraint as_assessment_styles_progress_bar_ck
			check (progress_bar in ('no','blue','red','green', 'yellow')),
       presentation_style 	varchar(20) default 'all'
       			constraint as_assessment_styles_presentation_style_ck
			check (presentation_style in ('all', 'one', 'sectioned')) 
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
	-- references CR
	content_value	integer
			constraint as_item_section_map_content_value_fk
                        references cr_revisions,
	numeric_value	integer,
	feedback_text	text,
	max_time_to_complete	integer,
	adp_chunk	varchar(25),
	sort_order	integer
);
