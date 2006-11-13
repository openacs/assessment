<?xml version="1.0"?>
<queryset>

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
        and subject_id = :user_id and subject_id <> 0

	</querytext>
</fullquery>
	
<fullquery name="unfinished_section_order">
	<querytext>

	select max(s.sort_order) as section_order
        from as_session_sections s, as_section_data d
        where s.session_id = :session_id
	and d.session_id = s.session_id
	and d.section_id = s.section_id

	</querytext>
</fullquery>
	
<fullquery name="unfinished_section_id">
	<querytext>

	select section_id as unfinished_section_id
        from as_session_sections
        where session_id = :session_id
	and sort_order = :section_order

	</querytext>
</fullquery>
	
<fullquery name="unfinished_item_order">
	<querytext>

	select min(i.sort_order) as item_order
        from as_session_items i
        where i.session_id = :session_id
	and i.section_id = :unfinished_section_id
        and not exists (select 1
			from as_item_data d
			where d.session_id = :session_id
			and d.section_id = :unfinished_section_id
			and d.as_item_id = i.as_item_id)

	</querytext>
</fullquery>
	
<fullquery name="unfinished_last_item">
	<querytext>

	select max(i.sort_order) as item_order
        from as_session_items i
        where i.session_id = :session_id
	and i.section_id = :unfinished_section_id

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
	
<fullquery name="total_tries">
	<querytext>

	select count(*) as total_tries, max(session_id) as last_session_id
	from as_sessions s
	where s.subject_id = :user_id
	and s.completed_datetime is not null
	and s.assessment_id = :assessment_rev_id

	</querytext>
</fullquery>

</queryset>
