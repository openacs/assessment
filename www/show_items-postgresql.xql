<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="query_all_items">      
	      <querytext>
		select as_items.item_id, as_items.item_text, as_items.required_p, as_item_display_types.presentation_type from as_items, as_item_display_types where as_items.item_display_type_id=as_item_display_types.item_display_type_id        
	      </querytext>
	</fullquery>

</queryset>

