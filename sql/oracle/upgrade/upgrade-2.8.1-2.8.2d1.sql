
create or replace function __create_index(name varchar, def varchar) return integer
is
declare v_exists integer;
begin
  select into v_exists count(*) from pg_class where relname = name;
  if v_exists = 0 then
    execute immediate 'create index ' || name || ' ' || def; 
  end if;
  return 1;
end;
/
show errors

select __create_index('as_item_choices_content_value_idx', 'on as_item_choices(content_value)');
select __create_index('as_item_choices_mc_id_idx', 'on as_item_choices(mc_id)');
select __create_index('as_item_data_as_item_id_idx', 'on as_item_data(as_item_id)');
select __create_index('as_item_data_content_answer_idx', 'on as_item_data(content_answer)');
select __create_index('as_item_data_file_id_idx', 'on as_item_data(file_id)');
select __create_index('as_item_data_section_id_idx', 'on as_item_data(section_id)');
select __create_index('as_item_data_staff_id_idx', 'on as_item_data(staff_id)');
select __create_index('as_item_rels_item_rev_id_idx', 'on as_item_rels(item_rev_id)');
select __create_index('as_item_rels_target_rev_id_idx', 'on as_item_rels(target_rev_id)');


drop function __create_index(name varchar, def varchar);
