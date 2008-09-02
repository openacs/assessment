<?xml version="1.0"?>
<queryset>

<fullquery name="session_items">
      <querytext>
      
    select i.as_item_id, i.subtext, cr.content as title, cr.description, ci.name,
	   ism.required_p, ism.section_id, ism.sort_order, i.feedback_right,
	   i.feedback_wrong, ism.max_time_to_complete, ism.points,
	       cr.content as question_text
    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism,
         as_session_items si
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = si.section_id
    and ism.as_item_id = si.as_item_id
    and si.section_id = :section_id
    and si.session_id = :session_id
    $items_clause
    order by si.sort_order
    
      </querytext>
</fullquery>

<fullquery name="get_user_choice_answers">
    <querytext>
      select choice_id
      from as_item_data_choices
      where item_data_id = :item_data_id
    </querytext>
</fullquery>

<fullquery name="get_correct_choice_answers">
    <querytext>
      select c.choice_id
      
      from as_item_choices c
      
      where c.mc_id = (select max(t.as_item_type_id)
                       from as_item_type_mc t, cr_revisions c, as_item_rels r
                       where t.as_item_type_id = r.target_rev_id
                       and r.item_rev_id = :as_item_id
                       and r.rel_type = 'as_item_type_rel'
                       and c.revision_id = t.as_item_type_id
                       group by c.title, t.increasing_p, t.allow_negative_p,
                       t.num_correct_answers, t.num_answers)
      and c.correct_answer_p = 't'
    </querytext>
</fullquery>

</queryset>
