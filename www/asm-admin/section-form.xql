<?xml version="1.0"?>
<queryset>

<fullquery name="section_display_types">
      <querytext>

    select cr.title, d.display_type_id
    from as_section_display_types d, cr_revisions cr, cr_items ci, cr_folders cf
    where cr.revision_id = d.display_type_id
    and ci.latest_revision = cr.revision_id
    and cf.folder_id = ci.parent_id
    and cf.package_id = :package_id

      </querytext>
</fullquery>

<fullquery name="section_data">
      <querytext>

	select cr.title, cr.description, s.instructions, s.display_type_id,
	       s.feedback_text, s.max_time_to_complete, s.points, s.num_items
	from as_sections s, cr_revisions cr
	where cr.revision_id = s.section_id
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

	    insert into as_assessment_section_map (assessment_id, section_id, max_time_to_complete, sort_order)
	    values (:new_assessment_rev_id, :new_section_id, :max_time_to_complete, :sort_order)

      </querytext>
</fullquery>

<fullquery name="update_section_of_assessment">
      <querytext>

	    update as_assessment_section_map
	    set max_time_to_complete = :max_time_to_complete,
	        section_id = :new_section_id
	    where assessment_id = :new_assessment_rev_id
	    and section_id = :section_id

      </querytext>
</fullquery>

</queryset>
