<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT as_itemsx.as_item_id, as_itemsx.name, as_itemsx.title, 'radiobutton' as presentation_type
			FROM as_itemsx
			WHERE as_item_id = as_item_section_map.as_item_id
			AND as_sectionsx.section_id = as_assessment_section_map.section_id
			AND as_assessment_section_map.assessment_id = as_assessments.assessment_id
			AND as_assessmentsx.assessment_id = :assessment_id
		</querytext>
	</fullquery>

</queryset>
