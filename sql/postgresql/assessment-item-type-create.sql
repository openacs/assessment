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
				constraint as_item_type_mc_point_distrib_p_ck
				check (point_distrib_p in ('t','f')),
	allow_negative_p	char(1) default 'f'
				constraint as_item_type_mc_allow_negative_p_ck
				check (allow_negative_p in ('t','f')),
	num_correct_answers	integer,
	num_answers		integer
);

create table as_item_type_oq (
	as_item_type_id		integer
				constraint as_item_type_mc_as_item_type_id_pk
				primary key
				constraint as_item_type_mc_as_item_type_id_fk
				references cr_revisions(revision_id),
	default_value		varchar(500)
);

create table as_item_display_mc (
	as_item_display_id	integer
				constraint as_item_display_mc_as_item_display_id_pk
				primary key
				constraint as_item_display_mc_as_item_display_id_fk
				references cr_revisions(revision_id),
	allow_multiple_p	char(1) default 'f'
				constraint as_item_type_mc_allow_multiple_p_ck
				check (allow_multiple_p in ('t','f')),
);
