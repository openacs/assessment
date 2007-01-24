<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_data">
<querytext>

	select ci.name, cr.title, cr.description, a.instructions, a.run_mode, a.anonymous_p, a.secure_access_p, 
               a.reuse_responses_p, a.show_item_name_p, random_p, a.consent_page, 
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time, to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
               a.number_tries, a.wait_between_tries, a.time_for_response, a.ip_mask, a.password,
	       a.show_feedback, a.section_navigation, a.entry_page, a.exit_page, a.return_url
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

	select latest_revision as s_assessment_id
	from cr_items
	where item_id = :assessment_id

</querytext>
</fullquery>

<fullquery name="update_start_time">
<querytext>

	    update as_assessments
	    set start_time = $start_time
	    where assessment_id = :assessment_rev_id

</querytext>
</fullquery>

<fullquery name="update_end_time">
<querytext>

	    update as_assessments
	    set end_time = $end_time
	    where assessment_id = :assessment_rev_id

</querytext>
</fullquery>

<fullquery name="move_down_sections">
      <querytext>

	    update as_assessment_section_map
	    set sort_order = sort_order+1
	    where assessment_id = :new_assessment_rev_id
	    and sort_order > :after

      </querytext>
</fullquery>

<fullquery name="add_section_to_assessment">
      <querytext>

	    insert into as_assessment_section_map (assessment_id, section_id,sort_order)
	    values (:new_assessment_rev_id, :new_section_id,:sort_order)

      </querytext>
</fullquery>


</queryset>
