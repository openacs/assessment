<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT as_itemsx.as_item_id, as_itemsx.name, as_itemsx.title
			FROM (as_sectionsx INNER JOIN (as_assessmentsx INNER JOIN as_assessment_section_map ON as_assessmentsx.assessment_id=as_assessment_section_map.assessment_id) ON
			as_sectionsx.section_id=as_assessment_section_map.section_id) INNER JOIN (as_itemsx INNER JOIN as_item_section_map ON as_itemsx.as_item_id=as_item_section_map.as_item_id) ON as_sectionsx.section_id=as_item_section_map.section_id
			WHERE as_assessmentsx.assessment_id=:assessment_id
			ORDER BY as_item_section_map.sort_order
		</querytext>
	</fullquery>

</queryset>
