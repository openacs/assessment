<?xml version="1.0"?>
<queryset>

<fullquery name="section_items">
      <querytext>
      
    select i.as_item_id, cr.title, i.definition, ism.required_p,
           ism.enabled_p, ism.section_id, ism.sort_order, ism.adp_chunk,
           ism.max_time_to_complete
    from as_items i, cr_revisions cr, as_item_section_map ism
    where cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = :section_id
    order by ism.sort_order
    
      </querytext>
</fullquery>

 
</queryset>
