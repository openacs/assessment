<?xml version="1.0"?>
<queryset>

<fullquery name="item_title">
      <querytext>

	select title as item_title
	from cr_revisions
	where revision_id = :as_item_id

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

	    insert into as_item_section_map
	    (select :new_item_id as as_item_id, :new_section_id as section_id,
	            enabled_p, required_p, item_default, content_value, numeric_value,
	            feedback_text, max_time_to_complete, adp_chunk, :after as sort_order
	     from as_item_section_map
	     where as_item_id = :as_item_id
	     and section_id = :section_id)

      </querytext>
</fullquery>

</queryset>
