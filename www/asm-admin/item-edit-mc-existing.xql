<?xml version="1.0"?>
<queryset>

<fullquery name="existing_choice_sets">
      <querytext>

    select r.title, r.revision_id
    from cr_revisions r, cr_items i
    where r.revision_id = i.latest_revision
    and i.parent_id = :folder_id
    and i.content_type = 'as_item_type_mc'

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
		set target_rev_id = :mc_id
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

</queryset>
