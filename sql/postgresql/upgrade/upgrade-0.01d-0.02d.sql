--
-- Assessment Package
--
-- @author timo@timohentschel.de
-- @creation-date 2004-11-05
--

-- this table maps which display types are valid for which item types

create table as_item_types_map (
	item_type		varchar(50),
	display_type		varchar(50)
);

insert into as_item_types_map (item_type, display_type)
values ('oq', 'tb');
insert into as_item_types_map (item_type, display_type)
values ('oq', 'ta');
insert into as_item_types_map (item_type, display_type)
values ('sa', 'tb');
insert into as_item_types_map (item_type, display_type)
values ('mc', 'rb');
insert into as_item_types_map (item_type, display_type)
values ('mc', 'cb');
insert into as_item_types_map (item_type, display_type)
values ('mc', 'sa');
-- insert into as_item_types_map (item_type, display_type)
-- values ('ca', 'tb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'rb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'cb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'sa');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'tb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'ta');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'file');
