<?xml version="1.0"?>
<queryset>

<fullquery name="session_items">
      <querytext>
      
    select i.as_item_id, i.subtext, cr.title, cr.description, ci.name,
	   ism.required_p, ism.section_id, ism.sort_order, i.feedback_right,
	   i.feedback_wrong, ism.max_time_to_complete, ism.points
    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism,
         as_session_items si
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = si.section_id
    and ism.as_item_id = si.as_item_id
    and si.section_id = :section_id
    and si.session_id = :session_id
    order by si.sort_order
    
      </querytext>
</fullquery>

<fullquery name="choice_orientation">
	<querytext>

	    select d.choice_orientation
	    from as_item_rels r, as_item_display_$presentation_type d
	    where r.item_rev_id = :as_item_id
	    and r.rel_type = 'as_item_display_rel'
	    and r.target_rev_id = d.as_item_display_id

	</querytext>
</fullquery>
	
</queryset>
