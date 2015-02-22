--
-- Assessment Package
--
-- @author timo@timohentschel.de
-- @creation-date 2004-11-05
--

-- this table maps which display types are valid for which item types

create table as_item_types_map (
	item_type		varchar(50),
	display_type		varchar(50),
	constraint as_item_types_map_pk primary key (item_type, display_type)
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
values ('mc', 'sb');
insert into as_item_types_map (item_type, display_type)
values ('fu', 'f');
-- insert into as_item_types_map (item_type, display_type)
-- values ('ca', 'tb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'rb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'cb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'sb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'tb');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'ta');
-- insert into as_item_types_map (item_type, display_type)
-- values ('dq', 'file');


-- this table maps items to item types and display types

create table as_item_rels (
	item_rev_id	integer
			constraint as_item_rels_item_fk
			references acs_objects
            on delete cascade,
	target_rev_id	integer
			constraint as_item_rels_target_fk
			references acs_objects
            on delete cascade,
	rel_type	varchar(20),
	constraint as_item_rels_pk
	primary key (item_rev_id, rel_type, target_rev_id)
);

create index as_item_rels_item_rev_id_idx on as_item_rels(item_rev_id);
create index as_item_rels_target_rev_id_idx on as_item_rels(target_rev_id);

