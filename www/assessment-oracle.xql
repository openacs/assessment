<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="session_time">
	<querytext>

	select round(86400 * (sysdate - creation_datetime)) as elapsed_time
	from as_sessions
	where session_id = :session_id

	</querytext>
</fullquery>
	
<fullquery name="section_data">
	<querytext>

	select s.section_id, cr.title, cr.description, s.instructions,
	       m.max_time_to_complete, s.display_type_id, s.num_items,
	       round(86400 * (sysdate - d.creation_datetime)) as elapsed_time
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
	
<fullquery name="session_start">
	<querytext>

	update as_sessions
	set creation_datetime = sysdate
	where session_id = :session_id
	and creation_datetime is null

	</querytext>
</fullquery>

<fullquery name="session_updated">
	<querytext>

	UPDATE as_sessions
	SET last_mod_datetime = sysdate
	WHERE session_id = :session_id

	</querytext>
</fullquery>

<fullquery name="session_finished">
	<querytext>

	UPDATE as_sessions
	SET completed_datetime = sysdate
	WHERE session_id = :session_id

	</querytext>
</fullquery>

</queryset>
