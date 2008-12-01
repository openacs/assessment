-- upgrade the column size
alter table as_assessments modify entry_page varchar(4000);
alter table as_assessments modify exit_page varchar(4000);
alter table as_assessments modify return_url varchar(4000);
exec content_type.refresh_view('as_assessments');
