<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="as::assessment::data.get_data_by_assessment_id">
<querytext>

	select a.assessment_id as assessment_rev_id, cr.item_id as assessment_id, cr.title, ci.name,
	       cr.description, o.creation_user, o.creation_date, a.instructions, a.run_mode,
	       a.anonymous_p, a.secure_access_p, a.reuse_responses_p, a.ip_mask,
	       a.show_item_name_p, a.entry_page, a.exit_page, a.consent_page, a.return_url,
	       a.start_time, a.end_time, a.number_tries, a.wait_between_tries,
	       a.time_for_response, a.show_feedback, a.section_navigation, a.creator_id, a.survey_p
	from as_assessments a, cr_revisions cr, cr_items ci, acs_objects o
	where ci.item_id = :assessment_id
	and cr.revision_id = ci.latest_revision
	and a.assessment_id = cr.revision_id
	and o.object_id = a.assessment_id

</querytext>
</fullquery>

<fullquery name="as::assessment::calculate.check_sections_calculated">
	<querytext>

	select count(*)
	from as_assessment_section_map m, as_session_sections s
	left outer join as_section_data d on (d.section_id = s.section_id
						and d.session_id = s.session_id)
	where s.session_id = :session_id
	and m.section_id = s.section_id
	and m.assessment_id = :assessment_id
	and d.points is null

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::check_session_conditions.assessment_data">
	<querytext>

	select a.number_tries, a.wait_between_tries, a.ip_mask,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time
	from as_assessments a
	where a.assessment_id = :assessment_id

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::check_session_conditions.cur_wait_time">
	<querytext>

	select round(date_part('epoch', now() - completed_datetime)) as cur_wait_time
	from as_sessions
	where session_id = :last_session_id

	</querytext>
</fullquery>
	
</queryset>
