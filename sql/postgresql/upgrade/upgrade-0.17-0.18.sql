-- upgrade the column size
drop view as_assessmentsx;
drop view as_assessmentsi;
alter table as_assessments alter column entry_page type varchar(4000);
alter table as_assessments alter column exit_page type varchar(4000);
alter table as_assessments alter column return_url type varchar(4000);
select content_type__refresh_view('as_assessments');