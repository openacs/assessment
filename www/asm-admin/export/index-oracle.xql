<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="query_all_choices">
<querytext>
	SELECT aic.object_id as choice_id, aic.title as choice_title, aic.item_id as choice_item_id, aic.name as choice_name, aic.description as choice_description, aic.choice_id, aic.mc_id, aic.data_type as choice_data_type, aic.numeric_value as choice_numeric_value, aic.text_value as choice_text_value, aic.boolean_value as choice_boolean_value, aic.content_value as choice_content_value, aic.feedback_text as choice_feedback_text, aic.selected_p as choice_selected_p, aic.correct_answer_p as choice_correct_answer_p, aic.sort_order as choice_sort_order, aic.percent_score as choice_percent_score, r2.revision_id as content_rev_id, r2.title as content_filename, r2.mime_type, r2.content as cr_file_name, i.content_type, i.storage_area_key
	FROM cr_revisions r, cr_revisions r2, as_item_choicesx aic, cr_items i
	WHERE r2.revision_id(+) = aic.content_value
	and i.item_id = r2.item_id
	and aic.mc_id= :mc_id
	and r.revision_id = aic.choice_id	
	ORDER BY aic.sort_order
</querytext>
</fullquery>

<fullquery name="num_answers_correct">
<querytext>
        SELECT count(aic.correct_answer_p) as num_answers_correct
	FROM cr_revisions r, cr_revisions r2, cr_items,  as_item_choicesx aic
	WHERE r2.revision_id(+) = aic.content_value
	and i.item_id(+) = r2.item_id
	and aic.mc_id= :mc_id
	and r.revision_id = aic.choice_id
        and aic.correct_answer_p = 't'	
</querytext>
</fullquery>
</queryset>
