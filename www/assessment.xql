<?xml version="1.0"?>
<queryset>

<fullquery name="section_data">
	<querytext>

	select s.section_id, cr.title, cr.description, s.instructions,
	       m.max_time_to_complete, s.display_type_id
	from cr_revisions cr, as_sections s, as_assessment_section_map m
	where cr.revision_id = s.section_id
	and s.section_id = :section_id
	and m.section_id = s.section_id
	and m.assessment_id = :assessment_rev_id

	</querytext>
</fullquery>
	
<fullquery name="display_data">
	<querytext>

	select num_items, adp_chunk, branched_p, back_button_p, submit_answer_p,
	       sort_order_type
	from as_section_display_types
	where display_type_id = :display_type_id

	</querytext>
</fullquery>
	
</queryset>
