-- here the selected choices are stored
create table as_item_data_choices (
	item_data_id	integer
			constraint as_item_data_choices_data_id_fk
			references as_item_data,
	-- references as_item_choices
	choice_id	integer
			constraint as_item_data_choices_choice_id_fk
			references as_item_choices,
	constraint as_item_data_choices_pk
	primary key (item_data_id, choice_id)
);

insert into as_item_data_choices (item_data_id, choice_id)
(select min(d2.item_data_id), d1.choice_id_answer as choice_id
 from as_item_data d1, as_item_data d2
 where d1.choice_id_answer is not null
 and d2.session_id = d1.session_id
 and d2.as_item_id = d1.as_item_id
 group by d1.item_data_id, d1.choice_id_answer);

delete from as_item_data
where choice_id_answer is not null
and item_data_id not in (select min(item_data_id)
			from as_item_data
			where choice_id_answer is not null
			group by session_id, as_item_id);

alter table as_item_data drop column choice_id_answer cascade;
alter table as_item_data add points integer;
select content_type__refresh_view('as_item_data');
