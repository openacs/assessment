create table as_session_results (
       result_id   integer
                   constraint as_sess_res_res_id_pk
                   primary key
                   constraint as_sess_res_res_id_fk
                   references cr_revisions(revision_id),
       target_id   integer
                   constraint as_sess_res_tgt_id_fk
                   references cr_revisions(revision_id),
       points      integer
);

create index as_sess_res_tgt_idx on as_session_results (target_id);

alter table as_item_type_oq add (
	-- reference text with the expected perfect answer
	reference_answer	clob,
	-- keyword list for automatic pre-grading
	keywords		varchar(4000)
);

alter table as_assessments add (
	password varchar(100)
);

alter table as_item_display_tb add (alignment_help varchar(20));
update as_item_display_tb set alignment_help = item_answer_alignment;
alter table as_item_display_tb drop column item_answer_alignment cascade constraints;
alter table as_item_display_tb add (item_answer_alignment varchar(20));
update as_item_display_tb set item_answer_alignment = alignment_help;
alter table as_item_display_tb drop column alignment_help;

begin
  content_type.refresh_view('as_item_display_tb');
end;
/
show errors;
