<?xml version="1.0"?>
<queryset>

<fullquery name="sections">
      <querytext>
    select s.section_id, cr.title, ci.name, s.instructions,
           s.feedback_text, s.max_time_to_complete, s.points
    from as_sections s, cr_revisions cr, cr_items ci
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
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

	    insert into as_assessment_section_map
		(assessment_id, section_id, sort_order, max_time_to_complete, points)
	    (select :new_assessment_rev_id as assessment_id, :section_id as section_id,
		    :after as sort_order, max_time_to_complete, points
	     from as_sections
	     where section_id = :section_id
	     and not exists (select 1
			    from as_assessment_section_map
			    where assessment_id = :new_assessment_rev_id
			    and section_id = :section_id))

      </querytext>
</fullquery>

</queryset>
