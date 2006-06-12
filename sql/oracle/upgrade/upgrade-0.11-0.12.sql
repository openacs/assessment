alter table as_item_data add column file_id integer constraint as_item_data_file_id_fk references cr_revisions(revision_id);
insert into as_item_types_map (item_type, display_type) values ('fu', 'f');

-- File Upload Item
create table as_item_type_fu (
	as_item_type_id		integer
				constraint as_item_type_fu_as_item_type_id_pk
				primary key
				constraint as_item_type_fu_as_item_type_id_fk
				references cr_revisions(revision_id)
);

-- File Upload Display Type
create table as_item_display_f (
	as_item_display_id	integer
				constraint as_item_display_f_as_item_display_id_pk
				primary key
				constraint as_item_display_f_as_item_display_id_fk
				references cr_revisions(revision_id),
	-- field to specify other stuff like textarea dimensions
	html_display_options	varchar(50),
	-- an abstraction of the real size value in "small","medium","large" 
	abs_size		varchar(10),
	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, bellow, above)
	item_answer_alignment	varchar(20)
);
