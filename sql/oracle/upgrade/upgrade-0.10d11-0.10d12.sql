alter table as_items add (
	field_name varchar(500)
);

update as_items i
set i.field_name = (select ci.name
		from cr_items ci, cr_revisions cr
		where ci.item_id = cr.item_id
		and cr.revision_id = i.as_item_id);

commit;

update acs_objects o
set o.creation_user = (select o2.creation_user
			from acs_objects o2
			where o2.object_id = (select min(r.revision_id)
						from cr_revisions r
						where r.item_id = o.object_id))
where o.object_id in (select item_id from cr_items)
and o.creation_user is null;

commit;
