<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="parse_qti_xml.as_assessment_section_map_insert">
		<querytext>
			INSERT INTO as_assessment_section_map (assessment_id, section_id) 
			VALUES (:as_assessments__assessment_id, :as_sections__section_id)
		</querytext>
	</fullquery>

	<fullquery name="parse_item.as_item_choice_map_insert">
		<querytext>
			INSERT INTO as_item_choice_map (as_item_id, choice_id, sort_order) 
			VALUES (:as_item_id, :choice_id, :sort_order)
		</querytext>
	</fullquery>

	<fullquery name="parse_item.as_item_section_map_insert">
		<querytext>
			INSERT INTO as_item_section_map (as_item_id, section_id) 
			VALUES (:as_item_id, :section_id)
		</querytext>
	</fullquery>

</queryset>
