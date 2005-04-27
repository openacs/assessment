alter table as_items add column field_name varchar(500);

update as_items 
set field_name = (select ci.name
		from cr_items ci, cr_revisions cr
		where ci.item_id = cr.item_id
		and cr.revision_id = as_items.as_item_id);

update acs_objects 
set creation_user = (select o2.creation_user
			from acs_objects o2
			where o2.object_id = (select min(r.revision_id)
						from cr_revisions r
						where r.item_id = acs_objects.object_id))
where object_id in (select item_id from cr_items)
and creation_user is null;
