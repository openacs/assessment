<?xml version="1.0"?>
<queryset>

<fullquery name="section_data">
	<querytext>

	select s.section_id, cr.title, cr.description, s.instructions,
	       m.max_time_to_complete, s.display_type_id, s.num_items
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

<fullquery name="unfinished_session_id">
	<querytext>
	select max(session_id) as session_id
        from as_sessions 
        where completed_datetime is null 
        and assessment_id = :assessment_rev_id
	</querytext>
</fullquery>
	
<fullquery name="process_item_type">
	<querytext>

	select o.object_type as item_type, r.target_rev_id as item_type_id,
	       m.points
	from acs_objects o, as_item_rels r, as_item_section_map m
	where r.item_rev_id = :response_item_id
	and r.rel_type = 'as_item_type_rel'
	and o.object_id = r.target_rev_id
	and m.as_item_id = r.item_rev_id
	and m.section_id = :section_id

	</querytext>
</fullquery>
	
</queryset>
