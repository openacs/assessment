<?xml version="1.0"?>
<queryset>

<fullquery name="section_items">
      <querytext>
      
    select i.as_item_id, i.subtext, cr.title, cr.description, i.field_name,
           ism.required_p, ism.section_id, ism.sort_order,
           ism.max_time_to_complete, ism.points
    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = :section_id
    order by ism.sort_order
    
      </querytext>
</fullquery>
	
</queryset>
