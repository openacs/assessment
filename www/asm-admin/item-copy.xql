<?xml version="1.0"?>
<queryset>

<fullquery name="item_data">
      <querytext>

	select r.title as item_title, r.title, r.description, i.field_name
	from cr_revisions r, as_items i
	where r.revision_id = i.as_item_id
	and i.as_item_id = :as_item_id

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

	    insert into as_item_section_map (as_item_id, section_id, required_p, max_time_to_complete,
	           sort_order, fixed_position, points)
	    (select :new_item_id as as_item_id, :new_section_id as section_id,
	            required_p, max_time_to_complete, :after as sort_order, fixed_position, points
	     from as_item_section_map
	     where as_item_id = :as_item_id
	     and section_id = :section_id)

      </querytext>
</fullquery>

</queryset>
