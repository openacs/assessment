--
-- Assessment Package
--
-- @author eperez@it.uc3m.es
-- @creation-date 2004-07-20
--

create table as_item_type_mc (
	as_item_type_id		integer
				constraint as_item_type_mc_as_item_type_id_pk
				primary key
				constraint as_item_type_mc_as_item_type_id_fk
				references cr_revisions(revision_id),
	increasing_p		char(1) default 'f'
				constraint as_item_type_mc_increasing_p_ck
				check (increasing_p in ('t','f')),
	allow_negative_p	char(1) default 'f'
				constraint as_item_type_mc_allow_negative_p_ck
				check (allow_negative_p in ('t','f')),
	num_correct_answers	integer,
	num_answers		integer
);

create table as_item_type_oq (
	as_item_type_id		integer
				constraint as_item_type_oq_as_item_type_id_pk
				primary key
				constraint as_item_type_oq_as_item_type_id_fk
				references cr_revisions(revision_id),
	default_value		varchar(500),
	feedback_text    varchar(500)
);

create table as_item_display_rb (
	as_item_display_id	integer
				constraint as_item_display_rb_as_item_display_id_pk
				primary key
				constraint as_item_display_rb_as_item_display_id_fk
				references cr_revisions(revision_id),
	html_display_options	varchar(50),
	choice_orientation	varchar(20),
	choice_label_orientation varchar(20),
	sort_order_type		varchar(20),
	item_answer_alignment	varchar(20)
);

create table as_item_display_cb (
	as_item_display_id	integer
				constraint as_item_display_cb_as_item_display_id_pk
				primary key
				constraint as_item_display_cb_as_item_display_id_fk
				references cr_revisions(revision_id),
	html_display_options	varchar(50),
	choice_orientation	varchar(20),
	choice_label_orientation varchar(20),
	allow_multiple_p	char(1) default 'f'
				constraint as_item_type_cb_allow_multiple_p_ck
				check (allow_multiple_p in ('t','f')),
	sort_order_type		varchar(20),
	item_answer_alignment	varchar(20)
);

create table as_item_display_tb (
	as_item_display_id	integer
				constraint as_item_display_tb_as_item_display_id_pk
				primary key
				constraint as_item_display_tb_as_item_display_id_fk
				references cr_revisions(revision_id),
	html_display_options	varchar(50),
	abs_size		varchar(10),
	item_answer_alignment	varchar(10)
);

create table as_item_display_sa (
	as_item_display_id	integer
				constraint as_item_display_sa_as_item_display_id_pk
				primary key
				constraint as_item_display_sa_as_item_display_id_fk
				references cr_revisions(revision_id),
	html_display_options	varchar(50),
	abs_size		varchar(10),
	box_orientation		varchar(10)
);

create table as_item_type_sa (
	as_item_type_id		integer
				constraint as_item_type_sa_as_item_type_id_pk
				primary key
				constraint as_item_type_sa_as_item_type_id_fk
				references cr_revisions(revision_id),
	increasing_p		char(1) default 'f'
				constraint as_item_type_sa_increasing_p_ck
				check (increasing_p in ('t','f')),
	allow_negative_p	char(1) default 'f'
				constraint as_item_type_sa_allow_negative_p_ck
				check (allow_negative_p in ('t','f'))	
);

create table as_item_display_ta (
	as_item_display_id	integer
				constraint as_item_display_ta_as_item_display_id_pk
				primary key
				constraint as_item_display_ta_as_item_display_id_fk
				references cr_revisions(revision_id),
	html_display_options	varchar(50),
	abs_size	varchar(20),
	acs_widget varchar(20),	
	item_answer_alignment	varchar(20)
);
