create table as_item_rels (
	item_rev_id	integer
			constraint as_item_rels_item_fk
			references acs_objects,
	target_rev_id	integer
			constraint as_item_rels_target_fk
			references acs_objects,
	rel_type	varchar(20),
	constraint as_item_rels_pk
	primary key (item_rev_id, rel_type, target_rev_id)
);

insert into as_item_rels
(select i1.latest_revision as item_rev_id, i2.latest_revision as target_rev_id, relation_tag as rel_type
from cr_item_rels r, cr_items i1, cr_items i2
where i1.item_id = r.item_id
and i2.item_id = r.related_object_id
and relation_tag in ('as_item_type_rel', 'as_item_display_rel'));

-- Selectbox Display Type
create table as_item_display_sb (
	as_item_display_id	integer
				constraint as_item_display_sb_displ_id_pk
				primary key
				constraint as_item_display_sb_displ_id_fk
				references cr_revisions(revision_id),
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
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, bellow, above)
	item_answer_alignment	varchar(20)
);
