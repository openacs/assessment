<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="asssessment_id_name_definition">
		<querytext>
			SELECT as_assessments.assessment_id, as_assessments.name, as_assessments.definition, as_assessments.enable_p
			FROM as_assessments
		</querytext>
	</fullquery>
	
	<fullquery name="section_id_name_definition">
		<querytext>
			SELECT assessment_id, as_sections.section_id, as_sections.name, as_sections.definition 
			FROM as_sections JOIN as_assessment_section_map 
			ON (as_sections.section_id=as_assessment_section_map.section_id) 
			WHERE assessment_id=2
		</querytext>
	</fullquery>
	
</queryset>