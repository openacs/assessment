<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			select as_itemsx.as_item_id, as_itemsx.name, as_itemsx.title, 'radiobutton' as presentation_type
			from as_itemsx
		</querytext>
	</fullquery>

</queryset>
