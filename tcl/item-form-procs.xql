<?xml version="1.0"?>
<queryset>

<fullquery name="add_item_to_form.item_choices_2">
	<querytext>
		select
		as_item_choices.choice_id, as_item_choices.choice_text
		from
		as_item_choices, as_item_choice_map, as_items
		where
		as_item_choice_map.choice_id=as_item_choices.choice_id and as_items.item_id=as_item_choice_map.item_id and as_item_choice_map.item_id=:item_id
		order by
		as_item_choice_map.sort_order
	</querytext>
</fullquery>

<fullquery name="add_item_to_form.item_choices_3">
	<querytext>
		select
		as_item_choices.choice_id, as_item_choices.choice_text, as_item_choice_map.item_id, as_item_choices.numeric_value, as_item_choice_map.sort_order
		from
		as_item_choices, as_item_choice_map, as_items
		where
		as_item_choice_map.choice_id=as_item_choices.choice_id and as_items.item_id=as_item_choice_map.item_id and as_item_choice_map.item_id=:item_id
		order by
		as_item_choice_map.sort_order
	</querytext>
</fullquery>

<fullquery name="add_item_to_form.item_properties">
	<querytext>
		select
	                 as_items.item_text, as_items.required_p, as_item_display_types.presentation_type
		from
		   as_items, as_item_display_types
		where
		   as_items.item_display_type_id=as_item_display_types.item_display_type_id and as_items.item_id=:item_id
	</querytext>
</fullquery>
</queryset>

