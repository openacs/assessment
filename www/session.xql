<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT as_itemsx.as_item_id, as_itemsx.name, as_itemsx.title
			FROM ((as_sectionsx INNER JOIN (as_assessmentsx INNER JOIN as_assessment_section_map ON as_assessmentsx.assessment_id=as_assessment_section_map.assessment_id) ON
			as_sectionsx.section_id=as_assessment_section_map.section_id) INNER JOIN (as_itemsx INNER JOIN as_item_section_map ON as_itemsx.as_item_id=as_item_section_map.as_item_id) ON as_sectionsx.section_id=as_item_section_map.section_id) INNER JOIN as_sessionsx ON as_assessmentsx.assessment_id = as_sessionsx.assessment_id
			WHERE as_sessionsx.session_id = :session_id
			ORDER BY as_item_section_map.sort_order
		</querytext>
	</fullquery>

	<fullquery name="choices">
		<querytext>
                SELECT
                as_item_choicesx.choice_id, as_item_choicesx.title AS choice_title, as_item_choicesx.correct_answer_p, as_item_datax.choice_id_answer
                FROM as_item_choicesx LEFT JOIN (as_item_datax INNER JOIN as_sessionsx ON as_sessionsx.session_id = as_item_datax.session_id) ON as_item_datax.choice_id_answer=as_item_choicesx.choice_id
                WHERE
                as_item_choicesx.mc_id=:mc_id
                ORDER BY
                as_item_choicesx.sort_order
		</querytext>
	</fullquery>

</queryset>
