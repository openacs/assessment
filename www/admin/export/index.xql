<?xml version="1.0"?>
<queryset>

<fullquery name="query_all_sections">
<querytext>
	SELECT s.section_id, s.name as section_name, s.title as section_title, s.description as section_description, s.instructions as section_instructions, s.feedback_text as section_feedback_text, s.max_time_to_complete as section_max_time_to_complete
	FROM as_sectionsx s, as_assessment_section_map asm, as_assessmentsx a
	WHERE s.section_id = asm.section_id
	     AND asm.assessment_id = a.assessment_id
	     AND a.assessment_id = :assessment_id
	ORDER BY s.section_id	    	
</querytext>
</fullquery>

<fullquery name="query_all_items">
<querytext>
	SELECT i.as_item_id, i.title as item_title, i.name as item_name, i.description as item_description, i.subtext as item_subtext, i.field_code as item_field_code, i.required_p as item_required_p, i.data_type as item_data_type, i.max_time_to_complete as item_max_time_to_complete, i.feedback_right as item_feedback_right, i.feedback_wrong as item_feedback_wrong
	FROM as_itemsx i, as_item_section_map ism
	WHERE i.as_item_id = ism.as_item_id AND ism.section_id = :section_id
	ORDER BY ism.sort_order
</querytext>
</fullquery>

<fullquery name="query_all_choices">
<querytext>
	SELECT aic.object_id as choice_id, aic.title as choice_title, aic.item_id as choice_item_id, aic.name as choice_name, aic.description as choice_description, aic.choice_id, aic.mc_id, aic.data_type as choice_data_type, aic.numeric_value as choice_numeric_value, aic.text_value as choice_text_value, aic.boolean_value as choice_boolean_value, aic.content_value as choice_content_value, aic.feedback_text as choice_feedback_text, aic.selected_p as choice_selected_p, aic.correct_answer_p as choice_correct_answer_p, aic.sort_order as choice_sort_order, aic.percent_score as choice_percent_score
	FROM as_item_choicesx aic
	WHERE aic.mc_id=:mc_id
	ORDER BY aic.sort_order
</querytext>
</fullquery>

<fullquery name="query_all_choices2">
<querytext>
	SELECT *
        FROM as_item_choicesx aic
	WHERE aic.mc_id=:mc_id
	ORDER BY aic.correct_answer_p					    
</querytext>
</fullquery>

</queryset>
