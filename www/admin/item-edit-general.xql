<?xml version="1.0"?>
<queryset>

<fullquery name="get_item_type">
      <querytext>

    select o.object_type
    from acs_objects o, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="display_types">
      <querytext>

    select display_type
    from as_item_types_map
    where item_type = :item_type

      </querytext>
</fullquery>

<fullquery name="general_item_data">
<querytext>

	select ci.name, r.title, r.description, i.subtext, i.field_code, i.required_p,
	       i.feedback_right, i.feedback_wrong, i.max_time_to_complete, i.data_type, i.points
	from cr_items ci, cr_revisions r, as_items i
	where ci.item_id = r.item_id
	and r.revision_id = i.as_item_id
	and i.as_item_id = :as_item_id

</querytext>
</fullquery>

<fullquery name="get_display_type">
      <querytext>

    select o.object_type
    from acs_objects o, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_display_rel'
    and o.object_id = r.target_rev_id

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
		set as_item_id = :new_item_id,
		    points = :points
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

</queryset>
