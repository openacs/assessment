<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="session_time">
	<querytext>

	select round(date_part('epoch', now() - creation_datetime)) as elapsed_time
	from as_sessions
	where session_id = :session_id

	</querytext>
</fullquery>
	
<fullquery name="section_data">
	<querytext>

	select s.section_id, cr.title, cr.description, s.instructions,
	       m.max_time_to_complete, s.display_type_id, s.num_items,
	       round(date_part('epoch', now() - d.creation_datetime)) as elapsed_time
	from cr_revisions cr, as_sections s, as_assessment_section_map m,
	     as_section_data d
	where cr.revision_id = s.section_id
	and s.section_id = :section_id
	and m.section_id = s.section_id
	and m.assessment_id = :assessment_rev_id
	and d.session_id = :session_id
	and d.section_id = m.section_id

	</querytext>
</fullquery>

</queryset>
