<?xml version="1.0"?>
<queryset>

<fullquery name="section_display_types">
      <querytext>

    select section_display_type_id, pagination_style
    from as_section_display_types

      </querytext>
</fullquery>

<fullquery name="section_data">
      <querytext>

	select ci.name, cr.title, cr.description, s.definition, s.instructions,
	       s.required_p, s.feedback_text, s.max_time_to_complete
	from as_sections s, cr_revisions cr, cr_items ci
	where cr.revision_id = s.section_id
	and ci.item_id = cr.item_id
	and s.section_id = :section_id

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

	    insert into as_assessment_section_map (assessment_id, section_id, feedback_text, max_time_to_complete, sort_order)
	    values (:new_assessment_rev_id, :section_id, :feedback_text, :max_time_to_complete, :sort_order)

      </querytext>
</fullquery>

<fullquery name="update_section_of_assessment">
      <querytext>

	    update as_assessment_section_map
	    set feedback_text = :feedback_text,
	    max_time_to_complete = :max_time_to_complete,
	    section_id = :new_section_id
	    where assessment_id = :new_assessment_rev_id
	    and section_id = :section_id

      </querytext>
</fullquery>

</queryset>
