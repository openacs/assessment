<?xml version="1.0"?>
<queryset>

	<fullquery name="as::qti::parse_qti_xml.as_assessment_section_map_insert">
		<querytext>
			INSERT INTO as_assessment_section_map (assessment_id, section_id, sort_order) 
			VALUES (:as_assessments__assessment_id, :as_sections__section_id, :as_assessment_section_map__sort_order)
		</querytext>
	</fullquery>

	<fullquery name="as::qti::parse_item.as_item_section_map_insert">
		<querytext>
			INSERT INTO as_item_section_map (as_item_id, section_id, sort_order) 
			VALUES (:as_item_id, :section_id, :as_item_section_map__sort_order)
		</querytext>
	</fullquery>

</queryset>