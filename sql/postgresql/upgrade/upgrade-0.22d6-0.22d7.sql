drop view as_item_datax;
drop view as_item_datai cascade;
alter table as_item_data alter points type float;
select content_type__refresh_view('as_item_data');

drop view as_session_resultsx;
drop view as_session_resultsi cascade;
alter table as_session_results alter points type float;
select content_type__refresh_view('as_session_results');
