<?xml version="1.0"?>
<queryset>

<fullquery name="add_section_to_assessment">
      <querytext>

	    insert into as_assessment_section_map
	    (select :new_assessment_rev_id as assessment_id, :sect_id as section_id,
	            feedback_text, max_time_to_complete, :after as sort_order
	     from as_sections
	     where section_id = :sect_id)

      </querytext>
</fullquery>

</queryset>
