--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

-- stores the common attributes of all "questions" that constitute the atomic focus of the Assessment package
create table as_items (
	as_item_id	integer
			constraint as_items_item_id_pk
                        primary key
			constraint as_items_item_id_fk
			references cr_revisions(revision_id)
                        on delete cascade,
	-- a secondary label, needed for many kinds of questions
	subtext		varchar(500),
	-- a short label for use in cvs export
	field_name	varchar(500),
	-- a short label for use in qti export
	field_code	varchar(500),
	-- whether Item must be answered (default value, can be overridden)
	required_p	char(1) default 'f'
			constraint as_items_required_p_ck
			check (required_p in ('t','f')),
	-- the expected data type of the answer (integer, numeric, exponential, varchar, text, date, boolean, timestamp, content_type)
	data_type	varchar(50),
	-- optional max number of seconds to perform Item
	max_time_to_complete	integer,
	-- right feedback  
	feedback_right	clob,
	-- wrong feedback
	feedback_wrong	clob,
	-- number of points for item; might be used for defining difficulty levels
	points		float
);

-- contains additional information for all multiple choices (radiobutton, checkbox)
create table as_item_choices (
	choice_id       integer
                        constraint as_item_choices_id_pk
                        primary key
			constraint as_item_choices_id_fk
			references cr_revisions(revision_id)
                        on delete cascade,                        
	mc_id		integer
			constraint as_item_choices_parent_id_fk
			references as_item_type_mc(as_item_type_id)
                        on delete cascade,                        
	-- which of the value columns has the information this Choice conveys
	data_type	varchar(20),
	-- we can stuff both integers and real numbers here
        numeric_value   numeric,
	text_value	varchar(500),
	boolean_value	char(1)
			constraint as_item_choices_boolean_ck
			check (boolean_value in ('t','f')),
	-- references an item in the CR -- for an image, audio file, or video file
	content_value	integer
			constraint as_item_choices_content_fk
                        references cr_revisions
                        on delete cascade,                        
	-- where optionally some preset feedback can be specified by the author
	feedback_text	varchar(500),	
	-- when the item is presented to the user this choice is selected by default
	selected_p	char(1) default 'f'
			constraint as_item_choices_selected_p_ck
			check (selected_p in ('t','f')),
	-- this choice is the correct answer
	correct_answer_p	char(1) default 'f'
			constraint as_item_choices_canswer_ck
			check (correct_answer_p in ('t','f')),
	-- the order this choice will appear with regards to the MC item.
	sort_order	integer,
	-- fixed position in display. 0 for default, negative values relative to end
	fixed_position	integer,
	-- this is where points are stored
	percent_score		integer
			constraint as_item_choices_percent_ck
			check (percent_score <= 100)	
);

create index as_i_choices_order_idx on as_item_choices (mc_id, sort_order);
create index as_i_choices_cv_idx on as_item_choices(content_value);
create index as_i_choices_mc_id_idx on as_item_choices(mc_id);

-- Short Answer Answers
create table as_item_sa_answers (
	choice_id       integer
                        constraint as_item_sa_answ_id_pk
                        primary key
			constraint as_item_sa_answ_id_fk
			references cr_revisions(revision_id)
                        on delete cascade,
	answer_id	integer
			constraint as_item_sa_answ_parent_id_fk
			references as_item_type_sa(as_item_type_id)
                        on delete cascade,
	-- integer vs. real number vs. text
	data_type	varchar(20),
	-- shall the match be case sensitive
	case_sensitive_p	char(1) default 't'
			constraint as_item_sa_answ_case_p_ck
			check (case_sensitive_p in ('t','f')),
	-- this is where points are stored
	percent_score		integer
			constraint as_item_sa_answ_percent_ck
			check (percent_score <= 100),
	-- how is the comparison done (equal, contains, regexp)
	compare_by	varchar(20),
	-- contains the actual regexp if compare_by is a regexp
	regexp_text	varchar(20), 
	-- list with all answerbox ids (1 2 3 ... n) whose response will be tried to match against this answer. An empty field indicates the
	-- answer will be tried to match against all answers.
        allowed_answerbox_list	varchar(20)
);

-- Messages: abstracts out help messages (and other types of messages) for use in the Assessment package.
create table as_messages (
	message_id	integer
			constraint as_messages_message_id_pk
			primary key,
	message		varchar(500)
);

-- relationship between item and help
create table as_item_help_map (
	as_item_id		integer
		constraint as_item_help_map_as_item_id_fk
		references as_items (as_item_id)
                on delete cascade,
	message_id	integer
		constraint as_item_help_map_message_id_fk
		references as_messages (message_id)
                on delete cascade,
	-- order in which the messages appear
	sort_order	integer
);
