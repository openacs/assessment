<?xml version="1.0"?>
<queryset>

<fullquery name="sections">
      <querytext>
    select s.section_id, cr.title, s.definition, s.instructions, s.required_p,
           s.feedback_text, s.max_time_to_complete
    from as_sections s, cr_revisions cr
    where cr.revision_id = s.section_id
    and s.section_id in ([join $section_id ,])
    order by s.section_id
      </querytext>
</fullquery>

<fullquery name="move_down_sections">
      <querytext>

	    update as_assessment_section_map
	    set sort_order = sort_order + :section_count
	    where assessment_id = :new_assessment_rev_id
	    and sort_order > :after

      </querytext>
</fullquery>

<fullquery name="add_section_to_assessment">
      <querytext>

	    insert into as_assessment_section_map (assessment_id, section_id, feedback_text, max_time_to_complete, sort_order)
	    values (:new_assessment_rev_id, :section_id, null, null, :after)

      </querytext>
</fullquery>

</queryset>
