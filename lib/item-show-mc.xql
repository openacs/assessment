<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

    select c.title, t.increasing_p, t.allow_negative_p, t.num_correct_answers, t.num_answers,
           max(t.as_item_type_id) as as_item_type_id
    from as_item_type_mc t, cr_revisions c, as_item_rels r
    where t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.revision_id = t.as_item_type_id
    group by c.title, t.increasing_p, t.allow_negative_p,
           t.num_correct_answers, t.num_answers
</querytext>
</fullquery>

<fullquery name="get_choices">
      <querytext>

    select c.choice_id, r.title, c.correct_answer_p, c.feedback_text,
           c.selected_p, c.percent_score, c.sort_order
    from as_item_choices c, cr_revisions r
    where r.revision_id = c.choice_id
    and c.mc_id = :as_item_type_id
    order by c.sort_order

      </querytext>
</fullquery>

</queryset>
