create table as_session_results (
       result_id   integer
                   constraint as_session_results_result_id_pk
                   primary key
                   constraint as_session_results_result_id_fk
                   references cr_revisions(revision_id),
       target_id   integer
                   constraint as_session_results_target_id_fk
                   references cr_revisions(revision_id),
       points      integer
);

create index as_session_results_target_idx on as_session_results (target_id);

alter table as_item_type_oq add column reference_answer text;
alter table as_item_type_oq add column keywords varchar(4000);

alter table as_assessments add column password varchar(100);
