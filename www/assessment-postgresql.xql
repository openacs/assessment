<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT i.as_item_id, i.name, i.title, i.subtext, s.section_id as section_id, s.title as section_title, s.description as section_description
			FROM as_sectionsx s INNER JOIN as_assessment_section_map asm USING (section_id)
			INNER JOIN as_assessmentsx a USING (assessment_id)
			INNER JOIN as_item_section_map ism ON s.section_id = ism.section_id
			INNER JOIN as_itemsx i USING (as_item_id)
			WHERE a.assessment_id = :assessment_rev_id
			ORDER BY s.section_id, ism.sort_order
		</querytext>
	</fullquery>

	<fullquery name="session_start">
		<querytext>
    UPDATE as_sessions
    SET creation_datetime = NOW()
    WHERE session_id = :session_id
		</querytext>
	</fullquery>

</queryset>
