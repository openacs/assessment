<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

    select d.subject_id, d.session_id, d.section_id, d.as_item_id
    from as_item_data d
    where d.item_data_id = :item_data_id

</querytext>
</fullquery>

<fullquery name="reference_answer">
<querytext>

    select c.choice_id
    from as_item_choices c, as_item_rels r, as_item_data d
    where d.item_data_id = :item_data_id
    and c.mc_id = r.target_rev_id
    and r.item_rev_id = d.as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.correct_answer_p = 't'

</querytext>
</fullquery>

</queryset>
