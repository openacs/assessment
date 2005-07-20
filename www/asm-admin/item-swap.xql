<?xml version="1.0"?>
<queryset>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="get_item_id">
      <querytext>
	select as_item_id from as_item_section_map where sort_order=:sort_order and section_id=:section_id
      </querytext>
</fullquery>

</queryset>
