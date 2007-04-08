<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::assessment::data.get_data_by_assessment_id">
<querytext>

	select o.package_id, a.assessment_id as assessment_rev_id, cr.item_id as assessment_id, cr.title, ci.name, ci.publish_status,
	       cr.description, nvl(o.creation_user, o2.creation_user) creation_user, o.creation_date, a.instructions, a.run_mode,
	       a.anonymous_p, a.secure_access_p, a.reuse_responses_p, a.ip_mask, a.password,
	       a.show_item_name_p, a.entry_page, a.exit_page, a.consent_page, a.return_url,
	       a.start_time, a.end_time, a.number_tries, a.wait_between_tries, a.random_p,
	       a.time_for_response, a.show_feedback, a.section_navigation, a.creator_id, a.survey_p, a.type, cr.title as html_title
	from as_assessments a, cr_revisions cr, cr_items ci, acs_objects o, acs_objects o2
	where ci.item_id = :assessment_id
	and cr.revision_id = ci.latest_revision
	and a.assessment_id = cr.revision_id
	and o.object_id = ci.item_id
	and o2.object_id = cr.revision_id

</querytext>
</fullquery>

<fullquery name="as::assessment::calculate.check_sections_calculated">
	<querytext>

	select count(*)
	from as_assessment_section_map m, as_session_sections s, as_section_data d
	where d.section_id(+) = s.section_id
	and d.session_id(+) = s.session_id
	and s.session_id = :session_id
	and m.section_id = s.section_id
	and m.assessment_id = :assessment_id
	and d.points is null

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::check_session_conditions.assessment_data">
	<querytext>

	select a.number_tries, a.wait_between_tries, a.ip_mask, a.password as as_password,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') as cur_time
	from as_assessments a
	where a.assessment_id = :assessment_id

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::check_session_conditions.cur_wait_time">
	<querytext>

	select round(86400 * (sysdate - completed_datetime)) as cur_wait_time
	from as_sessions
	where session_id = :last_session_id

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::calculate.sum_of_section_points">
	<querytext>

	select nvl(sum(m.points), 0) as section_max_points, nvl(sum(d.points), 0) as section_points
	from as_assessment_section_map m, as_section_data d
	where m.assessment_id = :assessment_id
	and m.section_id = d.section_id
	and d.session_id = :session_id

	</querytext>
</fullquery>

<fullquery name="as::assessment::new.update_clobs">
    <querytext>
      update as_assessments set
      instructions=empty_clob(),consent_page=empty_clob()
      where assessment_id=:as_assessment_id
      returning instructions, consent_page into :1, :2
    </querytext>
</fullquery>

<fullquery name="as::assessment::edit.update_clobs">
    <querytext>
      update as_assessments set
      instructions=empty_clob(),consent_page=empty_clob()
      where assessment_id=:new_rev_id
      returning instructions, consent_page into :1, :2
    </querytext>
</fullquery>
  
<fullquery name="as::assessment::new_revision.update_clobs">
    <querytext>
      update as_assessments set
      instructions=empty_clob(),consent_page=empty_clob()
      where assessment_id=:new_rev_id
      returning instructions, consent_page into :1, :2
    </querytext>
</fullquery>
  
</queryset>
