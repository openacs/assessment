<?xml version="1.0"?>
<queryset>

<fullquery name="item_type">
	<querytext>

	select o.object_type as item_type, r.target_rev_id as item_type_id,
	       m.points
	from acs_objects o, as_item_rels r, as_item_section_map m
	where r.item_rev_id = :response_to_item_id
	and r.rel_type = 'as_item_type_rel'
	and o.object_id = r.target_rev_id
	and m.as_item_id = r.item_rev_id
	and m.section_id = :section_id

	</querytext>
</fullquery>
	
</queryset>
