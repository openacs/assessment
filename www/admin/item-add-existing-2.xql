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

<fullquery name="add_item_to_section">
      <querytext>

	    insert into as_item_section_map
	    (select :item_id as as_item_id, :new_section_id as section_id,
	            't' as enabled_p, 'f' as required_p, null as item_default,
	            null as content_value, null as numeric_value, '' as feedback_text,
	            max_time_to_complete, '' as adp_chunk, :after as sort_order
	     from as_items
	     where as_item_id = :item_id)

      </querytext>
</fullquery>

</queryset>
