<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_data">
<querytext>

	select cr.title, cr.description, a.instructions, a.mode,
	       a.anonymous_p, a.secure_access_p, a.reuse_responses_p, a.show_item_name_p,
	       a.entry_page, a.exit_page, a.consent_page, a.return_url, a.number_tries,
	       a.wait_between_tries, a.time_for_response, a.show_feedback, a.section_navigation,
	       to_char(a.start_time, :format) as start_time, to_char(a.end_time, :format) as end_time
	from as_assessments a, cr_revisions cr, cr_items ci
	where ci.item_id = :assessment_id
	and cr.revision_id = ci.latest_revision
	and a.assessment_id = cr.revision_id

</querytext>
</fullquery>

<fullquery name="assessment_id_from_revision">
<querytext>

	select item_id
	from cr_revisions
	where revision_id = :assessment_rev_id

</querytext>
</fullquery>

<fullquery name="rev_id_from_item_id">
<querytext>

	select latest_revision
	from cr_items
	where item_id = :assessment_id

</querytext>
</fullquery>

</queryset>
