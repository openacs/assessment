alter table as_items rename column points to points_int;
alter table as_items add points float;
update as_items set points=points_int;
alter table as_items drop column points_int;

begin
content_type.refresh_view('as_item_data');
end;
/
show errors;

alter table as_item_data rename column points to points_int;
alter table as_item_data add points float;
update as_item_data set points=points_int;
alter table as_item_data drop column points_int;

begin
content_type.refresh_view('as_item_data');
end;
/
show errors;

alter table as_session_results rename column points to points_int;
alter table as_session_results add points float;
update as_session_results set points=points_int;
alter table as_session_results drop column points_int;

begin
content_type.refresh_view('as_session_results');
end;
/
show errors;

alter table as_sections rename column points to points_int;
alter table as_sections add points float;
update as_sections set points=points_int;
alter table as_sections drop column points_int;

begin
content_type.refresh_view('as_sections');
end;
/
show errors;

alter table as_section_data rename column points to points_int;
alter table as_section_data add points float;
update as_section_data set points=points_int;
alter table as_section_data drop column points_int;

begin
content_type.refresh_view('as_section_data');
end;
/
show errors;

alter table as_assessment_section_map rename column points to points_int;
alter table as_assessment_section_map add points type float;
update as_assessment_section_map set points=points_int;
alter table as_assessment_section_map drop column points_int;
alter table as_item_section_map alter points type float;
alter table as_item_section_map add points type float;
update as_item_section_map set points=points_int;
alter table as_item_section_map drop column points_int;

