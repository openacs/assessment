<?xml version="1.0"?>
<queryset>

<fullquery name="add_item_to_form.item_choices_2">
	<querytext>
		select
		as_item_choicesx.choice_id, as_item_choicesx.title
		from
		as_item_choicesx
		where
		as_item_choicesx.mc_id=:mc_id
		order by
		as_item_choicesx.sort_order
	</querytext>
</fullquery>

<fullquery name="add_item_to_form.item_choices_3">
	<querytext>
		select
		as_item_choicesx.choice_id, as_item_choicesx.title
		from
		as_item_choicesx
		where
		as_item_choicesx.mc_id=:mc_id
		order by
		as_item_choicesx.sort_order
	</querytext>
</fullquery>

<fullquery name="add_item_to_form.item_properties">
	<querytext>
		select
		as_itemsx.title, as_itemsx.required_p, 'checkbox' AS presentation_type
		from
		as_itemsx
		where
		as_itemsx.as_item_id=:item_id
	</querytext>
</fullquery>
</queryset>

