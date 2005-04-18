<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_history">
	<querytext>
	select r.revision_id, to_char(o.creation_date, :format) as creation_date,
	       p.person_id, p.first_names || ' ' || p.last_name AS user_name
	from cr_revisions r, acs_objects o, persons p
	where r.item_id = :assessment_id
	and o.object_id = r.revision_id
	and p.person_id = o.creation_user
	order by o.creation_date desc
	</querytext>
</fullquery>

</queryset>
