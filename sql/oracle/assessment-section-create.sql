--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

--Section Display Types: define types of display for an groups of Items.
create table as_section_display_types (
	section_display_type_id	integer
				constraint as_section_display_types_id_pk
				primary key,
	-- name
	section_type_name	varchar(25),
	-- all-items; one-item-per-page; variable (get item groups from mapping table)
	pagination_style	varchar(25)
				constraint as_section_disptyp_pagin_nn
				not null,
	-- whether this Section defines a branch point or whether this Section simply transitions to the next Section
	branched_p		char(1) default 'f'
				constraint as_section_disptyp_bra_p_ck
				check (branched_p in ('t','f')),
	-- the pattern by which 2..n Items are laid out when displayed (horizontal, vertical, matrix_col-row, matrix_row-col)
	item_orientation	varchar(25) default 'horizontal'
				constraint as_section_disptyp_orient_ck
				check (item_orientation in ('horizontal','vertical','matrix_col-row','matrix_row-col')),
	-- whether to display labels of the Items
	item_labels_as_headers_p char(1) default 't'
				 constraint as_section_disptyp_labels_p_ck
				 check (item_labels_as_headers_p in ('t','f')),
	-- May actually be superfluous
	presentation_type	varchar(25),
	-- the orientation between the "section description part" of the Section and the group of Items (beside-left, beside-right, bellow, above)
	item_aligment		varchar(25)
				constraint as_section_disptyp_align_ck
				check (item_aligment in ('beside_left','beside_right','below','above')),
	-- other stuff like the grid dimensions
	display_options		varchar(25)
);

-- Sections: represents logically-grouped set of items 
create table as_sections (
	section_id	integer
			constraint as_sections_section_id_pk
			primary key
			constraint as_sections_section_id_fk
			references cr_revisions(revision_id),
	section_display_type_id	integer
				constraint as_sections_display_type_id_fk
				references as_section_display_types (section_display_type_id),
	-- text used for identification and selection in admin pages, not for end-user pages
	definition	clob,
	-- text displayed on user pages
	instructions	clob,
	-- Maybe this isnt really useful
	required_p	char(1) default 't'
			constraint as_sections_required_p_ck
			check (required_p in ('t','f')), 
	-- References an item in the CR (for an image, audio file or video file)
	content_value	integer,
	-- number of points for section
	numeric_value	integer,
	-- preset text to show user
	feedback_text	clob,
	-- max number of seconds to perform Section
	max_time_to_complete	integer
);

-- Are the highest-level container in the hierarchical structure
-- They define the key by which all other entities are assembled into meaningful order during:
-- display, processing and retrieval of Assessment information
create table as_assessments (
	-- A revision_id inherited from cr_revisions
	assessment_id	integer
			constraint as_assessments_id_pk
			primary key
			constraint as_assessments_id_fk
			references cr_revisions(revision_id),
	-- who is the "main" author and creator of this assessment
	creator_id integer,
	-- text that explains any specific steps the subject needs to follow
	instructions	clob,
	-- whether this is a standalone assessment (like current surveys), or if it provides an "assessment service" to another OpenACS app, or a "web service" via SOAP, etc
	run_mode	varchar(25),
	-- whether the creator of the assessment will have the possibility to see the personal details of the respondee or not 
	anonymous_p	char(1) default 'f'
			constraint as_assessments_anonym_p_ck
			check (anonymous_p in ('t','f')),
	-- whether the assessment can only be taken if a secure connection (https) is used
	secure_access_p	char(1) default 'f'
			constraint as_assessments_secure_p_ck
			check (secure_access_p in ('t','f')),
	-- whether an assessment can reuse responses		
	reuse_responses_p	char(1) default 'f'
			constraint as_assessments_reuse_p_ck
			check (reuse_responses_p in ('t','f')),
	-- whether the name of the item is shown
	show_item_name_p	char(1) default 'f'
			constraint as_assessments_name_p_ck
			check (show_item_name_p in ('t','f')),
	-- the customizable entry page that will be displayed before the first response.
	entry_page	varchar(50),
	-- customizable exit / thank you page that will be displayed once the assessment has been responded.
	exit_page	varchar(50),
	consent_page	clob,
	-- URL the respondee will be redirected to after finishing the assessment
	return_url varchar(50),
	-- at what time shall the assessment become available to the users 
	start_time	date,
	-- at what time the assessment becomes unavailable
	end_time	date,
	-- number of times a respondee can answer the assessment
	number_tries integer,
	-- number of minutes a respondee has to wait before he can retake the assessment
	wait_between_tries integer,
	-- how many minutes has the respondee to finish the assessment
	time_for_response integer,
	-- the feedback type which will be displayed to the respondee (all, none, correct, incorrect)
	show_feedback varchar(50) default 'none'
			constraint as_assessments_feedback_ck
			check (show_feedback in ('none', 'all', 'incorrect', 'correct')),
	-- how shall the navigation happen (default path, randomized, rule-based branching)
	section_navigation varchar(50) default 'default path'
			constraint as_assessments_navigation_ck
			check (section_navigation in ('default path', 'randomized', 'rule-based branching')),
	-- differenciate between an assessment and a survey
	survey_p 	char(1) default 'f'
			constraint as_assessments_survey_p_ck
			check (survey_p in ('t', 'f'))
);

-- Style Options 
-- Each assessment has a special style associated with it. As styles can be reused.
create table as_assessment_styles (
       -- custom header that will be displayed to the respondee when answering an assessment. 
       custom_header	varchar(500), 
       -- custom footer that will be displayed to the respondee when answering an assessment.
       custom_footer	varchar(500), 
       -- style (form_template) that will be used for this assesment. 
       form_template	varchar(500),
       -- what kind of progress bar shall be displayed to the respondee while taking the assessment
       progress_bar 	varchar(20) default 'no'       
			constraint as_assessment_styl_progress_ck
			check (progress_bar in ('no','blue','red','green', 'yellow')),
       -- select a presentation style (all question at once, one question per page, sectioned)
       presentation_style 	varchar(20) default 'all'
       			constraint as_assessment_styl_present_ck
			check (presentation_style in ('all', 'one', 'sectioned')) 
);

-- Section Assessment Map: defines the sections of an assessment
create table as_assessment_section_map (
	assessment_id	integer
			constraint as_assessment_smap_a_id_fk
			references as_assessments (assessment_id),
	section_id	integer
			constraint as_assessment_smap_s_id_fk
			references as_sections (section_id),
	-- feedback
	feedback_text	clob,
	-- maximum time to complete a section
	max_time_to_complete	integer,
	-- order in which a section will be displayed
	sort_order	integer
);

-- Item Section Map: defines the items of a section
create table as_item_section_map (
	as_item_id	integer
		constraint as_item_smap_i_id_fk
		references as_items (as_item_id),
	section_id	integer
			constraint as_item_smap_s_id_fk
			references as_sections (section_id),
	enabled_p	char(1) default 't'
			constraint as_item_smap_enabled_p_ck
			check (enabled_p in ('t','f')),
	-- whether Item must be answered
	required_p	char(1) default 'f'
			constraint as_item_smap_required_p_ck
			check (required_p in ('t','f')),
	item_default	integer,
	-- references CR
	content_value	integer
			constraint as_item_smap_content_fk
                        references cr_revisions,
	-- points for the item
	numeric_value	integer,
	-- feedback for the item
	feedback_text	clob,
	-- maximum time to answer the item
	max_time_to_complete	integer,
	-- display code
	adp_chunk	varchar(25),
	-- order in which items appear in a section
	sort_order	integer
);
