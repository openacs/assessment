<?xml version="1.0"?>
<queryset>

<fullquery name="as::assessment::data.get_data_by_assessment_id">
<querytext>

	select o.package_id, a.assessment_id as assessment_rev_id, cr.item_id as assessment_id, cr.title, ci.name, ci.publish_status,
	       cr.description, coalesce(o.creation_user, o2.creation_user) as creation_user, o.creation_date, a.instructions, a.run_mode,
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
	from as_assessment_section_map m, as_session_sections s
	left outer join as_section_data d on (d.section_id = s.section_id
						and d.session_id = s.session_id)
	where s.session_id = :session_id
	and m.section_id = s.section_id
	and m.assessment_id = :assessment_id
	and d.points is null
and (select sum(i.points) from as_items i, as_item_section_map m where m.as_item_id=i.as_item_id and m.section_id = s.section_id) > 0
	</querytext>
</fullquery>

<fullquery name="as::assessment::check_session_conditions.assessment_data">
	<querytext>

	select a.number_tries, a.wait_between_tries, a.ip_mask, a.password as as_password,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS') as cur_time
	from as_assessments a
	where a.assessment_id = :assessment_id

	</querytext>
</fullquery>

<fullquery name="as::assessment::calculate.sum_of_section_points">
	<querytext>

	select coalesce(sum(m.points), 0) as section_max_points, coalesce(sum(d.points), 0) as section_points
	from as_assessment_section_map m, as_section_data d
	where m.assessment_id = :assessment_id
	and m.section_id = d.section_id
	and d.session_id = :session_id

	</querytext>
</fullquery>

<fullquery name="as::assessment::data.lookup_assessment_id">
<querytext>

	select assessment_id
	  from as_assessment_section_map
	 where section_id = :section_id	

</querytext>
</fullquery>

<fullquery name="as::assessment::edit.assessment_revision">
<querytext>

	select latest_revision
	from cr_items
	where item_id = :assessment_id

</querytext>
</fullquery>

<fullquery name="as::assessment::copy_sections.copy_sections">
<querytext>

	insert into as_assessment_section_map
	(select :new_assessment_id as assessment_id, section_id,
	        max_time_to_complete, sort_order, points
	 from as_assessment_section_map
	 where assessment_id = :assessment_id)

</querytext>
</fullquery>

<fullquery name="as::assessment::copy_categories.copy_categories">
<querytext>

	insert into category_object_map
	(select category_id, :to_id as object_id
	 from category_object_map
	 where object_id = :from_id)

</querytext>
</fullquery>

<fullquery name="as::assessment::sections.get_sorted_sections">
<querytext>

	select section_id
	from as_session_sections
	where session_id = :session_id
	order by sort_order

</querytext>
</fullquery>

<fullquery name="as::assessment::sections.assessment_sections">
<querytext>

	select m.section_id, r.title
	from as_assessment_section_map m, cr_revisions r
	where m.assessment_id = :assessment_id
	and r.revision_id = m.section_id
	order by m.sort_order

</querytext>
</fullquery>

<fullquery name="as::assessment::sections.save_order">
	<querytext>

	    insert into as_session_sections (session_id, section_id, sort_order)
	    values (:session_id, :section_id, :count)

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::calculate.update_assessment_percent">
	<querytext>

	update as_sessions
	set percent_score = :percent_score
	where session_id = :session_id
	and assessment_id = :assessment_id

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::check_session_conditions.total_tries">
	<querytext>

	select count(*) as total_tries, max(session_id) as last_session_id
	from as_sessions s, cr_revisions r, cr_revisions r2
	where s.subject_id = :subject_id
	and s.completed_datetime is not null
	and s.assessment_id = r.revision_id
	and r.item_id = r2.item_id
	and r2.revision_id = :assessment_id

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::unique_name.check_unique">
	<querytext>

	select count(*)
	from cr_items
	where name = :name

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::unique_name.check_unique_excluding_item">
	<querytext>

	select count(*)
	from cr_items
	where name = :name
	and item_id <> :item_id

	</querytext>
</fullquery>
	
</queryset>
