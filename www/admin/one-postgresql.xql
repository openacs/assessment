<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="assessment_info">
		<querytext>
			select as_assessmentsx.name, as_assessmentsx.title, as_assessmentsx.creator_id, as_assessmentsx.description 
			from as_assessmentsx
			where as_assessmentsx.assessment_id=:assessment_id			
		</querytext>
	</fullquery>
	
	<fullquery name="query_all_items">
		<querytext>
			SELECT distinct as_itemsx.as_item_id, as_itemsx.name, as_itemsx.title, 'radiobutton' as presentation_type
			FROM as_itemsx
		</querytext>
	</fullquery>

</queryset>



			
