<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="as::assessment::data.get_data_by_assessment_id">
<querytext>

	select a.assessment_id as assessment_rev_id, cr.item_id as assessment_id, cr.title,
	       cr.description, o.creation_user, o.creation_date, a.instructions, a.mode,
	       a.anonymous_p, a.secure_access_p, a.reuse_responses_p,
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

</queryset>
