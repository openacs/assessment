<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

	select r.title
	from cr_revisions r, as_item_rels ir, as_item_type_fu i
	where r.revision_id = i.as_item_type_id
	and i.as_item_type_id = ir.target_rev_id
	and ir.item_rev_id = :as_item_id
	and ir.rel_type = 'as_item_type_rel'

</querytext>
</fullquery>

<fullquery name="item_type_id">
      <querytext>

	select target_rev_id
	from as_item_rels
	where item_rev_id = :new_item_id
	and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="update_item_in_section">
      <querytext>

		update as_item_section_map
		set as_item_id = :new_item_id
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="update_item_type">
      <querytext>

		update as_item_rels
		set target_rev_id = :new_item_type_id
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

</queryset>
