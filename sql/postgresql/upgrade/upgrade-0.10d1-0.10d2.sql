alter table as_item_data add column section_id integer constraint as_item_data_section_id references as_sections(section_id);

-- here all references to answers of a session are stored
create table as_session_item_map (
	session_id	integer
			constraint as_session_item_map_session_fk
			references as_sessions,
	item_data_id	integer
			constraint as_session_item_map_item_data_fk
			references as_item_data,
	constraint as_session_item_map_pk
	primary key (session_id, item_data_id)
);

delete from as_item_data where session_id is null;

update as_item_data
set section_id = (select i.section_id
                  from as_session_items i
                  where i.session_id = as_item_data.session_id
                  and i.as_item_id = as_item_data.as_item_id);

insert into as_session_item_map (session_id, item_data_id)
(select session_id, item_data_id
from as_item_data);
