<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>

	select title as section_title
	from cr_revisions
	where revision_id = :section_id

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

	    insert into as_assessment_section_map (assessment_id, section_id, max_time_to_complete, sort_order, points)
	    (select :new_assessment_rev_id as assessment_id, :new_section_id as section_id,
                    max_time_to_complete, :sort_order as sort_order, points
             from as_assessment_section_map
             where assessment_id = :new_assessment_rev_id
             and section_id = :section_id)

      </querytext>
</fullquery>

</queryset>
