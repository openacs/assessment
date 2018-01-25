alter table as_sections drop constraint as_sections_section_display_type_id_fk;

drop table as_section_display_types;

--Section Display Types: define types of display for an groups of Items.
create table as_section_display_types (
	display_type_id		integer
				constraint as_section_display_types_id_pk
				primary key
				constraint as_section_display_types_id_fk
				references cr_revisions(revision_id),
	-- number of items displayed per page
	num_items		integer,
	-- adp template
	adp_chunk		text,
	-- whether this Section defines a branch point or whether this Section simply transitions to the next Section
	branched_p		char(1) default 'f'
				constraint as_section_display_types_branched_p_ck
				check (branched_p in ('t','f')),
	-- whether the back button is not allowed to work
	back_button_p		char(1) default 't'
				constraint as_section_display_types_back_button_p_ck
				check (back_button_p in ('t','f')),
	-- whether each answer has to be submitted via a separate button
	submit_answer_p		char(1) default 'f'
				constraint as_section_display_types_submit_answer_p_ck
				check (submit_answer_p in ('t','f')),
	-- order in which the items will appear (randomized, alphabetical, order_of_entry)
	sort_order_type		varchar(20)
);

alter table as_sections drop column section_display_type_id cascade;
alter table as_sections add column display_type_id integer constraint as_sections_display_type_id_fk references as_section_display_types (display_type_id);
alter table as_sections drop column definition cascade;
alter table as_sections drop column content_value cascade;
alter table as_sections drop column numeric_value cascade;
alter table as_sections drop column required_p cascade;
alter table as_sections add points integer;

alter table as_assessment_section_map drop column feedback_text cascade;
alter table as_assessment_section_map add points integer;

alter table as_item_section_map drop column enabled_p cascade;
alter table as_item_section_map drop column item_default cascade;
alter table as_item_section_map drop column content_value cascade;
alter table as_item_section_map drop column numeric_value cascade;
alter table as_item_section_map drop column feedback_text cascade;
alter table as_item_section_map drop column adp_chunk cascade;
alter table as_item_section_map add fixed_position integer;
alter table as_item_section_map add points integer;

alter table as_items drop column definition cascade;
alter table as_items drop column adp_chunk cascade;
alter table as_items add points integer;

select content_type__refresh_view('as_items');
select content_type__refresh_view('as_sections');
