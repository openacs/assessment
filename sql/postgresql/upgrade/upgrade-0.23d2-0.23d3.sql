drop view as_itemsx;
drop view as_itemsi cascade;
alter table as_items alter points type float;
select content_type__refresh_view('as_items');

drop view as_item_datax;
drop view as_item_datai cascade;
alter table as_item_data alter points type float;
select content_type__refresh_view('as_item_data');

drop view as_session_resultsx;
drop view as_session_resultsi cascade;
alter table as_session_results alter points type float;
select content_type__refresh_view('as_session_results');

drop view as_sectionsx;
drop view as_sectionsi cascade;
alter table as_sections alter points type float;
select content_type__refresh_view('as_sections');

drop view as_section_datax;
drop view as_section_datai cascade;
alter table as_section_data alter points type float;
select content_type__refresh_view('as_section_data');

alter table as_assessment_section_map alter points type float;
alter table as_item_section_map alter points type float;
