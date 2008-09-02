 
alter table as_item_data add as_item_cr_item_id integer;
alter table as_item_data add choice_value text;

create or replace function as_item_data_ins_trg() returns trigger as '
declare v_item_id integer;
begin
select item_id into v_item_id
from cr_revisions where revision_id = NEW.as_item_id;
NEW.as_item_cr_item_id = v_item_id;
return NEW;
end;' language 'plpgsql';

create or replace function as_item_data_choices_ins_trg () returns trigger as '
declare v_choice_value text default '''';
begin

select title into v_choice_value
from as_item_choices
where choice_id = NEW.choice_id;

update as_item_data set choice_value = coalesce(choice_value,'''') || '' '' || coalesce(v_choice_value,'''') where item_data_id = new.item_data_id;

return NEW;

end;' language 'plpgsql';

create or replace function as_item_data_choices_upd_trg() returns trigger as '
declare v_choice_value text default '';
declare v_row record;
begin

for v_row in select title as text_value from
    as_item_choicesx c,
    as_item_data_choices dc
    where dc.item_data_id = new.item_data_id and
    c.choice_id = dc.choice_id
loop
    v_choice_value := v_choice_value || ' ' || coalesce(v_row.text_value,'');
end loop;

update as_item_data set choice_value = coalesce(choice_value,'''') || '' '' || coalesce(v_choice_value,'''') where item_data_id = new.item_data_id;
return NEW;
end;' language 'plpgsql';

create trigger as_item_data_ins_trg before insert on as_item_data for each row execute procedure as_item_data_ins_trg();
create trigger as_item_data_upd_trg before update on as_item_data for each row execute procedure as_item_data_ins_trg();

create trigger as_item_data_choices_ins_trg after insert on as_item_data_choices for each row execute procedure as_item_data_choices_ins_trg();
create trigger as_item_data_choices_upd_trg after update on as_item_data_choices for each row execute procedure as_item_data_choices_ins_trg();

update as_item_data set item_data_id=item_data_id;
update as_item_data_choices set item_data_id = item_data_id;

drop trigger as_item_data_choices_upd_trigger on as_item_data_choices;
drop trigger as_item_data_upd_trigger on as_item_data;
drop functon as_item_data_choices_upd_trg();