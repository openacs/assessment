<?xml version="1.0"?>
<queryset>

<fullquery name="section_items">
      <querytext>
      
    select i.as_item_id, i.subtext, cr.title, ci.name, ism.required_p,
           ism.section_id, ism.sort_order,
           ism.max_time_to_complete, ism.points
    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = :section_id
    order by ism.sort_order
    
      </querytext>
</fullquery>

<fullquery name="item_type_id">
<querytext>

    select max(t.as_item_type_id) as as_item_type_id
    from as_item_type_mc t, cr_revisions c, as_item_rels r
    where t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.revision_id = t.as_item_type_id
    group by c.title, t.increasing_p, t.allow_negative_p,
    t.num_correct_answers, t.num_answers
</querytext>
</fullquery>

</queryset>
