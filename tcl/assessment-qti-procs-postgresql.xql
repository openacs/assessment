<?xml version="1.0"?>
<queryset>
	
	<rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
	<fullquery name="parse_qti_xml.as_assessments_insert">
		<querytext>
			INSERT INTO as_assessments (assessment_id, name, definition) 
			VALUES (:as_assessments__assessment_id, :as_assessments__name, :as_assessments__definition)
		</querytext>
	</fullquery>
	
	<fullquery name="parse_qti_xml.as_sections_insert">
		<querytext>
			INSERT INTO as_sections (section_id, name, definition) 
			VALUES (:as_sections__section_id, :as_sections__name, :as_sections__definition)
		</querytext>
	</fullquery>
	
	<fullquery name="parse_qti_xml.as_assessment_section_map_insert">
		<querytext>
			INSERT INTO as_assessment_section_map (assessment_id, section_id) 
			VALUES (:as_assessments__assessment_id, :as_sections__section_id)
		</querytext>
	</fullquery>
	
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
	
	<fullquery name="parse_item.as_item_section_map_insert">
		<querytext>
			INSERT INTO as_item_section_map (item_id, section_id) 
			VALUES (:item_id, :section_id)
		</querytext>
	</fullquery>
	
</queryset>
