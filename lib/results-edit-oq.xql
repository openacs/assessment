<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

    select d.clob_answer as answer_text, t.reference_answer, t.keywords
    from as_item_type_oq t, as_item_rels r, as_item_data d
    where d.item_data_id = :item_data_id
    and t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = d.as_item_id
    and r.rel_type = 'as_item_type_rel'

</querytext>
</fullquery>

</queryset>
