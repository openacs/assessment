<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT i.as_item_id, i.name, i.title, s.section_id as section_id, s.title as section_title, s.description as section_description
			FROM as_sectionsx s, as_assessmentsx a, as_item_section_map ism,
			     as_itemsx i
			WHERE a.assessment_id = :assessment_id
			AND s.section_id = asm.section_id
			AND asm.assessment_id = a.assessment_id
			AND s.section_id = ism.section_id
			AND i.as_item_id = ism.as_item_id
			ORDER BY s.section_id, ism.sort_order
		</querytext>
	</fullquery>

	<fullquery name="session_start">
		<querytext>
    UPDATE as_sessions
    SET creation_datetime = sysdate
    WHERE session_id = :as_session_id
		</querytext>
	</fullquery>

</queryset>
