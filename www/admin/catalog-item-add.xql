<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>
      
    select title as section_title
    from cr_revisions
    where revision_id = :section_id
    
      </querytext>
</fullquery>

<fullquery name="items">
      <querytext>
      
    select i.as_item_id, cr.title, i.definition
    from as_items i, cr_revisions cr
    where cr.revision_id = i.as_item_id
    and i.as_item_id in ([join $as_item_id ,])
    order by i.as_item_id
    
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
	    set sort_order = sort_order + :item_count
	    where section_id = :new_section_id
	    and sort_order > :after

      </querytext>
</fullquery>

<fullquery name="add_item_to_section">
      <querytext>

	    insert into as_item_section_map (as_item_id, section_id, sort_order)
	    values (:as_item_id, :new_section_id, :after)

      </querytext>
</fullquery>

</queryset>
