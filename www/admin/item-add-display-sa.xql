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

<fullquery name="move_down_items">
      <querytext>

	    update as_item_section_map
	    set sort_order = sort_order+1
	    where section_id = :new_section_id
	    and sort_order > :after

      </querytext>
</fullquery>

<fullquery name="insert_new_item">
      <querytext>

	    insert into as_item_section_map
		(as_item_id, section_id, required_p, sort_order, max_time_to_complete,
		 fixed_position, points)
	    (select :as_item_id as as_item_id, :new_section_id as section_id,
		    required_p, :after as sort_order, max_time_to_complete,
		    0 as fixed_position, points
	     from as_items
	     where as_item_id = :as_item_id)

      </querytext>
</fullquery>

</queryset>
