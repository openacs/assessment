<?xml version="1.0"?>
<queryset>

<fullquery name="display_types">
      <querytext>

    select display_type
    from as_item_types_map
    where item_type = 'sa'

      </querytext>
</fullquery>

<fullquery name="item_type">
      <querytext>

	select r.target_rev_id as as_item_type_id, o.object_type
	from as_item_rels r, acs_objects o
	where r.item_rev_id = :as_item_id
	and r.rel_type = 'as_item_type_rel'
	and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="update_item_type">
      <querytext>

		update as_item_rels
		set target_rev_id = :as_item_type_id
		where item_rev_id = :as_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

<fullquery name="get_title">
      <querytext>

        select r.title
        from cr_revisions r
        where r.revision_id = :as_item_id

      </querytext>
</fullquery>

</queryset>
