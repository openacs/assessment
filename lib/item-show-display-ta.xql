<?xml version="1.0"?>
<queryset>

<fullquery name="display_type_data">
<querytext>

    select d.html_display_options, d.abs_size, d.item_answer_alignment
    from as_item_display_ta d, as_item_rels r
    where d.as_item_display_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_display_rel'

</querytext>
</fullquery>

</queryset>
