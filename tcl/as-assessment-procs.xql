<?xml version="1.0"?>
<queryset>

<fullquery name="as::assessment::data.lookup_assessment_id">
<querytext>

	select assessment_id
	  from as_assessment_section_map
	 where section_id = :section_id	

</querytext>
</fullquery>

<fullquery name="as::assessment::data.get_data_by_assessment_id">
<querytext>

	select a.assessment_id as assessment_rev_id, cr.item_id as assessment_id, cr.title,
	       cr.description, o.creation_user, o.creation_date, a.instructions, a.mode,
	       a.editable_p, a.anonymous_p, a.secure_access_p, a.reuse_responses_p,
	       a.show_item_name_p, a.entry_page, a.exit_page, a.consent_page, a.return_url,
	       a.start_time, a.end_time, a.number_tries, a.wait_between_tries,
	       a.time_for_response, a.show_feedback, a.section_navigation, a.creator_id
	from as_assessments a, cr_revisions cr, cr_items ci, acs_objects o
	where ci.item_id = :assessment_id
	and cr.revision_id = ci.latest_revision
	and a.assessment_id = cr.revision_id
	and o.object_id = a.assessment_id

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
	(select :new_assessment_id as assessment_id, section_id, feedback_text,
	        max_time_to_complete, sort_order
	 from as_assessment_section_map
	 where assessment_id = :assessment_id)

</querytext>
</fullquery>

</queryset>
