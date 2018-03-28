--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

-- Multiple Choice Item 
create table as_item_type_mc (
	as_item_type_id		integer
				constraint as_item_type_mc_type_id_pk
				primary key
				constraint as_item_type_mc_type_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- (number of correct matches / number of total matches) *100% points. All or nothing will either give 100%, if all correct answers are given, or 0% else.
	increasing_p		char(1) default 'f'
				constraint as_item_type_mc_incr_p_ck
				check (increasing_p in ('t','f')),
	-- if a negative percentage is allowed
	allow_negative_p	char(1) default 'f'
				constraint as_item_type_mc_neg_p_ck
				check (allow_negative_p in ('t','f')),
	-- number of correct options 
	num_correct_answers	integer,
	-- number of options to be displayed in total (correct and incorrect)
	num_answers		integer
);

-- Open Question Item
create table as_item_type_oq (
	as_item_type_id		integer
				constraint as_item_type_oq_type_id_pk
				primary key
				constraint as_item_type_oq_type_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- the content of this field will be prefilled in the response of the user taking the survey
	default_value		varchar(500),
	-- the person correcting the answers will see the contents of this box as correct answer for comparison with the user response
	feedback_text    	varchar(500),
	-- reference text with the expected perfect answer
	reference_answer	clob,
	-- keyword list for automatic pre-grading
	keywords		varchar(4000)
);

-- Radiobutton display type
create table as_item_display_rb (
	as_item_display_id	integer
				constraint as_item_display_rb_displ_id_pk
				primary key
				constraint as_item_display_rb_displ_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- field to specify other stuff like textarea dimensions 
	html_display_options	varchar(50),
	-- the pattern by which 2..n Item Choices are laid out when displayed (horizontal, vertical) 
	choice_orientation	varchar(20),
	-- how shall the label be positioned in relation to the choice (top, left, right, buttom).
	choice_label_orientation varchar(20),
	-- order in which the choices will appear (numerical, alphabetic, randomized or by order of entry)
	sort_order_type		varchar(20),
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
	item_answer_alignment	varchar(20)
);

-- Checkbox Display Type
create table as_item_display_cb (
	as_item_display_id	integer
				constraint as_item_display_cb_displ_id_pk
				primary key
				constraint as_item_display_cb_displ_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- field to specify other stuff like textarea dimensions 
	html_display_options	varchar(50),
	-- the pattern by which 2..n Item Choices are laid out when displayed (horizontal, vertical) 
	choice_orientation	varchar(20),
	-- how shall the label be positioned in relation to the choice (top, left, right, buttom).
	choice_label_orientation varchar(20),
	-- order in which the choices will appear (numerical, alphabetic, randomized or by order of entry)
	sort_order_type		varchar(20),
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
	item_answer_alignment	varchar(20)
);

-- Selectbox Display Type
create table as_item_display_sb (
	as_item_display_id	integer
				constraint as_item_display_sb_displ_id_pk
				primary key
				constraint as_item_display_sb_displ_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- field to specify other stuff like textarea dimensions 
	html_display_options	varchar(50),
	-- if multiple answers are allowed
	multiple_p		char(1) default 'f'
				constraint as_item_type_sb_multiple_p_ck
				check (multiple_p in ('t','f')),
	-- how shall the label be positioned in relation to the choice (top, left, right, buttom).
	choice_label_orientation varchar(20),
	-- order in which the choices will appear (numerical, alphabetic, randomized or by order of entry)
	sort_order_type		varchar(20),
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
	item_answer_alignment	varchar(20),
	-- prepend an empty item to the list, useful for validation of a required sb but you don't want any option as selected by default
	prepend_empty_p		char(1) default 'f'
);

-- Textbox Display Type
create table as_item_display_tb (
	as_item_display_id	integer
				constraint as_item_display_tb_displ_id_pk
				primary key
				constraint as_item_display_tb_displ_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- field to specify other stuff like textarea dimensions
	html_display_options	varchar(50),
	-- an abstraction of the real size value in "small","medium","large" 
	abs_size		varchar(10),
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
	item_answer_alignment	varchar(20)
);

-- ShortAnswer Display Type: multiple textboxes in one item.
create table as_item_display_sa (
	as_item_display_id	integer
				constraint as_item_display_sa_displ_id_pk
				primary key
				constraint as_item_display_sa_displ_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- field to specify other stuff like textarea dimensions
	html_display_options	varchar(50),
	-- an abstraction of the real size value in "small","medium","large"
	abs_size		varchar(10),
	-- the pattern by which 2..n answer boxes are laid out when displayed (horizontal, vertical)
	box_orientation		varchar(10)
);

-- Short Answer Item
create table as_item_type_sa (
	as_item_type_id		integer
				constraint as_item_type_sa_type_id_pk
				primary key
				constraint as_item_type_sa_type_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- (number of correct matches / number of total matches) *100% points. All or nothing will either give 100%, if all correct answers are given, or 0% else.
	increasing_p		char(1) default 'f'
				constraint as_item_type_sa_incr_p_ck
				check (increasing_p in ('t','f')),
	-- if a negative percentage is allowed
	allow_negative_p	char(1) default 'f'
				constraint as_item_type_sa_neg_p_ck
				check (allow_negative_p in ('t','f'))	
);

-- Textarea Display Type: multiple-line typed entry
create table as_item_display_ta (
	as_item_display_id	integer
				constraint as_item_display_ta_displ_id_pk
				primary key
				constraint as_item_display_ta_displ_id_fk
				references cr_revisions(revision_id)
                                on delete cascade,
	-- field to specify other stuff like textarea dimensions
	html_display_options	varchar(50),
	-- an abstraction of the real size value in "small","medium","large"
	abs_size		varchar(20),
	-- the type of "widget" displayed when the Item is output in html. 
	acs_widget 		varchar(20),	
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
	item_answer_alignment	varchar(20)
);


-- File Upload Item
create table as_item_type_fu (
	as_item_type_id		integer
				constraint as_item_type_fu_type_id_pk
				primary key
				constraint as_item_type_fu_type_id_fk
				references cr_revisions(revision_id)
                on delete cascade
);

-- File Upload Display Type
create table as_item_display_f (
	as_item_display_id	integer
				constraint as_item_display_f_displ_id_pk
				primary key
				constraint as_item_display_f_displ_id_fk
				references cr_revisions(revision_id)
                on delete cascade,
	-- field to specify other stuff like textarea dimensions
	html_display_options	varchar(50),
	-- an abstraction of the real size value in "small","medium","large" 
	abs_size		varchar(10),
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
	item_answer_alignment	varchar(20)
);
