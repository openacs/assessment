
alter table as_item_data add as_item_cr_item_id integer;
alter table as_item_data add choice_value varchar2(4000);

create or replace trigger as_item_data_ins_trg
before insert on as_item_data
for each row
declare v_item_id integer;
begin
select item_id into v_item_id
from cr_revisions where revision_id = :new.as_item_id;
:new.as_item_cr_item_id := v_item_id;
end as_item_data_ins_trg;
/
show errors;

create or replace trigger as_item_data_choices_ins_trg
after insert on as_item_data_choices
for each row
declare v_choice_value varchar(4000) default '';
begin

select title into v_choice_value
from as_item_choicesx
where choice_id = :new.choice_id;

update as_item_data set choice_value = coalesce(choice_value,'') || ' ' || coalesce(v_choice_value,'') where item_data_id = :new.item_data_id;

end as_item_data_choices_ins_trg;
/
show errors;

create or replace trigger as_item_data_upd_trg
before update on as_item_data
for each row
declare v_item_id integer;
begin
select item_id into v_item_id
from cr_revisions where revision_id = :new.as_item_id;
:new.as_item_cr_item_id := v_item_id;
end as_item_data_ins_trg;
/
show errors;

update as_item_data set item_data_id=item_data_id;

drop trigger as_item_data_upd_trg;

create or replace procedure as_item_data_choices_upd_trg is

v_choice_value varchar(4000) default '';
v_last_item_data_id integer default NULL;

cursor choices_cur is
select title as text_value, item_data_id from
    as_item_choicesx c,
    as_item_data_choices dc
    where 
    c.choice_id = dc.choice_id
    order by dc.item_data_id;
begin
for choice_rec in choices_cur loop
    if v_last_item_data_id <> choice_rec.item_data_id then
        v_choice_value := '';
    end if;
    v_choice_value := v_choice_value || ' ' || coalesce(choice_rec.text_value,'');

    update as_item_data set choice_value = v_choice_value where item_data_id = choice_rec.item_data_id;
    v_last_item_data_id := choice_rec.item_data_id;
end loop;
end as_item_data_choices_upd_trg;
/
show errors;

begin
as_item_data_choices_upd_trg;
end;
/
show errors;
drop procedure as_item_data_choices_upd_trg;

