<?xml version="1.0"?>
<queryset>

<fullquery name="query_all_sections">
<querytext>
	SELECT s.section_id, s.name as section_name, s.title as section_title, s.description as section_description, s.instructions as section_instructions, s.feedback_text as section_feedback_text, s.max_time_to_complete as section_max_time_to_complete, s.num_items as section_num_items, s.points as section_points
	FROM as_sectionsx s, as_assessment_section_map asm, as_assessmentsx a
	WHERE s.section_id = asm.section_id
	     AND asm.assessment_id = a.assessment_id
	     AND a.assessment_id = :assessment_id1
	ORDER BY asm.sort_order
</querytext>
</fullquery>

<fullquery name="query_all_items">
<querytext>
	SELECT i.as_item_id, i.title as item_title, i.name as item_name, i.description as item_description, i.subtext as item_subtext, i.field_code as item_field_code, i.required_p as item_required_p, i.data_type as item_data_type, i.max_time_to_complete as item_max_time_to_complete, i.feedback_right as item_feedback_right, i.feedback_wrong as item_feedback_wrong, i.points as item_points, i.field_name
	FROM as_itemsx i, as_item_section_map ism
	WHERE i.as_item_id = ism.as_item_id AND ism.section_id = :section_id
	ORDER BY ism.sort_order
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

<fullquery name="section_display_data">
<querytext>
	SELECT asdt.title as section_display_type, asdt.num_items as s_num_items, asdt.adp_chunk as s_adp_chunk, asdt.branched_p as s_branched_p, asdt.back_button_p as s_back_button_p, asdt.submit_answer_p as s_submit_answer_p, asdt.sort_order_type as s_sort_order_type
        FROM as_section_display_typesx asdt, as_sectionsx s
	WHERE asdt.display_type_id = s.display_type_id AND s.section_id = :section_id	
</querytext>
</fullquery>

<fullquery name="item_display_rb_data">
<querytext>
        SELECT html_display_options, choice_orientation, choice_label_orientation, sort_order_type, item_answer_alignment
	FROM as_item_display_rb
	WHERE as_item_display_id=:item_display_id
</querytext>
</fullquery>

<fullquery name="item_display_cb_data">
<querytext>
        SELECT html_display_options, choice_orientation, choice_label_orientation, sort_order_type, item_answer_alignment
	FROM as_item_display_cb
	WHERE as_item_display_id=:item_display_id
</querytext>
</fullquery>

<fullquery name="item_display_ta_data">
<querytext>
        SELECT html_display_options, abs_size, item_answer_alignment
	FROM as_item_display_ta
	WHERE as_item_display_id=:item_display_id
</querytext>
</fullquery>

<fullquery name="item_display_tb_data">
<querytext>
        SELECT html_display_options, abs_size as tb_abs_size, item_answer_alignment
	FROM as_item_display_tb
	WHERE as_item_display_id=:item_display_id
</querytext>
</fullquery>

<fullquery name="item_type_data">
<querytext>

	select r.title, i.increasing_p, i.allow_negative_p, i.num_correct_answers,
	       i.num_answers
	from cr_revisions r, as_item_rels ir, as_item_type_mc i
	where r.revision_id = i.as_item_type_id
	and i.as_item_type_id = ir.target_rev_id
	and ir.item_rev_id = :as_item_id
	and ir.rel_type = 'as_item_type_rel'

</querytext>
</fullquery>

<fullquery name="get_content_type_items">
<querytext>
        select r2.revision_id as content_rev_id, r2.title as content_filename, r2.content as cr_file_name, r2.mime_type, i.content_type, i.storage_area_key
	        from cr_revisions r2, cr_items i 
                where i.item_id = r2.item_id                
		and i.latest_revision = r2.revision_id
                and r2.revision_id IN (
		    select target_rev_id 
		    from as_item_rels 
		    where rel_type = 'as_item_content_rel' 
		    and item_rev_id = :as_item_id
		)
</querytext>
</fullquery>

<fullquery name="as_item_oq">
<querytext>
        SELECT i.as_item_type_id AS id__as_item_type_oq, i.default_value, i.feedback_text
	from cr_revisions r, as_item_rels ir, as_item_type_oq i
	where r.revision_id = i.as_item_type_id	
	and i.as_item_type_id = ir.target_rev_id 
	and ir.item_rev_id = :as_item_id 
	and ir.rel_type = 'as_item_type_rel'
</querytext>
</fullquery>
</queryset>

