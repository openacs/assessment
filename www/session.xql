<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="query_all_items">
		<querytext>
			SELECT i.as_item_id, i.name, i.title, i.feedback_right, i.feedback_wrong,
			       s.section_id, s.title as section_title, s.description as section_description
			FROM as_assessmentsx a, as_sectionsx s, as_assessment_section_map asm, as_itemsx i,
			     as_item_section_map ism, as_sessionsx ss
			WHERE a.assessment_id = asm.assessment_id
			AND s.section_id = asm.section_id
			AND i.as_item_id = ism.as_item_id
			AND s.section_id = ism.section_id
			AND a.assessment_id = ss.assessment_id
			AND ss.session_id = :session_id
			ORDER BY s.section_id, ism.sort_order
		</querytext>
	</fullquery>

	<fullquery name="choices">
		<querytext>
                SELECT
                as_item_choicesx.choice_id, as_item_choicesx.title AS choice_title, as_item_choicesx.correct_answer_p, as_item_choicesx.percent_score, as_item_choicesx.text_value, as_item_choicesx.content_value
                FROM as_item_choicesx
                WHERE
                as_item_choicesx.mc_id=:mc_id
                ORDER BY
                as_item_choicesx.sort_order
		</querytext>
	</fullquery>
	
	<fullquery name="shortanswer">
		<querytext>
                SELECT as_item_datax.text_answer
                FROM as_item_datax, as_sessionsx
		WHERE as_sessionsx.session_id = as_item_datax.session_id AND as_sessionsx.session_id = :session_id  AND as_item_datax.choice_id_answer IS NULL AND as_item_datax.as_item_id = :items_as_item_id
 		</querytext>
 	</fullquery>

</queryset>
