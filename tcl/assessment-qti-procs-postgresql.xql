<?xml version="1.0"?>
<queryset>
	
	<rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
	<fullquery name="parse_item.as_item_insert">
		<querytext>
			INSERT INTO as_items (item_id, item_display_type_id, name, item_text) 
			VALUES (:item_id, :as_item__display_type_id, :as_items__name, :as_items__item_text)
		</querytext>
	</fullquery>
	
	<fullquery name="parse_item.as_item_choice_insert">
		<querytext>
			INSERT INTO as_item_choices (choice_id, name, choice_text) 
			VALUES (:choice_id, :as_item_choices__choice_text, :as_item_choices__choice_text)
		</querytext>
	</fullquery>
	
	<fullquery name="parse_item.as_item_choice_map_insert">
		<querytext>
			INSERT INTO as_item_choice_map (item_id, choice_id, sort_order) 
			VALUES (:item_id, :choice_id, :sort_order)
		</querytext>
	</fullquery>
	
</queryset>