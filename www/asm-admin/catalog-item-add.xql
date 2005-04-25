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
      
    select i.as_item_id, i.subtext, cr.title, i.field_name, i.required_p,
           i.max_time_to_complete, i.points, cr.description
    from as_items i, cr_revisions cr, cr_items ci
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
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

	    insert into as_item_section_map
		(as_item_id, section_id, required_p, sort_order, max_time_to_complete,
		 fixed_position, points)
	    (select :as_item_id as as_item_id, :new_section_id as section_id,
		    required_p, :after as sort_order, max_time_to_complete,
		    0 as fixed_position, points
	     from as_items
	     where as_item_id = :as_item_id
	     and not exists (select 1
			    from as_item_section_map
			    where as_item_id = :as_item_id
			    and section_id = :new_section_id))

      </querytext>
</fullquery>

</queryset>
