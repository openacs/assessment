<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT as_itemsx.as_item_id, as_itemsx.name, as_itemsx.title, as_item_data.choice_id_answer
			FROM as_itemsx
			WHERE as_item_id = as_item_section_map.as_item_id
			AND as_sectionsx.section_id = as_assessment_section_map.section_id
			AND as_assessment_section_map.assessment_id = as_assessments.assessment_id
			AND as_assessmentsx.assessment_id = as_sessionsx.assessment_id
			AND as_sessionsx.session_id = :session_id
			AND as_item_data.session_id = :session_id
		</querytext>
	</fullquery>

	<fullquery name="choices">
		<querytext>
                SELECT
                as_item_choicesx.choice_id, as_item_choicesx.title AS choice_title, as_item_choicesx.correct_answer_p, as_item_datax.choice_id_answer
                FROM as_item_choicesx INNER JOIN as_item_datax ON as_item_datax.as_item_id=as_item_choicesx.choice_id
                WHERE
                as_item_choicesx.mc_id=:mc_id AND as_sessionsx.session_id = as_item_datax.session_id
                ORDER BY
                as_item_choicesx.sort_order
		</querytext>
	</fullquery>

</queryset>
