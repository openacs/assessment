
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
