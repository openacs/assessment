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
			references cr_revisions(revision_id),
	-- a secondary label, needed for many kinds of questions
	subtext		varchar(500),
	-- a short label for use in data output header rows, etc
	field_code	varchar(500),
	-- some descriptive text
	definition 	clob,
	-- whether Item must be answered (default value, can be overriden)
	required_p	char(1) default 'f'
			constraint as_items_required_p_ck
			check (required_p in ('t','f')),
	-- the expected data type of the answer (integer, numeric, exponential, varchar, text, date, boolean, timestamp, content_type)
	data_type	varchar(50),
	-- optional max number of seconds to perform Item
	max_time_to_complete	integer,
	-- a denormalization to cache the generated "widget" for the Item (NB: when any change is made to an as_item_choice related to an as_item, this will have to be updated!)
	adp_chunk	varchar(500),
	-- right feedback  
	feedback_right	clob,
	-- wrong feedback
	feedback_wrong	clob
);

-- contains additional information for all multiple choices (radiobutton, checkbox)
create table as_item_choices (
	choice_id       integer
                        constraint as_item_choices_id_pk
                        primary key
			constraint as_item_choices_id_fk
			references cr_revisions(revision_id),
	mc_id		integer
			constraint as_item_choices_parent_id_fk
			references as_item_type_mc(as_item_type_id),
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
                        references cr_revisions,
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
	-- this is where points are stored
	percent_score		integer
			constraint as_item_choices_percent_ck
			check (percent_score <= 100)	
);

-- Short Answer Answers
create table as_item_sa_answers (
	choice_id       integer
                        constraint as_item_sa_answ_id_pk
                        primary key
			constraint as_item_sa_answ_id_fk
			references cr_revisions(revision_id),
	answer_id	integer
			constraint as_item_sa_answ_parent_id_fk
			references as_item_type_sa(as_item_type_id),
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
		references as_items (as_item_id),
	message_id	integer
		constraint as_item_help_map_message_id_fk
		references as_messages (message_id),
	-- order in which the messages appear
	sort_order	integer
);