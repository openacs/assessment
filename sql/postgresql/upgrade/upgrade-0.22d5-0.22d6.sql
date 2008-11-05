-- upgrade the column size

alter table as_assessments rename entry_page to entry_page_old;
alter table as_assessments add entry_page varchar(4000);
update as_assessments set entry_page = entry_page_old;
alter table as_assessments drop entry_page_old cascade;

alter table as_assessments rename exit_page to exit_page_old;
alter table as_assessments add exit_page varchar(4000);
update as_assessments set exit_page = exit_page_old;
alter table as_assessments drop exit_page_old cascade;

alter table as_assessments rename return_url to return_url_old;
alter table as_assessments add return_url varchar(4000);
update as_assessments set return_url = return_url_old;
alter table as_assessments drop return_url_old cascade;

select content_type__refresh_view('as_assessments');
