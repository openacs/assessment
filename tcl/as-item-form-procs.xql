<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_form::add_item_to_form.item_properties">
	<querytext>
		select cr.title, i.subtext, i.data_type, i.required_p,
		       max(oi.object_id) as item_type_id, oi.object_type as item_type,
		       od.object_id as display_type_id, od.object_type as display_type
		from as_items i, cr_revisions cr, as_item_rels it,
		     as_item_rels dt, acs_objects oi, acs_objects od
		where i.as_item_id = :item_id
		and cr.revision_id = i.as_item_id
		and it.item_rev_id = i.as_item_id
		and dt.item_rev_id = i.as_item_id
		and it.rel_type = 'as_item_type_rel'
		and dt.rel_type = 'as_item_display_rel'
		and oi.object_id = it.target_rev_id
		and od.object_id = dt.target_rev_id
		group by cr.title, i.subtext, i.data_type, i.required_p, oi.object_type,od.object_id, od.object_type
	</querytext>
</fullquery>

</queryset>
