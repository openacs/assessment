<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

    select d.text_answer as answer_text
    from as_item_data d
    where d.item_data_id = :item_data_id

</querytext>
</fullquery>

</queryset>
