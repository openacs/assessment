<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_rels::new.insert_relationship">
<querytext>

	insert into as_item_rels (item_rev_id, target_rev_id, rel_type)
	values (:item_rev_id, :target_rev_id, :type)

</querytext>
</fullquery>

<fullquery name="as::item_rels::get_target.target_object">
<querytext>

	select target_rev_id
	from as_item_rels
	where item_rev_id = :item_rev_id
	and rel_type = :type

</querytext>
</fullquery>

</queryset>
